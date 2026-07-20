package control.common;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javax.sql.DataSource;

import dao.RecensioneDAOImpl;
import model.Recensione;
import model.Utente;

@WebServlet("/recensione")
public class RecensioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Utente utenteLoggato = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;
        
        String occhialeIdStr = request.getParameter("occhialeId");
        String votoStr = request.getParameter("voto");
        String descrizione = request.getParameter("descrizione");
        
        if (occhialeIdStr == null || votoStr == null || descrizione == null) {
            response.sendRedirect(request.getContextPath() + "/catalogo");
            return;
        }
        
        int occhialeId = Integer.parseInt(occhialeIdStr);
        int voto = Integer.parseInt(votoStr);
        
        String email = (utenteLoggato != null) ? utenteLoggato.getEmail() : request.getParameter("utenteEmail");
        if (email == null || email.trim().isEmpty()) {
            email = "cliente@example.com";
        }
        
        RecensioneDAOImpl recensioneDAO = new RecensioneDAOImpl(ds);
        try {
            Recensione esistente = recensioneDAO.doRetrieveByKey(email, occhialeId);
            Recensione r = new Recensione(email, occhialeId, descrizione, voto);
            if (esistente != null) {
                recensioneDAO.doUpdate(r);
            } else {
                recensioneDAO.doSave(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/occhiale?id=" + occhialeId + "#recensioni");
    }
}
