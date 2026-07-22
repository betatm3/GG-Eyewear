package filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utente;

@WebFilter(urlPatterns = {"/admin/*", "/common/*", "/area-utente", "/areaUtente"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
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
                httpRequest.getRequestDispatcher("/WEB-INF/view/errors/errorePermessi.jsp").forward(httpRequest, httpResponse);
                return;
            }
        } else {
            // Richieste /common/*, /area-utente, /areaUtente
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
