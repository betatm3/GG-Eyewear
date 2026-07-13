package control.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javax.sql.DataSource;

import dao.OrdineDAOImpl;
import dao.UtenteDAOImpl;
import dao.OcchialeDAOImpl;
import model.Ordine;
import model.Utente;

@WebServlet("/admin/dashboard")
public class DashboardAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdminPrivileges(request, response)) return;

        OrdineDAOImpl ordineDAO = new OrdineDAOImpl(ds);
        UtenteDAOImpl utenteDAO = new UtenteDAOImpl(ds);
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);

        try {
            // 1. Recupera tutti gli ordini per calcolare il numero di ordini e i guadagni totali
            Collection<Ordine> ordini = ordineDAO.doRetrieveAll(null);
            int totaleOrdini = (ordini != null) ? ordini.size() : 0;
            double totaleGuadagni = 0.0;
            
            if (ordini != null) {
                for (Ordine o : ordini) {
                    totaleGuadagni += o.getTotale();
                }
            }

            // 2. Recupera il numero totale di utenti registrati
            int totaleUtenti = utenteDAO.doRetrieveAll(null).size();

            // 3. Recupera il numero totale di occhiali nel catalogo
            int totaleProdotti = occhialeDAO.doRetrieveAll(null).size();

            // 4. Imposta gli attributi per la JSP
            request.setAttribute("totaleOrdini", totaleOrdini);
            request.setAttribute("totaleGuadagni", totaleGuadagni);
            request.setAttribute("totaleUtenti", totaleUtenti);
            request.setAttribute("totaleProdotti", totaleProdotti);

            // Inoltra alla pagina JSP
            request.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel caricamento dei dati della dashboard dal database.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    private boolean checkAdminPrivileges(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Utente utente = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;
        
        if (utente == null || !utente.isAdmin()) {
            request.setAttribute("messaggioErrore", "Accesso negato: area riservata agli amministratori.");
            request.getRequestDispatcher("/WEB-INF/view/errors/errorePermessi.jsp").forward(request, response);
            return false;
        }
        return true;
    }
}
