<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer style="background: #FAF8F5; border-top: 1px solid var(--line); padding: 48px 0 36px 0;">
  <div class="footer-inner" style="max-width: 1200px; margin: 0 auto; padding: 0 32px; display: grid; grid-template-columns: 1.8fr 1fr 1fr; gap: 40px; align-items: start;">
    
    <div style="display: flex; flex-direction: column; gap: 14px;">
      <a href="<%= request.getContextPath() %>/home" class="logo" style="text-decoration: none; display: flex; align-items: baseline; gap: 8px;">
        <span class="mark" style="font-family: 'Fraunces', serif; font-size: 24px; font-weight: 600; color: #2B2B2B;">GG<em style="font-style: italic; color: var(--amber, #D8CBB2);">.</em></span>
        <span class="sub" style="font-size: 11px; letter-spacing: 0.16em; text-transform: uppercase; color: #8a8a8a; font-weight: 600;">Eyewear</span>
      </a>
      <p style="font-size: 13px; line-height: 1.6; color: #666; max-width: 440px; font-family: 'Outfit', sans-serif;">
        GG Eyewear nasce per essere un caposaldo in un settore e-commerce come quello dell'eyewear digitale, offrendo una selezione curata di occhiali, non solo da sole o da vista, ma di tutti i tipi e per tutti, fondendo artigianalità e design contemporaneo.
      </p>
    </div>

   
    <div style="display: flex; flex-direction: column; gap: 10px; font-family: 'Outfit', sans-serif;">
      <h4 style="font-size: 14px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: #2B2B2B; margin-bottom: 4px;">Esplora</h4>
      <a href="<%= request.getContextPath() %>/catalogo?tipo=DA_SOLE" style="font-size: 13px; color: #555; text-decoration: none;">Occhiali da Sole</a>
      <a href="<%= request.getContextPath() %>/catalogo?tipo=DA_VISTA" style="font-size: 13px; color: #555; text-decoration: none;">Occhiali da Vista</a>
      <a href="<%= request.getContextPath() %>/catalogo?tipo=DA_LETTURA" style="font-size: 13px; color: #555; text-decoration: none;">Occhiali da Lettura</a>
      <a href="<%= request.getContextPath() %>/catalogo?tipo=PROGRESSIVO" style="font-size: 13px; color: #555; text-decoration: none;">Occhiali Progressivi</a>
      <a href="<%= request.getContextPath() %>/catalogo?tipo=FOTOCROMATICO" style="font-size: 13px; color: #555; text-decoration: none;">Occhiali Fotocromatici</a>
      <a href="<%= request.getContextPath() %>/catalogo?outlet=true" style="font-size: 13px; color: #C86A55; text-decoration: none; font-weight: 600; margin-top: 4px;">Outlet & Offerte</a>
    </div>

    
    <div style="display: flex; flex-direction: column; gap: 10px; font-family: 'Outfit', sans-serif;">
      <h4 style="font-size: 14px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: #2B2B2B; margin-bottom: 4px;">Info & Legale</h4>
      <span style="font-size: 13px; color: #555;">Privacy Policy</span>
      <span style="font-size: 13px; color: #555;">Termini di Servizio</span>
      <p style="font-size: 12px; color: #888; margin-top: 12px;">&copy; 2026 GG Eyewear. Tutti i diritti riservati.</p>
    </div>
  </div>
</footer>
