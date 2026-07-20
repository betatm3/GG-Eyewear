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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;
    
    // Il GET mostra semplicemente la pagina JSP con il form di login
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	String erroreParam = request.getParameter("errore");
    	if ("auth_required".equals(erroreParam)) {
    	    request.setAttribute("errore", "Devi effettuare il login prima di effettuare altre azioni.");
    	}
    	RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/login.jsp");
    	dispatcher.forward(request, response);
    }

    // Il POST gestisce l'invio dei dati del form e l'autenticazione
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validazione campi input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errore", "Tutti i campi sono obbligatori.");
            request.getRequestDispatcher("/WEB-INF/view/common/login.jsp").forward(request, response);
            return;
        }

        UtenteDAOImpl utenteDAO = new UtenteDAOImpl(ds);

        try {
            // 3. Chiediamo al DAO di verificare le credenziali
            Utente utente = utenteDAO.doRetrieveByKey(email);

            if (utente != null) {
                // AUTENTICAZIONE RIUSCITA: Creiamo la sessione lato server
                HttpSession session = request.getSession(true);
                
                // Salviamo l'intero oggetto utente
                session.setAttribute("utenteLoggato", utente);

                if ("AMMINISTRATORE".equalsIgnoreCase(utente.getRuolo().name())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/area-utente");
                }
                return;

            } else {
                request.setAttribute("errore", "Email o password errate.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errore", "Si è verificato un errore tecnico. Riprova più tardi.");
        }

        // Se siamo arrivati qui significa che il login è fallito (credenziali errate o SQLException)
        // Rimandiamo al form di login mostrando il messaggio d'errore impostato nella request
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/login.jsp");
        dispatcher.forward(request, response);
    }
}