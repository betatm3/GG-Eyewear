<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%
  int cartCountHeader = 0;
  HttpSession sessionHeader = request.getSession(false);
  if (sessionHeader != null) {
      Collection<?> carrelloHeader = (Collection<?>) sessionHeader.getAttribute("carrello");
      if (carrelloHeader != null) {
          cartCountHeader = carrelloHeader.size();
      }
  }
%>
<header class="site-header">
  <div class="header-inner">
    <a href="<%= request.getContextPath() %>/home" class="logo"><span class="mark">GG<em>.</em></span><span class="sub">Eyewear</span></a>

    <nav class="main-nav">
      <a href="<%= request.getContextPath() %>/catalogo?tipo=sole">Occhiali da sole</a>
      <a href="<%= request.getContextPath() %>/catalogo?tipo=vista">Occhiali da vista</a>
      <a href="<%= request.getContextPath() %>/catalogo?outlet=true" class="outlet">Outlet</a>
    </nav>

    <div class="header-actions">
      <a href="<%= request.getContextPath() %>/area-utente" class="icon-btn" aria-label="Area utente">
        <svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4.4 3.6-7 8-7s8 2.6 8 7"/></svg>
      </a>
      <a href="<%= request.getContextPath() %>/carrello" class="icon-btn" aria-label="Carrello">
        <svg viewBox="0 0 24 24"><path d="M3 4h2l2.2 11.2a2 2 0 0 0 2 1.6h7.6a2 2 0 0 0 2-1.6L21 8H6"/><circle cx="9.5" cy="20.5" r="1.2" fill="var(--ink)" stroke="none"/><circle cx="17.5" cy="20.5" r="1.2" fill="var(--ink)" stroke="none"/></svg>
        <% if (cartCountHeader > 0) { %>
          <span class="cart-count" id="headerCartCount"><%= cartCountHeader %></span>
        <% } %>
      </a>
    </div>
  </div>
</header>
