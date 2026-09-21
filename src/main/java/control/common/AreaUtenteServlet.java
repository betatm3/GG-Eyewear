package control.common;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
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
        
        if (session != null) {
        	if(session.getAttribute("msgSuccesso") != null) {
            request.setAttribute("msgSuccesso", session.getAttribute("msgSuccesso"));
            session.removeAttribute("msgSuccesso");
        	}
            
            if (session.getAttribute("msgErrore") != null) {
                request.setAttribute("msgErrore", session.getAttribute("msgErrore"));
                session.removeAttribute("msgErrore");
            }
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

            if (utenteSessione == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
           
            String nuovoNome = request.getParameter("nome");
            String nuovoCognome = request.getParameter("cognome");
            String nuovoTelefono = request.getParameter("telefono");
            String nuovaVia = request.getParameter("via");
            String nuovoCivico = request.getParameter("civico");
            String nuovoCap = request.getParameter("cap");
            String nuovaCitta = request.getParameter("citta");
            String nuovaDataNascitaStr = request.getParameter("data_nascita");
            String emailParam = request.getParameter("email");
            String nuovaEmail = (emailParam != null) ? emailParam.trim() : "";
            
            String oldPassword = request.getParameter("old_password");
            String nuovaPassword = request.getParameter("new_password");
            String confermaPassword = request.getParameter("conferma_password");
            // CONTROLLO DATI
            if (nuovoNome == null || nuovoNome.trim().isEmpty() ||
            	nuovoCognome == null || nuovoCognome.trim().isEmpty() ||
            	nuovaEmail == null || nuovaEmail.trim().isEmpty() ||
                nuovoTelefono == null || nuovoTelefono.trim().isEmpty() ||
                nuovaVia == null || nuovaVia.trim().isEmpty() ||
                nuovoCivico == null || nuovoCivico.trim().isEmpty() ||
                nuovoCap == null || nuovoCap.trim().isEmpty() ||	
                nuovaCitta == null || nuovaCitta.trim().isEmpty() ||
                nuovaDataNascitaStr == null || nuovaDataNascitaStr.trim().isEmpty()) {

                session.setAttribute("msgErrore", "Impossibile salvare: tutti i campi anagrafici sono obbligatori.");
                response.sendRedirect(request.getContextPath() + "/common/area-utente");
                return;
            }
                
            Utente utenteAggiornato = new Utente();
            utenteAggiornato.setNome(nuovoNome.trim());
            utenteAggiornato.setCognome(nuovoCognome.trim());
            utenteAggiornato.setTelefono(nuovoTelefono.trim());
            String nuovoIndirizzo = nuovaVia.trim() + " " + nuovoCivico.trim() + ", " + nuovoCap.trim() + " " + nuovaCitta.trim();
            utenteAggiornato.setIndirizzo(nuovoIndirizzo);
            utenteAggiornato.setRuolo(utenteSessione.getRuolo());

            // CONTROLLO PASSWORD
            if (nuovaPassword != null && !nuovaPassword.trim().isEmpty()) {
            	// Verifica vecchia password sia stata inserita e che corrisponda all'hash nel DB
                if (oldPassword == null || oldPassword.trim().isEmpty() || 
                	utenteSessione.getPassword() == null || 
                    !BCrypt.checkpw(oldPassword, utenteSessione.getPassword())) {
                        
                    session.setAttribute("msgErrore", "La password inserita non è corretta.");
                    response.sendRedirect(request.getContextPath() + "/common/area-utente");
                    return;
                }
                    
                if (confermaPassword == null || !nuovaPassword.equals(confermaPassword)) {
                	session.setAttribute("msgErrore", "La nuova password e la conferma non coincidono.");
                    response.sendRedirect(request.getContextPath() + "/common/area-utente");
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
            	utenteAggiornato.setDataNascita(LocalDate.parse(nuovaDataNascitaStr.trim()));
            } catch (Exception e) {
            	session.setAttribute("msgErrore", "Formato data di nascita non valido.");
                response.sendRedirect(request.getContextPath() + "/common/area-utente");
                return;
            }
            String vecchiaEmail = utenteSessione.getEmail();
            UtenteDAOImpl utenteDao = new UtenteDAOImpl(ds);

            // verifico nuova email sia diversa e se è già usata
            if (!nuovaEmail.equalsIgnoreCase(vecchiaEmail)) {
            	try {
            		if (utenteDao.doRetrieveByKey(nuovaEmail) != null) {
            			session.setAttribute("msgErrore", "L'email inserita è già associata a un altro account.");
						response.sendRedirect(request.getContextPath() + "/common/area-utente");
						return;
            		}
						
            	} catch (SQLException e) {
            		e.printStackTrace();
					session.setAttribute("msgErrore", "Errore durante la verifica dell'email.");
					response.sendRedirect(request.getContextPath() + "/common/area-utente");
					return;
            	}
            }
            utenteAggiornato.setEmail(nuovaEmail);
                
            // SALVATAGGIO SU DB
            try {
            	boolean success = utenteDao.doUpdateEmail(utenteAggiornato, vecchiaEmail);
                if (success) {
                	session.setAttribute("utenteLoggato", utenteAggiornato);
                    session.setAttribute("msgSuccesso", "Dati utente aggiornati con successo!");
                        
                    response.sendRedirect(request.getContextPath() + "/common/area-utente");
                    return;
                } else {
                	session.setAttribute("msgErrore", "Errore durante l'aggiornamento dei dati.");
                	response.sendRedirect(request.getContextPath() + "/common/area-utente");
                    return;
                }
            } catch (SQLException e) {
            	e.printStackTrace();
                session.setAttribute("msgErrore", "Errore del database: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/common/area-utente");
				return;
            }        
        }
        else {
            response.sendRedirect(request.getContextPath() + "/common/area-utente");
        }
    }
}