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

@WebFilter("/*")
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
        //no-store: Non salvare mai una copia di questa pagina.
        //must-revalidate: quando l'utente prova ad aprire questa pagina (anche dalla cronologia o col tasto "Indietro"),
        //devi prima chiedere al server se è ancora valida
        
        httpResponse.setHeader("Pragma", "no-cache"); 
        //Serve per retrocompatibilità, per dire ai vecchi browser che non supportano lo standard HTTP 1.1 (e la direttiva Cache-Control)
        //di non salvare la pagina in cache.
        
        httpResponse.setDateHeader("Expires", 0); 
        //Imposta la data di "scadenza" del contenuto al timestamp 0 (ovvero l'1 Gennaio 1970). La pagina risulta già scaduta 
        //nel momento stesso in cui la riceve, quindi non la salverà in cache
        
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());        HttpSession session = httpRequest.getSession(false);
        
        //impedisce che l'elaborazione dell'autenticazione venga eseguita anche quando il browser scarica un css, js o img.
        if (path.startsWith("/styles/") || path.startsWith("/scripts/") || 
        	path.startsWith("/images/")) {
            chain.doFilter(request, response);
            return;
        }
        
        Utente utente = null;
        if (session != null) {
            utente = (Utente) session.getAttribute("utenteLoggato");
            if (utente == null) {
                utente = (Utente) session.getAttribute("utente");
            }
        }
        
        // Richieste /admin/*
        if (path.startsWith("/admin/")) {
            if (utente == null || !utente.isAdmin()) {
                httpRequest.setAttribute("messaggioErrore", "Accesso negato: area riservata agli amministratori.");
                RequestDispatcher dispatcher = httpRequest.getRequestDispatcher("/WEB-INF/view/errors/errorePermessi.jsp");
                dispatcher.forward(httpRequest, httpResponse);
                return;
            }
        } else if(path.startsWith("/common/")){
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
