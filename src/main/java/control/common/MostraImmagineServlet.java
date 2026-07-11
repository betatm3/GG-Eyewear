package control.common;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import dao.OcchialeDAOImpl;
import model.Occhiale;

@WebServlet("/mostraImmagine")
public class MostraImmagineServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Recuperiamo l'ID dell'occhiale dai parametri dell'URL
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            // Se non c'è l'ID, possiamo inviare un errore 400 (Bad Request) o un'immagine di default
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID immagine mancante.");
            return;
        }

        int idOcchiale;
        try {
            idOcchiale = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID immagine non valido.");
            return;
        }

        // 2. Recuperiamo il DataSource dal contesto e istanziamo il DAO
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);

        try {
            // 3. Recuperiamo l'oggetto dal database tramite l'ID
            Occhiale occhiale = occhialeDAO.doRetrieveByKey(idOcchiale);

            if (occhiale != null && occhiale.getImmagine() != null) {
                byte[] immagineBytes = occhiale.getImmagine();

                // 4. Configura la risposta HTTP per dire al browser che stiamo inviando un'immagine
                // NOTA: Se salvi sia PNG che JPEG, andrebbe bene un tipo generico come "image/jpeg"
                response.setContentType("image/jpeg"); 
                response.setContentLength(immagineBytes.length);

                // 5. Scriviamo i byte direttamente nello stream di output della risposta
                response.getOutputStream().write(immagineBytes);
                response.getOutputStream().flush();
            } else {
                // Se l'occhiale o l'immagine non esistono, possiamo reindirizzare a un'immagine "placeholder" di default
                // presente nelle cartelle del tuo progetto (es. /images/no-image.png)
                String defaultPath = request.getContextPath() + "/images/no-image.png";
                response.sendRedirect(defaultPath);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel recupero dell'immagine dal database.");
        }
    }

    // Il doPost non serve, le immagini vengono richieste solo in GET
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}