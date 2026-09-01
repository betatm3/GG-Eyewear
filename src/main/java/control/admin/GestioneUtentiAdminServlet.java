package control.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

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
import model.Ruolo;

@WebServlet("/admin/GestioneUtenti")
public class GestioneUtentiAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	
    	HttpSession session = request.getSession(false);
        if (session != null) {
            if (session.getAttribute("msgSuccesso") != null) {
                request.setAttribute("msgSuccesso", session.getAttribute("msgSuccesso"));
                session.removeAttribute("msgSuccesso");
            }
            if (session.getAttribute("msgErrore") != null) {
                request.setAttribute("msgErrore", session.getAttribute("msgErrore"));
                session.removeAttribute("msgErrore");
            }
        }
        
        UtenteDAOImpl utenteDAO = new UtenteDAOImpl(ds);
        try {
        	Collection<Utente> utenti = utenteDAO.doRetrieveAll(null);
            request.setAttribute("listaUtenti", utenti);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/admin/gestioneUtenti.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel recupero degli utenti dal database.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Recupera la sessione e l'utente attualmente loggato (amministratore che esegue l'azione)
        HttpSession session = request.getSession(false);
        Utente adminCorrente = (Utente) session.getAttribute("utenteLoggato");

        String emailParam = request.getParameter("email");
        String action = request.getParameter("action");

        // Controllo validità dati e sessione
        if (emailParam == null || emailParam.trim().isEmpty() || action == null || action.trim().isEmpty()) {
        	session.setAttribute("msgErrore", "Parametri di richiesta mancanti o non validi.");
        	response.sendRedirect(request.getContextPath() + "/admin/GestioneUtenti");
            return;
        }

        // NO AUTO-MODIFICA (auto-disattivazione o auto-retrocessione)
        if (adminCorrente.getEmail().equalsIgnoreCase(emailParam.trim())) {
            session.setAttribute("msgErrore", "Operazione non consentita: non puoi disattivare o promuovere/retrocedere te stesso.");
            response.sendRedirect(request.getContextPath() + "/admin/GestioneUtenti");
            return;
        }

        UtenteDAOImpl utenteDAO = new UtenteDAOImpl(ds);

        try {
            Utente targetUser = utenteDAO.doRetrieveByKey(emailParam.trim());
            if (targetUser != null) {
                
                // Operazione 1: Attivazione / Disattivazione logica
                if ("toggleAttivo".equalsIgnoreCase(action)) {
                    boolean nuovoStato = !targetUser.isAttivo();
                    utenteDAO.doToggleAttivo(targetUser.getEmail(), nuovoStato);
                    session.setAttribute("msgSuccesso", "Stato dell'utente " + targetUser.getEmail() + " aggiornato con successo.");
                
                // Operazione 2: Promozione / Retrocessione
                } else if ("promuovi".equalsIgnoreCase(action)) {
                    if (targetUser.getRuolo() == Ruolo.ADMIN) {
                        // Se è già Admin, retrocedo a Utente 
                        targetUser.setRuolo(Ruolo.USER);
                        utenteDAO.doUpdate(targetUser);
                        session.setAttribute("msgSuccesso", "L'utente " + targetUser.getEmail() + " è stato retrocesso a Utente standard.");
                    } else {
                        // Se è User, promuovo a Admin
                        targetUser.setRuolo(Ruolo.ADMIN);
                        utenteDAO.doUpdate(targetUser);
                        session.setAttribute("msgSuccesso", "L'utente " + targetUser.getEmail() + " è stato promosso ad Amministratore.");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("msgErrore", "Errore sul database durante la modifica.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/GestioneUtenti");
    }
}
