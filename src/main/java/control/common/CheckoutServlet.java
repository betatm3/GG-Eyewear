package control.common;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;

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
        if (session == null || session.getAttribute("utenteLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/login?errore=auth_required");
            return;
        }

        @SuppressWarnings("unchecked")
		ArrayList<ProdottoAcquistato> carrello = (ArrayList<ProdottoAcquistato>) session.getAttribute("carrello");

        if (carrello == null || carrello.isEmpty()) {
            request.setAttribute("errore", "Il tuo carrello è attualmente vuoto.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/checkout.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utenteLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/login?errore=auth_required");
            return;
        }

        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");

        @SuppressWarnings("unchecked")
		ArrayList<ProdottoAcquistato> carrello = (ArrayList<ProdottoAcquistato>) session.getAttribute("carrello");
        if (carrello == null || carrello.isEmpty()) {
            request.setAttribute("errore", "Il carrello è vuoto. Impossibile procedere.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/checkout.jsp");
            dispatcher.forward(request, response);
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
            
            request.setAttribute("errore", "Tutti i campi di spedizione e pagamento sono obbligatori.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/checkout.jsp");
            dispatcher.forward(request, response);
            return;
        }

        OrdineDAOImpl ordineDAO = new OrdineDAOImpl(ds);
        ProdottoAcquistatoDAOImpl prodottoAcquistatoDAO = new ProdottoAcquistatoDAOImpl(ds);
        DisponibileDAOImpl disponibileDAO = new DisponibileDAOImpl(ds);

        try {
            // Validazione preliminare delle disponibilità di magazzino
            for (ProdottoAcquistato item : carrello) {
                Disponibile disp = disponibileDAO.doRetrieveByKey(item.getOcchiale().getId(), item.getColore().getCodice());
                if (disp == null || disp.getQuantita() < item.getQuantita()) {
                    String nomeColore = item.getColore().getNome() != null ? item.getColore().getNome() : item.getColore().getCodice();
                    request.setAttribute("errore", "Prodotto non disponibile a magazzino in quantità sufficiente: " 
                            + item.getVersioneOcchiale().getModello() + " (" + nomeColore + ").");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/checkout.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            }

            double totale = 0.0;
            for (ProdottoAcquistato item : carrello) {
                totale += item.getVersioneOcchiale().getPrezzo() * item.getQuantita();
            }

            // Generazione e salvataggio dell'ordine
            int idOrdine = new java.util.Random().nextInt(900000) + 100000; // ID univoco a 6 cifre
            Ordine ordine = new Ordine();
            ordine.setId(idOrdine);
            ordine.setMetodoPagamento(metodoPagamento);
            ordine.setDataOrdine(LocalDateTime.now());
            ordine.setStato(Stato.IN_LAVORAZIONE);
            ordine.setTotale(totale);
            
            // Impostiamo l'utente loggato. Usiamo l'indirizzo inserito per l'ordine
            // Salviamo l'indirizzo inserito nel checkout per la spedizione dell'ordine
            Utente utenteSpedizione = utenteLoggato.clone();
            utenteSpedizione.setIndirizzo(indirizzo + ", " + cap + " " + citta);
            utenteSpedizione.setTelefono(telefono);
            ordine.setUtente(utenteSpedizione);

            ordineDAO.doSave(ordine);

            for (ProdottoAcquistato item : carrello) {
                // Genera codice riga
                int numeroRiga = new java.util.Random().nextInt(900000) + 100000;
                
                ProdottoAcquistato riga = item.clone();
                riga.setNumero(numeroRiga);
                riga.setOrdine(ordine);
                
                prodottoAcquistatoDAO.doSave(riga);

                // Aggiorna la quantità a magazzino
                Disponibile disp = disponibileDAO.doRetrieveByKey(item.getOcchiale().getId(), item.getColore().getCodice());
                int nuovaQuantita = disp.getQuantita() - item.getQuantita();
                disp.setQuantita(nuovaQuantita);
                disponibileDAO.doUpdate(disp);
            }

            // Svuota il carrello dalla sessione
            session.removeAttribute("carrello");

            request.setAttribute("successo", "Complimenti! Ordine #" + idOrdine + " effettuato con successo.");
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errore", "Errore sul database durante la finalizzazione dell'ordine. Si prega di riprovare.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/checkout.jsp");
        dispatcher.forward(request, response);
    }
}
