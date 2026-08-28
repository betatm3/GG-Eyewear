package control.guest;

import java.io.IOException;
import java.sql.SQLException;

import javax.sql.DataSource;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Carrello;
import model.ProdottoAcquistato;
import dao.VersioneOcchialeDAOImpl;
import dao.OcchialeDAOImpl;
import dao.ColoreDAOImpl;

@WebServlet("/carrello")
public class CarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(true);
        
		Carrello carrello = (Carrello) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new Carrello();
            session.setAttribute("carrello", carrello);
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "visualizza";
        }
        
        try {
            switch (action) {
                case "aggiungi":
                    aggiungiProdotto(request, carrello);
                    break;
                    
                case "rimuovi":
                    rimuoviProdotto(request, carrello);
                    break;
                    
                case "modificaQuantita":
                    modificaQuantita(request, carrello);
                    break;
                    
                case "svuota":
                    carrello.svuota();
                    break;
                    
                case "visualizza":
                default:
                    break;
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri del carrello non validi.");
            return;
        }

        // Supporto AJAX
        boolean isAjax = "true".equalsIgnoreCase(request.getParameter("ajax"));
        if (isAjax) {
            double totale = carrello.getTotale();
            int quantitaAggiornata = 0;
            double subtotaleAggiornato = 0.0;
                
            if (action.equalsIgnoreCase("modificaQuantita") || action.equalsIgnoreCase("aggiungi")) {
                try {
                    int id = Integer.parseInt(request.getParameter("idOcchiale"));
                    int cod = Integer.parseInt(request.getParameter("codiceVersioneOcchiale"));
                    String col = request.getParameter("coloreScelto");
                        
                    for(ProdottoAcquistato p: carrello.getProdotti()) {
                        if (p.getVersioneOcchiale().getOcchiale().getId() == id && 
                            p.getVersioneOcchiale().getCodice() == cod && 
                            p.getColore().getCodice().equalsIgnoreCase(col)) {
                            quantitaAggiornata = p.getQuantita();
                            subtotaleAggiornato = p.getVersioneOcchiale().getPrezzo()*p.getQuantita();
                        }
                    }
                } catch (NumberFormatException e) {
                    // ignore
                }
            }            
            
            response.setContentType("application/json");  
            //Informa il browser sul tipo di contenuto che gli sta per arrivare nell'header HTTP: un oggetto JSON. In questo modo, JavaScript (con l'API fetch) capirà come interpretarlo correttamente.
            response.setCharacterEncoding("UTF-8"); //codifica dei caratteri della risposta in UTF-8.
            String json = String.format(
                java.util.Locale.US,
                "{\"status\":\"success\", \"totaleCarrello\":%.2f, \"quantita\":%d, \"subtotale\":%.2f, \"carrelloVuoto\":%b}",
                totale, quantitaAggiornata, subtotaleAggiornato, carrello.isEmpty()
            );
            /* Costruisce dinamicamente la stringa formattata secondo la sintassi standard del JSON. 
             * Usojava.util.Locale.US perché in italiano (e in Europa) i numeri decimali si scrivono con la virgola (12,50), mentre lo standard JSON VUOLE il punto (12.50).
             * Forzando la Locale US, il placeholder %.2f impiegherà il punto per separare i decimali. Usando la virgola, il codice JavaScript restituirebbe un errore di sintassi (JSON.parse error)
             */
            response.getWriter().write(json);
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/guest/carrello.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    // --- METODI DI SUPPORTO ---

    private void aggiungiProdotto(HttpServletRequest request, Carrello carrello) throws NumberFormatException {
        int idOcchiale = Integer.parseInt(request.getParameter("idOcchiale"));
        int codiceVersioneOcchiale = Integer.parseInt(request.getParameter("codiceVersioneOcchiale"));
        String coloreScelto = request.getParameter("coloreScelto");
        
        ProdottoAcquistato nuovo = new ProdottoAcquistato();
        nuovo.setNumero(0); // Campo ignorato, verrà valorizzato nel Checkout
        
        OcchialeDAOImpl o = new OcchialeDAOImpl(ds);
        VersioneOcchialeDAOImpl ver = new VersioneOcchialeDAOImpl(ds);
        ColoreDAOImpl c = new ColoreDAOImpl(ds);
            
        try {
			nuovo.setOcchiale(o.doRetrieveByKey(idOcchiale));
			nuovo.setVersioneOcchiale(ver.doRetrieveByKey(codiceVersioneOcchiale, idOcchiale));
			nuovo.setColore(c.doRetrieveByCodice(coloreScelto));
		} catch (SQLException e) {
			e.printStackTrace();
		}
            
        nuovo.setQuantita(1);
            
        carrello.addProdotto(nuovo);
        
    }

    private void rimuoviProdotto(HttpServletRequest request, Carrello carrello) throws NumberFormatException {
        int idOcchiale = Integer.parseInt(request.getParameter("idOcchiale"));
        int codiceVersioneOcchiale = Integer.parseInt(request.getParameter("codiceVersioneOcchiale"));
        String coloreScelto = request.getParameter("coloreScelto");
        
        carrello.rimuoviProdotto(idOcchiale, codiceVersioneOcchiale, coloreScelto);
    }

    private void modificaQuantita(HttpServletRequest request, Carrello carrello) throws NumberFormatException {
        int idOcchiale = Integer.parseInt(request.getParameter("idOcchiale"));
        int codiceVersioneOcchiale = Integer.parseInt(request.getParameter("codiceVersioneOcchiale"));
        String coloreScelto = request.getParameter("coloreScelto");
        int nuovaQuantita = Integer.parseInt(request.getParameter("quantita"));
        
        carrello.modificaQuantita(idOcchiale, codiceVersioneOcchiale, coloreScelto, nuovaQuantita);
    }
}