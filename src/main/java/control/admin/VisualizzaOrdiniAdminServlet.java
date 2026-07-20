package control.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;
import java.util.ArrayList;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javax.sql.DataSource;

import model.Utente;
import model.Ordine;
import model.Stato;
import model.VersioneOcchiale;
import model.Genere;
import dao.OrdineDAOImpl;
import dao.VersioneOcchialeDAOImpl;

@WebServlet("/admin/VisualizzaOrdini")
public class VisualizzaOrdiniAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdminPrivileges(request, response)) return;

        OrdineDAOImpl ordineDAO = new OrdineDAOImpl(ds);
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);

        try {        
            String genereStr = request.getParameter("genere");
            String marca = request.getParameter("marca");
            String prezzoMinStr = request.getParameter("prezzoMin");
            String prezzoMaxStr = request.getParameter("prezzoMax");
            String statoStr = request.getParameter("stato");
            String dataInizioStr = request.getParameter("dataInizio");
            String dataFineStr = request.getParameter("dataFine");
            String metodoPagamento = request.getParameter("metodoPagamento");
            
            Stato stato = (statoStr != null && !statoStr.trim().isEmpty()) ? Stato.valueOf(statoStr.toUpperCase().trim()) : null;
            Double prezzoMin = (prezzoMinStr != null && !prezzoMinStr.trim().isEmpty()) ? Double.parseDouble(prezzoMinStr) : null;
            Double prezzoMax = (prezzoMaxStr != null && !prezzoMaxStr.trim().isEmpty()) ? Double.parseDouble(prezzoMaxStr) : null;
            
            java.time.LocalDateTime dataInizio = null;
            java.time.LocalDateTime dataFine = null;
            
            if (dataInizioStr != null && !dataInizioStr.trim().isEmpty()) 
                // Se il form usa <input type="date"> (es. "2026-07-15"), aggiungiamo l'orario di inizio giornata
                dataInizio = java.time.LocalDate.parse(dataInizioStr).atStartOfDay();
     
            if (dataFineStr != null && !dataFineStr.trim().isEmpty()) 
                // Se il form usa <input type="date">, estendiamo fino alla fine della giornata (23:59:59)
                dataFine = java.time.LocalDate.parse(dataFineStr).atTime(java.time.LocalTime.MAX);
            

            // Prima ricerca: Filtro per attributi di ordine
            Collection<Ordine> ordiniFiltrati = ordineDAO.doRetrieveByFiltri(stato, metodoPagamento, prezzoMin, prezzoMax, dataInizio, dataFine);
      
            // Seconda ricerca: Filtri legati alle caratteristiche dell'OCCHIALE
            Genere genere = (genereStr != null && !genereStr.trim().isEmpty()) ? Genere.valueOf(genereStr.toUpperCase().trim()) : null;
            boolean haFiltriOcchiale = (genere != null) || (marca != null && !marca.trim().isEmpty());

            if (haFiltriOcchiale) {
                Collection<VersioneOcchiale> versioniFiltrate = versioneDAO.doRetrieveByFiltri(
                        genere, null, null, marca, null, null, null, null);

                if (versioniFiltrate != null && !versioniFiltrate.isEmpty()) {
                    Collection<Integer> codiciVersioni = new ArrayList<>();
                    Collection<Integer> idOcchiali = new ArrayList<>();
                        
                    for (VersioneOcchiale v : versioniFiltrate) {
                        codiciVersioni.add(v.getCodice());
                        if (v.getOcchiale() != null) {
                            idOcchiali.add(v.getOcchiale().getId());
                        }
                    }
                    
                    Collection<Ordine> ordiniPerOcchiale = ordineDAO.doRetrieveByProdotti(codiciVersioni, idOcchiali);
                    
                    // Intersezione matematica sicura tra i filtri dell'ordine e i filtri dell'occhiale
                    ordiniFiltrati.retainAll(ordiniPerOcchiale);
                    
                } else { 
                    // Se i filtri dell'occhiale sono attivi ma non producono risultati, il risultato finale deve essere vuoto
                    ordiniFiltrati.clear(); 
                }
            }
                    
            request.setAttribute("listaOrdini", ordiniFiltrati);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/admin/visualizzaOrdini.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException | NumberFormatException | java.time.format.DateTimeParseException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel caricamento o nel filtraggio cronologico degli ordini.");
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    private boolean checkAdminPrivileges(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Utente utente = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;
        
        if (utente == null || !utente.isAdmin()) {
            request.setAttribute("messaggioErrore", "Accesso negato: area riservata agli amministratori.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/errors/errorePermessi.jsp");
            dispatcher.forward(request, response);
            return false;
        }
        return true;
    } 
}
