package control.common;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javax.sql.DataSource;

import dao.OrdineDAOImpl;
import dao.ProdottoAcquistatoDAOImpl;
import dao.DisponibileDAOImpl;

import model.Ordine;
import model.Carrello;
import model.ProdottoAcquistato;
import model.Utente;
import model.Stato;

import model.Disponibile;

@WebServlet("/common/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
		Carrello carrello = (Carrello) session.getAttribute("carrello");

        if (carrello == null || carrello.isEmpty()) {
            request.setAttribute("errore", "Il tuo carrello è attualmente vuoto.");
        }

        if (session != null) {
            if (session.getAttribute("errore") != null) {
                request.setAttribute("errore", session.getAttribute("errore"));
                session.removeAttribute("errore");
            }
            if (session.getAttribute("successo") != null) {
                request.setAttribute("successo", session.getAttribute("successo"));
                session.removeAttribute("successo");
            }
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/checkout.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
		Carrello carrello = (Carrello) session.getAttribute("carrello");

		if (carrello == null || carrello.isEmpty()) {
			session.setAttribute("errore", "Il carrello è vuoto. Impossibile procedere.");
            response.sendRedirect(request.getContextPath() + "/common/checkout");
            return;
        }

        String indirizzo = request.getParameter("indirizzo");
        String citta = request.getParameter("citta");
        String cap = request.getParameter("cap");
        String telefono = request.getParameter("telefono");
        String metodoPagamento = request.getParameter("metodoPagamento");

        // Validazione dei dati inseriti
        if (indirizzo == null || indirizzo.trim().isEmpty() ||
            citta == null || citta.trim().isEmpty() ||
            cap == null || cap.trim().isEmpty() ||
            telefono == null || telefono.trim().isEmpty() ||
            metodoPagamento == null || metodoPagamento.trim().isEmpty()) {
            
        	session.setAttribute("errore", "Tutti i campi di spedizione e pagamento sono obbligatori.");
            response.sendRedirect(request.getContextPath() + "/common/checkout");
            return;
        }

        Connection connection = null;
        try {
        	connection = ds.getConnection();
            connection.setAutoCommit(false); // Avvio Transazione SQL
        
	        OrdineDAOImpl ordineDAO = new OrdineDAOImpl(ds);
	        ProdottoAcquistatoDAOImpl prodottoAcquistatoDAO = new ProdottoAcquistatoDAOImpl(ds);
	        DisponibileDAOImpl disponibileDAO = new DisponibileDAOImpl(ds);

      
            // Verifica preliminare disponibilità magazzino
            for (ProdottoAcquistato item : carrello.getProdotti()) {
                Disponibile disp = disponibileDAO.doRetrieveByKey(item.getOcchiale().getId(), item.getColore().getCodice(), connection);
                if (disp == null || disp.getQuantita() < item.getQuantita()) {
                	connection.rollback();
                    String nomeColore = item.getColore().getNome() != null ? item.getColore().getNome() : item.getColore().getCodice();
                    session.setAttribute("errore", "Prodotto non disponibile a magazzino in quantità sufficiente: " 
                            + item.getVersioneOcchiale().getModello() + " (" + nomeColore + ").");
                    response.sendRedirect(request.getContextPath() + "/common/checkout");
                    return;
                }
            }

            // Creazione ordine
            Ordine ordine = new Ordine();
            ordine.setMetodoPagamento(metodoPagamento);
            ordine.setDataOrdine(LocalDateTime.now());
            ordine.setStato(Stato.IN_LAVORAZIONE);
            ordine.setTotale(carrello.getTotale());
            
            // Salviamo l'indirizzo inserito nel checkout per la spedizione
            Utente utenteSpedizione = utenteLoggato.clone();
            utenteSpedizione.setIndirizzo(indirizzo + ", " + cap + " " + citta);
            utenteSpedizione.setTelefono(telefono);
            ordine.setUtente(utenteSpedizione);

            int idOrdine = ordineDAO.doSave(ordine, connection);

            for (ProdottoAcquistato item : carrello.getProdotti()) {             
                ProdottoAcquistato riga = item.clone();

                riga.setOrdine(ordine);
                
                prodottoAcquistatoDAO.doSave(riga, connection);

                // Aggiorna la quantità a magazzino
                Disponibile disp = disponibileDAO.doRetrieveByKey(item.getOcchiale().getId(), item.getColore().getCodice(), connection);
                int nuovaQuantita = disp.getQuantita() - item.getQuantita();
                disp.setQuantita(nuovaQuantita);
                disponibileDAO.doUpdate(disp, connection);
            }
            // Commit se tutte le operazioni hanno avuto esito positivo
            connection.commit();

            carrello.svuota();

            session.setAttribute("successo", "Complimenti! Ordine #" + idOrdine + " effettuato con successo.");
            
        } catch (SQLException e) {
        	if (connection != null) {
                try {
                    connection.rollback(); // Storno in caso di errore DB
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            session.setAttribute("errore", "Errore sul database durante la finalizzazione dell'ordine. Si prega di riprovare.");
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/common/checkout");
    }
}
