package control.common;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import model.VersioneOcchiale;
import model.Genere; // Assicurati che il package sia corretto
import dao.VersioneOcchialeDAOImpl; // Sostituisci con il tuo package reale

@WebServlet("/ricercaFiltri")
public class RicercaFiltriServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String genereStr = request.getParameter("genere");
        String materiale = request.getParameter("materiale");
        String forma = request.getParameter("forma");
        String marca = request.getParameter("marca");
        String colore = request.getParameter("colore");
        String taglia = request.getParameter("taglia");
        String prezzoMinStr = request.getParameter("prezzoMin");
        String prezzoMaxStr = request.getParameter("prezzoMax");

        // Sanificazione delle stringhe
        if (materiale != null && materiale.trim().isEmpty()) materiale = null;
        if (forma != null && forma.trim().isEmpty()) forma = null;
        if (marca != null && marca.trim().isEmpty()) marca = null;
        if (colore != null && colore.trim().isEmpty()) colore = null;
        if (taglia != null && taglia.trim().isEmpty()) taglia = null;

        Genere genere = null;
        if (genereStr != null && !genereStr.trim().isEmpty()) {
            try {
                genere = Genere.valueOf(genereStr.toUpperCase().trim());
            } catch (IllegalArgumentException e) {
                genere = null; 
            }
        }

        // Parsing sicuro dei prezzi Double
        Double prezzoMin = null;
        if (prezzoMinStr != null && !prezzoMinStr.trim().isEmpty()) {
            try {
                prezzoMin = Double.parseDouble(prezzoMinStr);
            } catch (NumberFormatException e) {
                prezzoMin = null;
            }
        }

        Double prezzoMax = null;
        if (prezzoMaxStr != null && !prezzoMaxStr.trim().isEmpty()) {
            try {
                prezzoMax = Double.parseDouble(prezzoMaxStr);
            } catch (NumberFormatException e) {
                prezzoMax = null;
            }
        }

        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);
        
        try {
            // Eseguiamo la ricerca avanzata 
            Collection<VersioneOcchiale> versioniFiltrate = versioneDAO.doRetrieveByFiltri(
                genere, materiale, forma, marca, colore, taglia, prezzoMin, prezzoMax);

            request.setAttribute("prodotti", versioniFiltrate);
            
            // Opzionale: rimandiamo indietro i filtri selezionati per mantenerli "attivi" nei campi del form
            request.setAttribute("genereSelezionato", genereStr);
            request.setAttribute("materialeSelezionato", materiale);
            request.setAttribute("formaSelezionata", forma);
            request.setAttribute("marcaSelezionata", marca);
            request.setAttribute("coloreSelezionato", colore);
            request.setAttribute("tagliaSelezionata", taglia);
            request.setAttribute("prezzoMinSelezionato", prezzoMin);
            request.setAttribute("prezzoMaxSelezionato", prezzoMax);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Impossibile elaborare i filtri di ricerca.");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/view/common/catalogo.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}