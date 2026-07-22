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

@WebServlet({"/area-utente", "/common/area-utente", "/areaUtente"})
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
            if (utente == null) {
                utente = (Utente) session.getAttribute("utente");
            }
        }

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
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
                                }
                                // Carica la versione commerciale
                                if (prod.getVersioneOcchiale() != null) {
                                	VersioneOcchiale verCompleta = versioneDAO.doRetrieveByKey(prod.getVersioneOcchiale().getCodice(), occCompleto.getId());
                                	if (verCompleta != null) {
                                		prod.setVersioneOcchiale(verCompleta);
                                	}
                                }
                            }
                            
                            // Carica i dettagli del colore
                            if (prod.getColore() != null) {
                                Colore colCompleto = coloreDAO.doRetrieveByKey(prod.getColore().getCodice());
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
                if (utenteSessione == null) {
                    utenteSessione = (Utente) session.getAttribute("utente");
                }
            }

            if (utenteSessione != null) {
                String nuovoNome = request.getParameter("nome");
                String nuovoCognome = request.getParameter("cognome");
                String nuovoTelefono = request.getParameter("telefono");
                String nuovoIndirizzo = request.getParameter("indirizzo");
                String nuovaDataNascitaStr = request.getParameter("data_nascita");
                String nuovaPassword = request.getParameter("password");

                if (nuovoNome != null && !nuovoNome.trim().isEmpty()) {
                    utenteSessione.setNome(nuovoNome.trim());
                }
                if (nuovoCognome != null && !nuovoCognome.trim().isEmpty()) {
                    utenteSessione.setCognome(nuovoCognome.trim());
                }
                if (nuovoTelefono != null) {
                    utenteSessione.setTelefono(nuovoTelefono.trim());
                }
                if (nuovoIndirizzo != null) {
                    utenteSessione.setIndirizzo(nuovoIndirizzo.trim());
                }
                if (nuovaDataNascitaStr != null && !nuovaDataNascitaStr.trim().isEmpty()) {
                    try {
                        utenteSessione.setDataNascita(java.time.LocalDate.parse(nuovaDataNascitaStr.trim()));
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } else {
                    utenteSessione.setDataNascita(null);
                }
                if (nuovaPassword != null && !nuovaPassword.trim().isEmpty()) {
                    utenteSessione.setPassword(nuovaPassword.trim());
                }

                UtenteDAOImpl utenteDao = new UtenteDAOImpl(ds);
                boolean success = false;
                try {
                    success = utenteDao.doUpdate(utenteSessione);
                    if (success) {
                        session.setAttribute("utenteLoggato", utenteSessione);
                        session.setAttribute("utente", utenteSessione);
                        request.setAttribute("msgSuccesso", "Dati utente aggiornati con successo!");
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
