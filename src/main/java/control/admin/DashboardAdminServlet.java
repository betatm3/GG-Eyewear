package control.admin;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import dao.OrdineDAOImpl;
import dao.UtenteDAOImpl;
import dao.OcchialeDAOImpl;

@WebServlet("/admin/dashboard")
public class DashboardAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        OrdineDAOImpl ordineDAO = new OrdineDAOImpl(ds);
        UtenteDAOImpl utenteDAO = new UtenteDAOImpl(ds);
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);

        try {
            int totaleUtenti = utenteDAO.doCount();
            int totaleProdotti = occhialeDAO.doCount();
            int totaleOrdini = ordineDAO.doCount();
            double totaleGuadagni = ordineDAO.doTotaleIncassi();

            request.setAttribute("totaleOrdini", totaleOrdini);
            request.setAttribute("totaleGuadagni", totaleGuadagni);
            request.setAttribute("totaleUtenti", totaleUtenti);
            request.setAttribute("totaleProdotti", totaleProdotti);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel caricamento dei dati della dashboard dal database.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
