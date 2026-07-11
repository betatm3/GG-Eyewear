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
import dao.OcchialeDAOImpl;
import dao.VersioneOcchialeDAOImpl;
import dao.ColoreDAOImpl;

import model.Ordine;
import model.ProdottoAcquistato;
import model.Utente;
import model.Occhiale;
import model.VersioneOcchiale;
import model.Colore;

@WebServlet("/area-utente")
public class AreaUtenteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utenteLoggato") == null) {
            request.setAttribute("errore", "Devi effettuare il login per accedere alla tua area personale.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/login.jsp");
            dispatcher.forward(request, response);
            return;
        }

        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        OrdineDAOImpl ordineDAO = new OrdineDAOImpl(ds);
        ProdottoAcquistatoDAOImpl prodottoAcquistatoDAO = new ProdottoAcquistatoDAOImpl(ds);
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);
        ColoreDAOImpl coloreDAO = new ColoreDAOImpl(ds);

        try {
            // 1. Recupera tutti gli ordini del cliente
            Collection<Ordine> ordini = ordineDAO.doRetrieveByUtente(utente.getEmail());

            // 2. Mappa per contenere i dettagli dei prodotti di ogni ordine
            Map<Integer, Collection<ProdottoAcquistato>> prodottiOrdineMap = new HashMap<>();

            if (ordini != null) {
                for (Ordine ordine : ordini) {
                    // Recupera le righe dei prodotti acquistati in questo ordine
                    Collection<ProdottoAcquistato> prodotti = prodottoAcquistatoDAO.doRetrieveByOrdine(ordine.getId());
                    
                    if (prodotti != null) {
                        for (ProdottoAcquistato prod : prodotti) {
                            // Carica l'occhiale corrispondente
                            if (prod.getOcchiale() != null) {
                                Occhiale occCompleto = occhialeDAO.doRetrieveByKey(prod.getOcchiale().getId());
                                if (occCompleto != null) {
                                    prod.setOcchiale(occCompleto);
                                }
                            }
                            // Carica la versione commerciale
                            if (prod.getVersioneOcchiale() != null) {
                                VersioneOcchiale verCompleta = versioneDAO.doRetrieveByKey(prod.getVersioneOcchiale().getCodice());
                                if (verCompleta != null) {
                                    prod.setVersioneOcchiale(verCompleta);
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

            // Passiamo gli ordini e i relativi dettagli di prodotto alla JSP
            request.setAttribute("ordini", ordini);
            request.setAttribute("prodottiOrdineMap", prodottiOrdineMap);

        } catch (SQLException e) {
        	// Serve per stampare la traccia dell'errore sulla console del server locale a scopo di debug
        	e.printStackTrace();
            request.setAttribute("errore", "Errore nel caricamento dello storico ordini dal database.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/areaUtente.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
