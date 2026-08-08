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
import javax.sql.DataSource;

import model.Ordine;
import model.Stato;
import model.Occhiale;
import model.Tipologia;
import model.VersioneOcchiale;
import dao.OcchialeDAOImpl;
import dao.OrdineDAOImpl;
import dao.VersioneOcchialeDAOImpl;

@WebServlet("/admin/GestioneOrdini")
public class GestioneOrdiniAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        OrdineDAOImpl ordineDAO = new OrdineDAOImpl(ds);
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);

        try {        
            String tipoStr = request.getParameter("tipologia");
            String marca = request.getParameter("marca");
            String prezzoMinStr = request.getParameter("prezzoMin");
            String prezzoMaxStr = request.getParameter("prezzoMax");
            String statoStr = request.getParameter("stato");
            String dataInizioStr = request.getParameter("dataInizio");
            String dataFineStr = request.getParameter("dataFine");
            String metodoPagamento = request.getParameter("metodoPagamento");
            String emailUtente = request.getParameter("emailUtente");
            
            Tipologia tipo = (tipoStr != null && !tipoStr.trim().isEmpty()) ? Tipologia.valueOf(tipoStr.toUpperCase().trim()) : null;
            if (marca != null && marca.trim().isEmpty()) marca = null;
            if (marca != null && marca.trim().isEmpty()) marca = null;
            if (statoStr != null && statoStr.trim().isEmpty()) statoStr = null;
            if (metodoPagamento != null && metodoPagamento.trim().isEmpty()) metodoPagamento = null;
            if (emailUtente != null && emailUtente.trim().isEmpty()) emailUtente = null;
            
            Stato stato = (statoStr != null && !statoStr.trim().isEmpty()) ? Stato.valueOf(statoStr.toUpperCase().trim()) : null;
            Double prezzoMin = (prezzoMinStr != null && !prezzoMinStr.trim().isEmpty()) ? Double.parseDouble(prezzoMinStr) : null;
            Double prezzoMax = (prezzoMaxStr != null && !prezzoMaxStr.trim().isEmpty()) ? Double.parseDouble(prezzoMaxStr) : null;
            
            java.time.LocalDateTime dataInizio = null;
            java.time.LocalDateTime dataFine = null;
            
            if (dataInizioStr != null && !dataInizioStr.trim().isEmpty()) 
                // Se il form usa <input type="date">, aggiungiamo l'orario di inizio giornata
                dataInizio = java.time.LocalDate.parse(dataInizioStr).atStartOfDay();
     
            if (dataFineStr != null && !dataFineStr.trim().isEmpty()) 
                // Se il form usa <input type="date">, estendiamo fino alla fine della giornata (23:59:59)
                dataFine = java.time.LocalDate.parse(dataFineStr).atTime(java.time.LocalTime.MAX);
            

            // Prima ricerca: Filtro per attributi di ordine
            Collection<Ordine> ordiniFiltrati = ordineDAO.doRetrieveByFiltri(stato, metodoPagamento, prezzoMin, prezzoMax, dataInizio, dataFine, emailUtente);
      
            // Seconda ricerca: Filtri legati alle caratteristiche dell'OCCHIALE
            if (marca!=null) {
                Collection<VersioneOcchiale> versioniFiltrate = versioneDAO.doRetrieveByMarca(marca);

                if (versioniFiltrate != null && !versioniFiltrate.isEmpty()) {
                    Collection<Integer> codiciVersioni = new ArrayList<>();
                    Collection<Integer> idOcchiali = new ArrayList<>();
                        
                    for (VersioneOcchiale v : versioniFiltrate) {
                        codiciVersioni.add(v.getCodice());
                        idOcchiali.add(v.getOcchiale().getId());
                    }
                    
                    Collection<Ordine> ordiniPerMarca = ordineDAO.doRetrieveByProdotti(codiciVersioni, idOcchiali);
                    
                    // Intersezione matematica sicura tra i filtri dell'ordine e i filtri dell'occhiale
                    ordiniFiltrati.retainAll(ordiniPerMarca);
                    
                } else { 
                    // Se i filtri dell'occhiale sono attivi ma non producono risultati, il risultato finale deve essere vuoto
                    ordiniFiltrati.clear(); 
                }
            }
            
            if (tipo!=null) {
            	Collection<Occhiale> occhialiFiltrati = occhialeDAO.doRetrieveByTipologia(tipo);
            	if (occhialiFiltrati != null && !occhialiFiltrati.isEmpty()) {
                    Collection<Integer> idOcchiali = new ArrayList<>();
                    for (Occhiale o : occhialiFiltrati) {
                        idOcchiali.add(o.getId());
                    }
                    
                    Collection<Ordine> ordiniPerOcchiale = ordineDAO.doRetrieveByProdotti(idOcchiali);
                    ordiniFiltrati.retainAll(ordiniPerOcchiale);
                } else {
                    ordiniFiltrati.clear();
                }
            }
            
            request.setAttribute("listaOrdini", ordiniFiltrati);

            // --- GESTIONE RISPOSTA DINAMICA ---
            boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

            if (isAjax) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/admin/tabellaOrdini.jsp");
                dispatcher.forward(request, response);
            } else {
                // Caricamento standard della pagina dell'admin
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/admin/gestioneOrdini.jsp");
                dispatcher.forward(request, response);
            }

        } catch (SQLException | NumberFormatException | java.time.format.DateTimeParseException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel caricamento o nel filtraggio cronologico degli ordini.");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}