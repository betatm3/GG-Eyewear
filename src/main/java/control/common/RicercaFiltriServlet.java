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

    // Iniettiamo il DataSource configurato nel contesto del server
    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Recupero dei parametri stringa inviati dal form di ricerca
        String genereStr = request.getParameter("genere");
        String materiale = request.getParameter("materiale");
        String forma = request.getParameter("forma");
        String marca = request.getParameter("marca");
        String colore = request.getParameter("colore");
        String taglia = request.getParameter("taglia");
        
        String prezzoMinStr = request.getParameter("prezzoMin");
        String prezzoMaxStr = request.getParameter("prezzoMax");

        // 2. Sanificazione delle stringhe: se vuote o composte solo da spazi, diventano null
        if (materiale != null && materiale.trim().isEmpty()) materiale = null;
        if (forma != null && forma.trim().isEmpty()) forma = null;
        if (marca != null && marca.trim().isEmpty()) marca = null;
        if (colore != null && colore.trim().isEmpty()) colore = null;
        if (taglia != null && taglia.trim().isEmpty()) taglia = null;

        // 3. Conversione del parametro Genere in Enum (se presente)
        Genere genere = null;
        if (genereStr != null && !genereStr.trim().isEmpty()) {
            try {
                // Converte la stringa (es. "UOMO" o "DONNA") nel rispettivo valore dell'Enum
                genere = Genere.valueOf(genereStr.toUpperCase().trim());
            } catch (IllegalArgumentException e) {
                genere = null; // Se il valore non corrisponde a nessun Enum, ignoriamo il filtro
            }
        }

        // 4. Parsing sicuro dei prezzi Double (se inseriti)
        Double prezzoMin = null;
        if (prezzoMinStr != null && !prezzoMinStr.trim().isEmpty()) {
            try {
                prezzoMin = Double.parseDouble(prezzoMinStr);
            } catch (NumberFormatException e) {
                prezzoMin = null; // Forza a null se l'input non è un numero valido
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

        // 5. Interrogazione del DAO
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);
        
        try {
            // Eseguiamo la ricerca avanzata passando tutti i parametri processati
            Collection<VersioneOcchiale> versioniFiltrate = versioneDAO.doRetrieveByFiltri(
                genere, materiale, forma, marca, colore, taglia, prezzoMin, prezzoMax);

            // 6. Passiamo i dati alla JSP per la visualizzazione grafica
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

        // 7. Inoltro dei risultati alla pagina del catalogo generale o a una pagina risultati dedicata
        request.getRequestDispatcher("/WEB-INF/view/common/catalogo.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Le ricerche web standard sfruttano il metodo GET per consentire agli utenti 
        // di condividere o salvare nei segnalibri l'URL con i filtri già impostati
        doGet(request, response);
    }
}