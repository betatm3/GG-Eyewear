package control.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javax.sql.DataSource;

import model.Utente;
import model.Ordine;
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
            Collection<Ordine> ordiniVisualizzati;

            // 2. Recupero dei parametri di filtro dal form della JSP
            String genereStr = request.getParameter("genere");
            String materiale = request.getParameter("materiale");
            String forma = request.getParameter("forma");
            String marca = request.getParameter("marca");
            String colore = request.getParameter("colore");
            String taglia = request.getParameter("taglia");
            String prezzoMinStr = request.getParameter("prezzoMin");
            String prezzoMaxStr = request.getParameter("prezzoMax");

            Genere genere = (genereStr != null && !genereStr.trim().isEmpty()) ? Genere.valueOf(genereStr.toUpperCase().trim()) : null;
            Double prezzoMin = (prezzoMinStr != null && !prezzoMinStr.trim().isEmpty()) ? Double.parseDouble(prezzoMinStr) : null;
            Double prezzoMax = (prezzoMaxStr != null && !prezzoMaxStr.trim().isEmpty()) ? Double.parseDouble(prezzoMaxStr) : null;

            Collection<VersioneOcchiale> versioniFiltrate = versioneDAO.doRetrieveByFiltri(
            		genere, materiale, forma, marca, colore, taglia, prezzoMin, prezzoMax);

                if (versioniFiltrate != null && !versioniFiltrate.isEmpty()) {
                    Collection<Integer> codiciVersioni = new ArrayList<>();
                    Collection<Integer> idOcchiali = new ArrayList<>();
                    
                    for (VersioneOcchiale v : versioniFiltrate) {
                        codiciVersioni.add(v.getCodice());
                        if (v.getOcchiale() != null) {
                            idOcchiali.add(v.getOcchiale().getId());
                        }
                    }

                    ordiniVisualizzati = ordineDAO.doRetrieveByProdotti(codiciVersioni, idOcchiali);
                    //SE NESSUN FILTRO E' STATO SELEZIONATO, VERRANNO RESTITUITI SEMPLICEMENTE TUTTI GLI ORDINI
                } else { 
                    ordiniVisualizzati = new ArrayList<>(); //nessun occhiale corrisponde ai filtri, quindi non ci sono ordini da mostrare
                }
                    
            request.setAttribute("listaOrdini", ordiniVisualizzati);
            request.getRequestDispatcher("/WEB-INF/view/admin/visualizzaOrdini.jsp").forward(request, response);

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel caricamento o nel filtraggio degli ordini.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    private boolean checkAdminPrivileges(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Utente utente = (session != null) ? (Utente) session.getAttribute("utente") : null;
        
        if (utente == null || !utente.isAdmin()) {
            request.setAttribute("messaggioErrore", "Accesso negato: area riservata agli amministratori.");
            request.getRequestDispatcher("/WEB-INF/view/errors/errorePermessi.jsp").forward(request, response);
            return false;
        }
        return true;
    }
}
