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
        
        // 1. Recuperiamo la sessione corrente, se esiste (passiamo 'false' per evitare di crearne una nuova)
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 2. Rimuoviamo l'attributo dell'utente (opzionale ma pulito)
            session.removeAttribute("utenteLoggato");
            
            // 3. Cancelliamo tutti i dati associati
            session.invalidate();
        }
        
        // 4. Reindirizziamo l'utente alla home
        // Usiamo sendRedirect perché lo stato sul server è cambiato (la sessione non esiste più)
        response.sendRedirect(request.getContextPath() + "/home");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
