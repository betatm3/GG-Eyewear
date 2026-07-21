package control.common;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/common/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Recuperiamo la sessione corrente, se esiste (con 'false' si evita di crearne una nuova)
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Rimuoviamo l'attributo dell'utente
            session.removeAttribute("utenteLoggato");
            // Cancelliamo tutti i dati associati
            session.invalidate();
        }
        
        // Usiamo sendRedirect perché lo stato sul server è cambiato (la sessione non esiste più)
        response.sendRedirect(request.getContextPath() + "/home");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
