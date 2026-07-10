package control.common;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javax.sql.DataSource;

import dao.UtenteDAOImpl;
import model.Utente;

@WebServlet("/common/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Il GET mostra semplicemente la pagina JSP con il form di login
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/login.jsp");
    	dispatcher.forward(request, response);
    }

    // Il POST gestisce l'invio dei dati del form e l'autenticazione
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Recuperiamo i parametri inviati dal form HTML
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validazione base dei campi input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errore", "Tutti i campi sono obbligatori.");
            request.getRequestDispatcher("/WEB-INF/view/common/login.jsp").forward(request, response);
            return;
        }

        // 2. Recuperiamo il DataSource dal contesto dell'applicazione
        DataSource ds = (DataSource) getServletContext().getAttribute("DataSource");
        UtenteDAOImpl utenteDAO = new UtenteDAOImpl(ds);

        try {
            // 3. Chiediamo al DAO di verificare le credenziali
            // NOTA: Idealmente il metodo del tuo DAO dovrebbe fare il match della password cifrata (es. con BCrypt o SHA-256)
            Utente utente = utenteDAO.doRetrieveByKey(email);

            if (utente != null) {
                
                // 4. AUTENTICAZIONE RIUSCITA: Creiamo la sessione lato server
                HttpSession session = request.getSession(true);
                
                // Salviamo l'intero oggetto utente (così avremo ID, Nome, Ruolo ecc. sempre a portata di mano)
                session.setAttribute("utenteLoggato", utente);

                // 5. AUTORIZZAZIONE (Rendrizzamento differenziato in base al ruolo)
                if ("ADMIN".equalsIgnoreCase(utente.getRuolo().name())) {
                    // Se è Admin, lo mandiamo alla dashboard di controllo
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    // Se è un Cliente normale, lo rimandiamo al catalogo o alla home
                    response.sendRedirect(request.getContextPath() + "/catalogo");
                }
                return; // Interrompiamo l'esecuzione avendo fatto il redirect

            } else {
                // Credenziali errate
                request.setAttribute("errore", "Email o password errate.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errore", "Si è verificato un errore tecnico. Riprova più tardi.");
        }

        // Se siamo arrivati qui significa che il login è fallito (credenziali errate o SQLException)
        // Rimandiamo l'utente al form di login mostrando il messaggio d'errore impostato nella request
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/login.jsp");
        dispatcher.forward(request, response);
    }
}