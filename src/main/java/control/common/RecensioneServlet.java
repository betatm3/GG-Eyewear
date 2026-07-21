package control.common;

import java.io.IOException;
import java.sql.SQLException;
import javax.sql.DataSource;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Recensione;
import model.Utente;
import dao.RecensioneDAOImpl;

@WebServlet("/common/recensione")
public class RecensioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Utente utenteLoggato = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;
        
        if (utenteLoggato == null) {
            response.sendRedirect(request.getContextPath() + "/login?errore=auth_required");
            return;
        }

        // 2. Recupero e validazione dei parametri della form
        String occhialeIdStr = request.getParameter("occhialeId");
        String votoStr = request.getParameter("voto");
        String descrizione = request.getParameter("descrizione");
        
        if (occhialeIdStr == null || votoStr == null || descrizione == null || descrizione.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/catalogo");
            return;
        }
        
        try {
            int occhialeId = Integer.parseInt(occhialeIdStr);
            int voto = Integer.parseInt(votoStr);
            
            // 3. Prendiamo l'email direttamente ed unicamente dall'oggetto sessione dell'utente autenticato
            String email = utenteLoggato.getEmail();
            
            RecensioneDAOImpl recensioneDAO = new RecensioneDAOImpl(ds);
            
            // Verifichiamo se l'utente ha già lasciato una recensione per questo occhiale
            Recensione esistente = recensioneDAO.doRetrieveByKey(email, occhialeId);
            Recensione r = new Recensione(email, occhialeId, descrizione, voto);
            
            if (esistente != null) {
                // Se esiste già, aggiorniamo la recensione precedente
                recensioneDAO.doUpdate(r);
            } else {
                // Altrimenti salviamo la nuova recensione
                recensioneDAO.doSave(r);
            }
            
            // Reindirizziamo l'utente alla scheda prodotto, posizionandolo sulla sezione #recensioni
            response.sendRedirect(request.getContextPath() + "/occhiale?id=" + occhialeId + "#recensioni");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/catalogo");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/catalogo?error=db");
        }
    }
}