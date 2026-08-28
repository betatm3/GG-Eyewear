package control.common;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.mindrot.jbcrypt.BCrypt;

import dao.OrdineDAOImpl;
import dao.ProdottoAcquistatoDAOImpl;
import dao.UtenteDAOImpl;
import dao.OcchialeDAOImpl;
import dao.VersioneOcchialeDAOImpl;
import dao.ColoreDAOImpl;

import model.Ordine;
import model.ProdottoAcquistato;
import model.Utente;
import model.Occhiale;
import model.VersioneOcchiale;
import model.Colore;

@WebServlet("/common/area-utente")
public class AreaUtenteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {    	
        HttpSession session = request.getSession(false);
        Utente utente = null;
        if (session != null) {
            utente = (Utente) session.getAttribute("utenteLoggato");
        }

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (session != null && session.getAttribute("msgSuccesso") != null) {
            // Passiamo il messaggio alla request per la JSP
            request.setAttribute("msgSuccesso", session.getAttribute("msgSuccesso"));
            // Lo rimuoviamo dalla sessione per non farlo mostrare ai successivi refresh
            session.removeAttribute("msgSuccesso");
        }

        OrdineDAOImpl ordineDAO = new OrdineDAOImpl(ds);
        ProdottoAcquistatoDAOImpl prodottoAcquistatoDAO = new ProdottoAcquistatoDAOImpl(ds);
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);
        ColoreDAOImpl coloreDAO = new ColoreDAOImpl(ds);

        try {
            Collection<Ordine> ordini = ordineDAO.doRetrieveByUtente(utente.getEmail());
            Map<Integer, Collection<ProdottoAcquistato>> prodottiOrdineMap = new HashMap<>();

            if (ordini != null) {
                for (Ordine ordine : ordini) {
                    Collection<ProdottoAcquistato> prodotti = prodottoAcquistatoDAO.doRetrieveByOrdine(ordine.getId());
                    
                    if (prodotti != null) {
                        for (ProdottoAcquistato prod : prodotti) {
                            // Carica l'occhiale corrispondente
                            if (prod.getOcchiale() != null) {
                                Occhiale occCompleto = occhialeDAO.doRetrieveByKey(prod.getOcchiale().getId());
                                if (occCompleto != null) {
                                    prod.setOcchiale(occCompleto);
                                
	                                // Carica la versione commerciale
	                                if (prod.getVersioneOcchiale() != null) {
	                                	VersioneOcchiale verCompleta = versioneDAO.doRetrieveByKey(prod.getVersioneOcchiale().getCodice(), occCompleto.getId());
	                                	if (verCompleta != null) {
	                                		prod.setVersioneOcchiale(verCompleta);
	                                	}
	                                }
                                }
                            }
                            
                            // Carica i dettagli del colore
                            if (prod.getColore() != null) {
                                Colore colCompleto = coloreDAO.doRetrieveByKey(prod.getColore().getIdColore());
                                if (colCompleto != null) {
                                    prod.setColore(colCompleto);
                                }
                            }
                        }
                    }
                    prodottiOrdineMap.put(ordine.getId(), prodotti);
                }
            }

            request.setAttribute("ordini", ordini);
            request.setAttribute("prodottiOrdineMap", prodottiOrdineMap);

        } catch (SQLException e) {
        	e.printStackTrace();
            request.setAttribute("errore", "Errore nel caricamento dello storico ordini dal database.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/areaUtente.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("modifica".equals(action)) {
            HttpSession session = request.getSession(false);
            Utente utenteSessione = null;
            if (session != null) {
                utenteSessione = (Utente) session.getAttribute("utenteLoggato");
            }

            if (utenteSessione != null) {
                String nuovoNome = request.getParameter("nome");
                String nuovoCognome = request.getParameter("cognome");
                String nuovoTelefono = request.getParameter("telefono");
                String nuovoIndirizzo = request.getParameter("indirizzo");
                String nuovaDataNascitaStr = request.getParameter("data_nascita");
                String emailParam = request.getParameter("email");
                String nuovaEmail = (emailParam != null) ? emailParam.trim() : "";
                
                String oldPassword = request.getParameter("old_password");
                String nuovaPassword = request.getParameter("new_password");
                String confermaPassword = request.getParameter("conferma_password");

                // --- 1. CONTROLLO DI OBBLIGATORIETÀ LATO SERVER ---
                if (nuovoNome == null || nuovoNome.trim().isEmpty() ||
                    nuovoCognome == null || nuovoCognome.trim().isEmpty() ||
                    nuovaEmail == null || nuovaEmail.trim().isEmpty() ||
                    nuovoTelefono == null || nuovoTelefono.trim().isEmpty() ||
                    nuovoIndirizzo == null || nuovoIndirizzo.trim().isEmpty() ||
                    nuovaDataNascitaStr == null || nuovaDataNascitaStr.trim().isEmpty()) {

                    request.setAttribute("msgErrore", "Impossibile salvare: tutti i campi anagrafici sono obbligatori.");
                    doGet(request, response);
                    return;
                }
                
                Utente utenteAggiornato = new Utente();
                utenteAggiornato.setNome(nuovoNome.trim());
                utenteAggiornato.setCognome(nuovoCognome.trim());
                utenteAggiornato.setTelefono(nuovoTelefono.trim());
                utenteAggiornato.setIndirizzo(nuovoIndirizzo.trim());
                utenteAggiornato.setRuolo(utenteSessione.getRuolo());

                // --- 2. CONTROLLO GESTIONE PASSWORD (OPZIONALE) ---
                if (nuovaPassword != null && !nuovaPassword.trim().isEmpty()) {
                	// Verifica vecchia password sia stata inserita e che corrisponda all'hash nel DB
                    if (oldPassword == null || oldPassword.trim().isEmpty() || 
                        utenteSessione.getPassword() == null || 
                        !BCrypt.checkpw(oldPassword, utenteSessione.getPassword())) {
                        
                        request.setAttribute("msgErrore", "La password inserita non è corretta.");
                        doGet(request, response);
                        return; 
                    }
                    
                    if (confermaPassword == null || !nuovaPassword.equals(confermaPassword)) {
                        request.setAttribute("msgErrore", "La nuova password e la conferma non coincidono.");
                        doGet(request, response);
                        return;
                    }
                    else {
	                    String passwordHash = BCrypt.hashpw(nuovaPassword.trim(), BCrypt.gensalt());
	                    utenteAggiornato.setPassword(passwordHash);
                    }
                }
                else {
                    utenteAggiornato.setPassword(utenteSessione.getPassword());
                }
                     
                try {
                	utenteAggiornato.setDataNascita(java.time.LocalDate.parse(nuovaDataNascitaStr.trim()));
                } catch (Exception e) {
                    request.setAttribute("msgErrore", "Formato data di nascita non valido.");
                    doGet(request, response);
                    return;
                }
                String vecchiaEmail = utenteSessione.getEmail();
                UtenteDAOImpl utenteDao = new UtenteDAOImpl(ds);
                // verifico nuova email sia diversa e se è già usata
                if (!nuovaEmail.equalsIgnoreCase(vecchiaEmail)) {
                    try {
						if (utenteDao.doRetrieveByKey(nuovaEmail) != null) {
						    request.setAttribute("msgErrore", "L'email inserita è già associata a un altro account.");
						    doGet(request, response);
						    return;
						}
						
					} catch (SQLException e) {
						e.printStackTrace();
						request.setAttribute("msgErrore", "Errore durante la verifica dell'email.");
				        doGet(request, response);
				        return;
					}
                }
                utenteAggiornato.setEmail(nuovaEmail);
                
                // --- 3. SALVATAGGIO SU DATABASE ---
                try {
                	boolean success = utenteDao.doUpdateEmail(utenteAggiornato, vecchiaEmail);
                    if (success) {
                        session.setAttribute("utenteLoggato", utenteAggiornato);
                        session.setAttribute("msgSuccesso", "Dati utente aggiornati con successo!");
                        
                        response.sendRedirect(request.getContextPath() + "/common/area-utente");
                        return;
                    } else {
                        request.setAttribute("msgErrore", "Errore durante l'aggiornamento dei dati.");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("msgErrore", "Errore del database: " + e.getMessage());
                }
            }
            
            // Richiama doGet per ricaricare lo storico ordini e inoltrare alla corretta view JSP
            doGet(request, response);
        }
    }
}
