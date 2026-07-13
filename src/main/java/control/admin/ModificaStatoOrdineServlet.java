package control.admin;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javax.sql.DataSource;

import dao.OrdineDAOImpl;
import model.Ordine;
import model.Stato;
import model.Utente;

@WebServlet("/admin/ModificaStato")
public class ModificaStatoOrdineServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdminPrivileges(request, response)) return;

        String idOrdineStr = request.getParameter("idOrdine");
        String nuovoStatoStr = request.getParameter("nuovoStato");

        if (idOrdineStr == null || nuovoStatoStr == null || idOrdineStr.trim().isEmpty() || nuovoStatoStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri mancanti per la modifica dello stato.");
            return;
        }

        try {
            int idOrdine = Integer.parseInt(idOrdineStr);
            Stato nuovoStato = Stato.valueOf(nuovoStatoStr.toUpperCase().trim());

            OrdineDAOImpl ordineDAO = new OrdineDAOImpl(ds);
            Ordine ordine = ordineDAO.doRetrieveByKey(idOrdine);

            if (ordine != null) {
                // Controllo per impedire la retrocessione dello stato dell'ordine
                if (ordine.getStato() != null && nuovoStato.ordinal() < ordine.getStato().ordinal()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Non è possibile retrocedere lo stato dell'ordine.");
                    return;
                }
                
                ordine.setStato(nuovoStato);
                if (ordineDAO.doUpdate(ordine)) {
                    response.sendRedirect(request.getContextPath() + "/admin/VisualizzaOrdini?msg=StatoAggiornato");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Impossibile aggiornare lo stato dell'ordine nel database.");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Ordine non trovato.");
            }

        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Stato dell'ordine non valido.");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore durante l'accesso al database.");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Metodo GET non supportato per questa operazione.");
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
