<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Occhiale" %>
<%@ page import="model.VersioneOcchiale" %>
<!DOCTYPE html>
<html lang="it">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>GG Eyewear — Occhiali</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Fraunces:ital,opsz,wght@0,9..144,300;0,9..144,500;0,9..144,600;1,9..144,500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/comune.css?v=2">
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/home.css?v=2">
</head>
<body>

<%
  Collection<Occhiale> soleList = (Collection<Occhiale>) request.getAttribute("sole");
  Collection<Occhiale> vistaList = (Collection<Occhiale>) request.getAttribute("vista");
  Map<Integer, Double> medieVoti = (Map<Integer, Double>) request.getAttribute("medieVoti");
  int totalModels = (soleList != null ? soleList.size() : 0) + (vistaList != null ? vistaList.size() : 0);
%>

<%@ include file="../partials/header.jsp" %>
<section class="hero">
  <div class="hero-inner">
    <div class="hero-visual">
      <div class="hero-slides">
        
        <div class="hero-slide active" style="background: url('<%= request.getContextPath() %>/images/RayBan_banner.jpg') center/cover no-repeat;">
          <div class="hero-slide-content">
            <h4>Ray-Ban</h4>
            <p>Design contemporaneo e comfort per ogni momento della tua giornata</p>
          </div>       
        </div>

        <div class="hero-slide" style="background: linear-gradient(rgba(0,0,0,0.35), rgba(0,0,0,0.45)), url('<%= request.getContextPath() %>/images/Gucci_banner.jpg') center/cover no-repeat;">
          <div class="hero-slide-content">
            <h4>Gucci</h4>
            <h4>Montature da Vista Premium</h4>
            <p>Questa stagione, diventa protagonista</p>
          </div>
        </div>
        
        <div class="hero-slide" style="background: linear-gradient(rgba(0,0,0,0.35), rgba(0,0,0,0.45)), url('<%= request.getContextPath() %>/images/TomFord_banner.jpg') center/cover no-repeat;">
          <div class="hero-slide-content">
            <h4>Tom Ford</h4>
            <p>Materiali nobili solo per gli occhiali più esclusivi</p>
          </div>
        </div>
      </div>

      <div class="hero-action-container">
        <a id="heroDiscoverBtn" href="${pageContext.request.contextPath}/catalogo?marca=Ray-Ban" class="btn-primary">
          Scopri la collezione
          <img src="${pageContext.request.contextPath}/images/icons8-right-arrow-24 (1).png" alt="->" />
        </a>
      </div>

      <div class="slider-dots">
        <span class="slider-dot active" data-index="0"></span>
        <span class="slider-dot" data-index="1"></span>
        <span class="slider-dot" data-index="2"></span>
      </div>
    </div>
  </div>
</section>

<section class="featured wrap" id="prodotti">
  <div class="section-head">
    <div>
      <span class="label">In primo piano</span>
      <h2>Selezionati per te</h2>
    </div>
    <span class="count"><%= totalModels %> modelli</span>
  </div>

  <div class="featured-groups">

   
    <div class="group" id="sole">
      <h3>Occhiali da sole</h3>
      <div class="grid-2x2">
        <% 
            if (soleList != null && !soleList.isEmpty()) {
                for (Occhiale occhiale : soleList) {
                    VersioneOcchiale versione = occhiale.getVersioneCorrente();
                    String nomeProdotto = (versione != null && versione.getMarca() != null) ? versione.getMarca() : "Brand";
                    if (versione != null && versione.getModello() != null) {
                        nomeProdotto = versione.getMarca() + " " + versione.getModello();
                    }
                    
                    double mediaVoto = (medieVoti != null && medieVoti.containsKey(occhiale.getId())) ? medieVoti.get(occhiale.getId()) : 0.0;
                    double prezzoDouble = (versione != null) ? versione.getPrezzo() : 0.0;
                    String prezzoStr = "";
                    if (prezzoDouble > 0) {
                        if (prezzoDouble == (long) prezzoDouble) {
                            prezzoStr = String.format("€ %d", (long) prezzoDouble);
                        } else {
                            prezzoStr = String.format("€ %.2f", prezzoDouble);
                        }
                    } else {
                        prezzoStr = "Prezzo N/D";
                    }
        %>
                    <a href="${pageContext.request.contextPath}/occhiale?id=<%= occhiale.getId() %>" class="product-card">
                      <div class="product-frame">
                        <% 
                            String primaImgSole = (occhiale != null) ? occhiale.getImmagine(0) : null;
                            String imgSrcSole = null;
                            
                            if (primaImgSole != null && !primaImgSole.trim().isEmpty()) {
                                imgSrcSole = request.getContextPath() + "/" + primaImgSole.trim();
                            }
                            
                            if (imgSrcSole != null) {
                        %>
                                <img src="<%= imgSrcSole %>" alt="Foto <%= nomeProdotto %>" />
                        <% } else {%>
                                <span style="font-size: 11px; color: #888; text-align: center; padding: 10px; font-weight: 500;">Immagine non disponibile</span>
                        <% }  %>
                      </div>
                      <div class="product-info">
                        <div class="product-name"><%= nomeProdotto %></div>
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-top: 6px;">
                          <div class="product-price"><%= prezzoStr %></div>
                          <div class="rating-stars" style="font-size: 12px; color: #f59e0b;" title="<%= mediaVoto > 0 ? String.format("%.1f su 5 stelle", mediaVoto) : "Nessuna recensione" %>">
                            <% 
                                int interoVoto = (int) Math.round(mediaVoto);
                                for (int s = 1; s <= 5; s++) {
                                    if (s <= interoVoto && interoVoto > 0) {
                            %>
                                        <span style="color: #f59e0b;">★</span>
                            <% 
                                    } else { 
                            %>
                                        <span style="color: #d1d5db;">☆</span>
                            <% 
                                    }
                                } 
                            %>
                          </div>
                        </div>
                      </div>
                    </a>
        <% 
                }
            } else {
        %>
                <p style="grid-column: span 2; color: #888; font-style: italic;">Nessun occhiale da sole in primo piano al momento.</p>
        <% 
            }
        %>
      </div>
    </div>

    
    <div class="group" id="vista">
      <h3>Occhiali da vista</h3>
      <div class="grid-2x2">
        <% 
            if (vistaList != null && !vistaList.isEmpty()) {
                for (Occhiale occhiale : vistaList) {
                    VersioneOcchiale versione = occhiale.getVersioneCorrente();
                    String nomeProdotto = (versione != null && versione.getMarca() != null) ? versione.getMarca() : "Brand";
                    if (versione != null && versione.getModello() != null) {
                        nomeProdotto = versione.getMarca() + " " + versione.getModello();
                    }
                    
                    double mediaVoto = (medieVoti != null && medieVoti.containsKey(occhiale.getId())) ? medieVoti.get(occhiale.getId()) : 0.0;
                    double prezzoDouble = (versione != null) ? versione.getPrezzo() : 0.0;
                    String prezzoStr = "";
                    if (prezzoDouble > 0) {
                        if (prezzoDouble == (long) prezzoDouble) {
                            prezzoStr = String.format("€ %d", (long) prezzoDouble);
                        } else {
                            prezzoStr = String.format("€ %.2f", prezzoDouble);
                        }
                    } else {
                        prezzoStr = "Prezzo N/D";
                    }
        %>
                    <a href="${pageContext.request.contextPath}/occhiale?id=<%= occhiale.getId() %>" class="product-card">
                      <div class="product-frame">
                        <% 
                            String primaImgVista = (occhiale != null) ? occhiale.getImmagine(0) : null;
                            String imgSrcVista = null;
                          
                            if (primaImgVista != null && !primaImgVista.trim().isEmpty()) {
                                imgSrcVista = request.getContextPath() + "/" + primaImgVista.trim();
                            }
                            if (imgSrcVista != null) {
                        %>
                                <img src="<%= imgSrcVista %>" alt="Foto <%= nomeProdotto %>" />
                        <% } else { %>
                                <span style="font-size: 11px; color: #888; text-align: center; padding: 10px; font-weight: 500;">Immagine non disponibile</span>
                        <% } %>
                      </div>
                      
                      <div class="product-info">
                        <div class="product-name"><%= nomeProdotto %></div>
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-top: 6px;">
                          <div class="product-price"><%= prezzoStr %></div>
                          <div class="rating-stars" style="font-size: 12px; color: #f59e0b;" title="<%= mediaVoto > 0 ? String.format("%.1f su 5 stelle", mediaVoto) : "Nessuna recensione" %>">
                            <% 
                                int interoVoto = (int) Math.round(mediaVoto);
                                for (int s = 1; s <= 5; s++) {
                                    if (s <= interoVoto && interoVoto > 0) {
                            %>
                                        <span style="color: #f59e0b;">★</span>
                            <% 
                                    } else { 
                            %>
                                        <span style="color: #d1d5db;">☆</span>
                            <% 
                                    }
                                } 
                            %>
                          </div>
                        </div>
                      </div>
                    </a>
        <% 
                }
            } else {
        %>
                <p style="grid-column: span 2; color: #888; font-style: italic;">Nessun occhiale da vista in primo piano al momento.</p>
        <% 
            }
        %>
      </div>
    </div>

  </div>
</section>

<%@ include file="../partials/footer.jsp" %>
<script src="${pageContext.request.contextPath}/scripts/home.js"></script>
</body>
</html>