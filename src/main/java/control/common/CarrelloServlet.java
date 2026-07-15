package control.common;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.sql.DataSource;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.ProdottoAcquistato; // Sostituisci con il package corretto del tuo Bean
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
        
        // 1. Recuperiamo la sessione (o la creiamo)
        HttpSession session = request.getSession(true);
        
        // 2. Recuperiamo il carrello dalla sessione (usando ArrayList)
  
        @SuppressWarnings("unchecked")//per togliere warning gialli che dava a carrello
		ArrayList<ProdottoAcquistato> carrello = (ArrayList<ProdottoAcquistato>) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new ArrayList<>();
            session.setAttribute("carrello", carrello);
        }
        
        // 3. Leggiamo l'azione richiesta
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
                    carrello.clear();
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
            double totale = 0.0;
            int quantitaAggiornata = 0;
            double subtotaleAggiornato = 0.0;
            for (ProdottoAcquistato p : carrello) {
                double sub = p.getVersioneOcchiale().getPrezzo() * p.getQuantita();
                totale += sub;
                
                if (action.equalsIgnoreCase("modificaQuantita") || action.equalsIgnoreCase("aggiungi")) {
                    try {
                        int id = Integer.parseInt(request.getParameter("idOcchiale"));
                        int cod = Integer.parseInt(request.getParameter("codiceVersioneOcchiale"));
                        String col = request.getParameter("coloreScelto");
                        
                        if (p.getVersioneOcchiale().getOcchiale().getId() == id && 
                            p.getVersioneOcchiale().getCodice() == cod && 
                            p.getColore().getCodice().equalsIgnoreCase(col)) {
                            quantitaAggiornata = p.getQuantita();
                            subtotaleAggiornato = sub;
                        }
                    } catch (NumberFormatException e) {
                        // ignore
                    }
                }
            }
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            String json = String.format(
                java.util.Locale.US,
                "{\"status\":\"success\", \"totaleCarrello\":%.2f, \"quantita\":%d, \"subtotale\":%.2f, \"carrelloVuoto\":%b}",
                totale, quantitaAggiornata, subtotaleAggiornato, carrello.isEmpty()
            );
            response.getWriter().write(json);
            return;
        }
        
        // 4. Inoltro alla pagina JSP per la visualizzazione grafica
        request.getRequestDispatcher("/WEB-INF/view/common/carrello.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    // --- METODI PRIVATI DI SUPPORTO CON LOGICA SU ARRAYLIST ---

    private void aggiungiProdotto(HttpServletRequest request, ArrayList<ProdottoAcquistato> carrello) throws NumberFormatException {
        int idOcchiale = Integer.parseInt(request.getParameter("idOcchiale"));
        int codiceVersioneOcchiale = Integer.parseInt(request.getParameter("codiceVersioneOcchiale"));
        String coloreScelto = request.getParameter("coloreScelto");
        
        // Controlliamo se lo STESSO identico prodotto (stessa versione e colore) è già nel carrello
        ProdottoAcquistato giaEsistente = null;
        for (ProdottoAcquistato p : carrello) {
            if (p.getVersioneOcchiale().getOcchiale().getId() == idOcchiale && 
                p.getVersioneOcchiale().getCodice() == codiceVersioneOcchiale && 
                p.getColore().getCodice().equalsIgnoreCase(coloreScelto)) {
            	
                giaEsistente = p;
                giaEsistente.setQuantita(giaEsistente.getQuantita() + 1);
                break;
            }
        }
        
        if (giaEsistente == null) {
            // Se è un prodotto nuovo, creiamo l'oggetto (lasciando 'numero' a 0 come da tua logica)
            ProdottoAcquistato nuovo = new ProdottoAcquistato();
            nuovo.setNumero(0); // Campo ignorato per ora, verrà valorizzato nel Checkout
            OcchialeDAOImpl o = new OcchialeDAOImpl(ds);
            VersioneOcchialeDAOImpl ver = new VersioneOcchialeDAOImpl(ds);
            ColoreDAOImpl c = new ColoreDAOImpl(ds);
            
            try {
				nuovo.setOcchiale(o.doRetrieveByKey(idOcchiale));
				nuovo.setVersioneOcchiale(ver.doRetrieveByKey(codiceVersioneOcchiale, idOcchiale));
				nuovo.setColore(c.doRetrieveByKey(coloreScelto));
			} catch (SQLException e) {
				e.printStackTrace();
			}
            
            nuovo.setQuantita(1);
            
            carrello.add(nuovo);
        }
    }

    private void rimuoviProdotto(HttpServletRequest request, ArrayList<ProdottoAcquistato> carrello) throws NumberFormatException {
        int idOcchiale = Integer.parseInt(request.getParameter("idOcchiale"));
        int codiceVersioneOcchiale = Integer.parseInt(request.getParameter("codiceVersioneOcchiale"));
        String coloreScelto = request.getParameter("coloreScelto");
        
        // Cerchiamo l'indice dell'elemento corrispondente per rimuoverlo
        for (int i = 0; i < carrello.size(); i++) {
            ProdottoAcquistato p = carrello.get(i);
            if (p.getVersioneOcchiale().getOcchiale().getId() == idOcchiale && 
                p.getVersioneOcchiale().getCodice() == codiceVersioneOcchiale && 
                p.getColore().getCodice().equalsIgnoreCase(coloreScelto)) {
                
                carrello.remove(i); 
                break;
            }
        }
    }

    private void modificaQuantita(HttpServletRequest request, ArrayList<ProdottoAcquistato> carrello) throws NumberFormatException {
        int idOcchiale = Integer.parseInt(request.getParameter("idOcchiale"));
        int codiceVersioneOcchiale = Integer.parseInt(request.getParameter("codiceVersioneOcchiale"));
        String coloreScelto = request.getParameter("coloreScelto");
        int nuovaQuantita = Integer.parseInt(request.getParameter("quantita"));
        
        for (int i = 0; i < carrello.size(); i++) {
            ProdottoAcquistato p = carrello.get(i);
            if (p.getVersioneOcchiale().getOcchiale().getId() == idOcchiale && 
                p.getVersioneOcchiale().getCodice() == codiceVersioneOcchiale && 
                p.getColore().getCodice().equalsIgnoreCase(coloreScelto)) {
                
                if (nuovaQuantita > 0) {
                    p.setQuantita(nuovaQuantita);
                } else {
                    carrello.remove(i);
                }
                break;
            }
        }
    }
}