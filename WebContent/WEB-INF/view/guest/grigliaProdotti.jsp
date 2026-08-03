<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Base64" %>
<%@ page import="model.Occhiale" %>
<%@ page import="model.Disponibile" %>
<%@ page import="model.VersioneOcchiale" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogo Occhiali - GG Eyewear</title>
    
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Fraunces:ital,opsz,wght@0,9..144,300;0,9..144,500;0,9..144,600;1,9..144,500&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css?v=2">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/catalogo.css?v=2">
</head>
<body>
	<% 
        Boolean isOutlet = (Boolean) request.getAttribute("isOutlet");
        if (isOutlet == null) isOutlet = "true".equalsIgnoreCase(request.getParameter("outlet"));
    %>
<div class="catalogo-container">
        <% 
            Collection<Occhiale> prodotti = (Collection<Occhiale>) request.getAttribute("prodotti");
            Map<Integer, Double> medieVoti = (Map<Integer, Double>) request.getAttribute("medieVoti");
            
            if (prodotti != null && !prodotti.isEmpty()) {
                for (Occhiale occhiale : prodotti) {
                    VersioneOcchiale versione = occhiale.getVersioneCorrente();
                    String marca = (versione != null && versione.getMarca() != null) ? versione.getMarca() : "GG";
                    String modello = (versione != null && versione.getModello() != null) ? versione.getModello() : "Eyewear #" + occhiale.getId();
                    double mediaVoto = (medieVoti != null && medieVoti.containsKey(occhiale.getId())) ? medieVoti.get(occhiale.getId()) : 0.0;
                    double prezzo = versione != null ? versione.getPrezzo() : 0.0;
                    
                    int scontoPct = 20 + (occhiale.getId() * 7) % 25; // Sconto tra 20% e 44%
                    double prezzoOriginale = prezzo > 0 ? (prezzo / (1 - (scontoPct / 100.0))) : 0.0;
        %>
                    <div class="card-occhiale" onclick="window.location.href='occhiale?id=<%= occhiale.getId() %>'">
                        <div class="container-immagine">
                            <% if (isOutlet) { %>
                                <span class="badge-sconto">-<%= scontoPct %>%</span>
                            <% } %>
                            <% 
                                String primaImgCat = (occhiale != null) ? occhiale.getImmagine(0) : null;
                                String imgSrcCat = null;
                                
                                if (primaImgCat != null && !primaImgCat.trim().isEmpty()) {
                                    imgSrcCat = request.getContextPath() + "/" + primaImgCat.trim();
                                }
                               
                                if (imgSrcCat != null) {
                            %>
                                    <img class="img-occhiale" src="<%= imgSrcCat %>" alt="Foto <%= modello %>" />
                            <% } else { %>
                                    <img class="img-occhiale" src="https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500&auto=format&fit=crop&q=60" alt="<%= modello %>" />
                            <% }%>
                        </div>
                        
                        <div class="card-title-row">
                            <h3 class="marca-modello"><%= marca %> <%= modello %></h3>
                            <form action="carrello" method="POST" style="margin:0; padding:0; display:inline;" onclick="event.stopPropagation();">
                                <input type="hidden" name="action" value="aggiungi" />
                                <input type="hidden" name="idOcchiale" value="<%= occhiale.getId() %>" />
                                <input type="hidden" name="codiceVersioneOcchiale" value="<%= (versione != null) ? versione.getCodice() : 1 %>" />
                                <input type="hidden" name="coloreScelto" value="<%= (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) ? occhiale.getDisponibilita().iterator().next().getColore().getCodice() : "NERO" %>" />
                                <button type="submit" class="btn-cart-icon" aria-label="Aggiungi al carrello" title="Aggiungi al carrello">
                                    <img src="${pageContext.request.contextPath}/images/icons8-cart-24.png" alt="Carrello" style="width: 18px; height: 18px; vertical-align: middle;" />
                                </button>
                            </form>
                        </div>

                        
                        <div class="card-bottom-row">
                            <div class="prezzo-box">
                                <span class="prezzo-attuale">€<%= String.format("%.2f", prezzo) %></span>
                                <% if (isOutlet && prezzoOriginale > 0) { %>
                                    <span class="prezzo-originale">€<%= String.format("%.2f", prezzoOriginale) %></span>
                                <% } %>
                            </div>

                            <div class="rating-stars" title="<%= mediaVoto > 0 ? String.format("%.1f su 5 stelle", mediaVoto) : "Nessuna recensione" %>">
                                <% 
                                    int interoVoto = (int) Math.round(mediaVoto);
                                    for (int s = 1; s <= 5; s++) {
                                        if (s <= interoVoto && interoVoto > 0) {
                                %>
                                            <span class="star filled">★</span>
                                <% 
                                        } else { 
                                %>
                                            <span class="star empty">☆</span>
                                <% 
                                        }
                                    } 
                                %>
                            </div>
                        </div>
                    </div>
        <% 
                } 
            } else {
        %>
                <div class="msg-vuoto">
                    <p>Nessun occhiale disponibile al momento nel catalogo.</p>
                </div>
        <% 
            } 
        %>
    </div>
</body>
</html>