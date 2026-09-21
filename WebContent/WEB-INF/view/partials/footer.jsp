<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="site-footer">
  <div class="footer-inner">
    
    <div class="footer-brand">
      <a href="<%= request.getContextPath() %>/home" class="footer-logo">
        <span class="mark">GG<em>.</em></span>
        <span class="sub">Eyewear</span>
      </a>
      <p class="footer-description">
        GG Eyewear nasce per essere un caposaldo in un settore e-commerce come quello dell'eyewear digitale, offrendo una selezione curata di occhiali, non solo da sole o da vista, ma di tutti i tipi e per tutti, fondendo artigianalità e design contemporaneo.
      </p>
    </div>

    <div class="footer-column">
      <h4 class="footer-title">Esplora</h4>
      <a href="<%= request.getContextPath() %>/catalogo?tipo=DA_SOLE" class="footer-link">Occhiali da Sole</a>
      <a href="<%= request.getContextPath() %>/catalogo?tipo=DA_VISTA" class="footer-link">Occhiali da Vista</a>
      <a href="<%= request.getContextPath() %>/catalogo?outlet=true" class="footer-link footer-link-highlight">Outlet &amp; Offerte</a>
    </div>

    <div class="footer-column">
      <h4 class="footer-title">Info &amp; Legale</h4>
      <span class="footer-info-text">Privacy Policy</span>
      <span class="footer-info-text">Termini di Servizio</span>
      <p class="footer-copyright">&copy; 2026 GG Eyewear. Tutti i diritti riservati.</p>
    </div>

  </div>
</footer>
