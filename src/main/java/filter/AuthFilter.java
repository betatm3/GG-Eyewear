package filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utente;

@WebFilter(urlPatterns = {"/admin/*", "/common/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
     // --- APPLICAZIONE HEADER ANTI-CACHE ---
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
        //no-cache: Costringe il browser a convalidare la pagina con il server prima di usarne una copia memorizzata.
        //no-store: Non salvare mai una copia di questa pagina privata sul disco.
        //must-revalidate: Ogni volta che l'utente prova ad aprire questa pagina (anche dalla cronologia o col tasto "Indietro"),
        //devi prima chiedere al server se è ancora valida
        
        httpResponse.setHeader("Pragma", "no-cache"); 
        //Serve per retrocompatibilità. I vecchi browser che non supportano lo standard HTTP 1.1 (e la direttiva Cache-Control)
        //leggono questo header per capire che non devono salvarsi la pagina in cache.
        
        httpResponse.setDateHeader("Expires", 0); 
        //Imposta la data di "scadenza" del contenuto al timestamp 0 (ovvero l'1 Gennaio 1970). La pagina risulta già scaduta 
        //nel momento stesso in cui la riceve, quindi non la salverà in cache
        
        String uri = httpRequest.getRequestURI();
        HttpSession session = httpRequest.getSession(false);
        
        Utente utente = null;
        if (session != null) {
            utente = (Utente) session.getAttribute("utenteLoggato");
            if (utente == null) {
                utente = (Utente) session.getAttribute("utente");
            }
        }
        
        // Richieste /admin/*
        if (uri.contains("/admin/")) {
            if (utente == null || !utente.isAdmin()) {
                httpRequest.setAttribute("messaggioErrore", "Accesso negato: area riservata agli amministratori.");
                RequestDispatcher dispatcher = httpRequest.getRequestDispatcher("/WEB-INF/view/errors/errorePermessi.jsp");
                dispatcher.forward(httpRequest, httpResponse);
                return;
            }
        } else {
            // Richieste /common/*
            if (utente == null) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
                return;
            }
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
