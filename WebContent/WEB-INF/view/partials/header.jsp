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
      <a href="<%= request.getContextPath() %>/home" class="nav-home">Home</a>
      <a href="<%= request.getContextPath() %>/catalogo?tipo=sole">Occhiali da sole</a>
      <a href="<%= request.getContextPath() %>/catalogo?tipo=vista">Occhiali da vista</a>
      <a href="<%= request.getContextPath() %>/catalogo?outlet=true" class="outlet">Outlet</a>
    </nav>

    <div class="header-actions">
      <a href="<%= request.getContextPath() %>/area-utente" class="icon-btn" aria-label="Area utente">
        <img src="<%= request.getContextPath() %>/images/icons8-user-24.png" alt="Area Utente" style="width: 20px; height: 20px; object-fit: contain;" />
      </a>
      <a href="<%= request.getContextPath() %>/carrello" class="icon-btn" aria-label="Carrello">
        <img src="<%= request.getContextPath() %>/images/icons8-cart-24.png" alt="Carrello" style="width: 20px; height: 20px; object-fit: contain;" />
        <% if (cartCountHeader > 0) { %>
          <span class="cart-count" id="headerCartCount"><%= cartCountHeader %></span>
        <% } %>
      </a>
    </div>
  </div>
</header>
