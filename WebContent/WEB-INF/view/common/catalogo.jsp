<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Base64" %>
<%@ page import="model.Occhiale" %>
<%@ page import="model.Disponibile" %>
<%@ page import="model.VersioneOcchiale" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogo Occhiali - GG Eyewear</title>
    
    <!-- Font Premium da Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/catalogo.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>

    <% 
        Boolean isOutlet = (Boolean) request.getAttribute("isOutlet");
        if (isOutlet == null) isOutlet = "true".equalsIgnoreCase(request.getParameter("outlet"));
    %>

    <h1><%= isOutlet ? "Outlet Occhiali — Sconti Esclusivi" : "Il nostro Catalogo Occhiali" %></h1>

    <!-- Sezione Filtri -->
    <div class="filters-section">
        <div class="filters-title">
            <svg viewBox="0 0 24 24"><path d="M10 18h4v-2h-4v2zM3 6v2h18V6H3zm3 7h12v-2H6v2z"/></svg>
            Filtra Catalogo
        </div>
        <form action="catalogo" method="GET">
            <% if (isOutlet) { %>
                <input type="hidden" name="outlet" value="true" />
            <% } %>
            <% 
                String currentTipo = request.getParameter("tipo"); 
                if (currentTipo != null && !currentTipo.trim().isEmpty()) { 
            %>
                <input type="hidden" name="tipo" value="<%= currentTipo %>" />
            <% 
                } 
            %>
            
            <div class="filters-grid">
                <div class="filter-field">
                    <label class="filter-label" for="filterMarca">Marca</label>
                    <input type="text" id="filterMarca" name="marca" class="filter-input" placeholder="Es. Ray-Ban..." value="<%= request.getParameter("marca") != null ? request.getParameter("marca") : "" %>" />
                </div>
                
                <div class="filter-field">
                    <label class="filter-label" for="filterGenere">Genere</label>
                    <select id="filterGenere" name="genere" class="filter-input">
                        <option value="">Tutti</option>
                        <option value="Uomo" <%= "Uomo".equalsIgnoreCase(request.getParameter("genere")) ? "selected" : "" %>>Uomo</option>
                        <option value="Donna" <%= "Donna".equalsIgnoreCase(request.getParameter("genere")) ? "selected" : "" %>>Donna</option>
                        <option value="Unisex" <%= "Unisex".equalsIgnoreCase(request.getParameter("genere")) ? "selected" : "" %>>Unisex</option>
                    </select>
                </div>

                <div class="filter-field">
                    <label class="filter-label" for="filterMateriale">Materiale</label>
                    <input type="text" id="filterMateriale" name="materiale" class="filter-input" placeholder="Es. Acetato, Metallo..." value="<%= request.getParameter("materiale") != null ? request.getParameter("materiale") : "" %>" />
                </div>

                <div class="filter-field">
                    <label class="filter-label" for="filterForma">Forma</label>
                    <input type="text" id="filterForma" name="forma" class="filter-input" placeholder="Es. Rotonda, Aviator..." value="<%= request.getParameter("forma") != null ? request.getParameter("forma") : "" %>" />
                </div>

                <div class="filter-field">
                    <label class="filter-label" for="filterColore">Colore</label>
                    <input type="text" id="filterColore" name="colore" class="filter-input" placeholder="Es. Nero, Oro..." value="<%= request.getParameter("colore") != null ? request.getParameter("colore") : "" %>" />
                </div>

                <div class="filter-field">
                    <label class="filter-label" for="filterTaglia">Taglia</label>
                    <input type="text" id="filterTaglia" name="taglia" class="filter-input" placeholder="Es. M, L..." value="<%= request.getParameter("taglia") != null ? request.getParameter("taglia") : "" %>" />
                </div>
                
                <div class="filter-field">
                    <label class="filter-label" for="filterPrezzoMin">Prezzo Minimo (€)</label>
                    <input type="number" id="filterPrezzoMin" name="prezzoMin" class="filter-input" placeholder="Es. 50" min="0" step="10" value="<%= request.getParameter("prezzoMin") != null ? request.getParameter("prezzoMin") : "" %>" />
                </div>

                <div class="filter-field">
                    <label class="filter-label" for="filterPrezzoMax">Prezzo Massimo (€)</label>
                    <input type="number" id="filterPrezzoMax" name="prezzoMax" class="filter-input" placeholder="Es. 150" min="0" step="10" value="<%= request.getParameter("prezzoMax") != null ? request.getParameter("prezzoMax") : "" %>" />
                </div>
            </div>
            
            <div class="filters-actions">
                <button type="submit" class="btn-filter">Filtra</button>
                <a href="catalogo<%= isOutlet ? "?outlet=true" : (currentTipo != null ? "?tipo=" + currentTipo : "") %>" class="btn-reset">Reset</a>
            </div>
        </form>
    </div>

    <div class="catalogo-container">
        <% 
            Collection<Occhiale> prodotti = (Collection<Occhiale>) request.getAttribute("prodotti");
            Map<Integer, Double> medieVoti = (Map<Integer, Double>) request.getAttribute("medieVoti");
            
            if (prodotti != null && !prodotti.isEmpty()) {
                for (Occhiale occhiale : prodotti) {
                    VersioneOcchiale versione = occhiale.getVersioneCorrente();
                    String marca = (versione != null && versione.getMarca() != null) ? versione.getMarca() : "GG";
                    String modello = (versione != null && versione.getModello() != null) ? versione.getModello() : "Eyewear #" + occhiale.getId();
                    double mediaVoto = (medieVoti != null && medieVoti.containsKey(occhiale.getId())) ? medieVoti.get(occhiale.getId()) : 4.8;
                    double prezzo = versione != null ? versione.getPrezzo() : 0.0;
                    
                    int scontoPct = 20 + (occhiale.getId() * 7) % 25; // Sconto tra 20% e 44%
                    double prezzoOriginale = prezzo > 0 ? (prezzo / (1 - (scontoPct / 100.0))) : 0.0;
        %>
                    <div class="card-occhiale" onclick="window.location.href='occhiale?id=<%= occhiale.getId() %>'">
                        <!-- Contenitore Immagine -->
                        <div class="container-immagine">
                            <% if (isOutlet) { %>
                                <span class="badge-sconto">-<%= scontoPct %>%</span>
                            <% } %>
                            <% 
                                if (occhiale.getImmagine() != null && occhiale.getImmagine().length > 0) {
                                    String base64Image = Base64.getEncoder().encodeToString(occhiale.getImmagine());
                            %>
                                    <img class="img-occhiale" src="data:image/jpeg;base64,<%= base64Image %>" alt="Foto <%= modello %>" />
                            <% 
                                } else { 
                            %>
                                    <img class="img-occhiale" src="https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500&auto=format&fit=crop&q=60" alt="<%= modello %>" />
                            <% 
                                } 
                            %>
                        </div>

                        <!-- Riga Titolo Modello + Icona Aggiungi al Carrello -->
                        <div class="card-title-row">
                            <h3 class="marca-modello"><%= modello %></h3>
                            <form action="carrello" method="POST" style="margin:0; padding:0; display:inline;" onclick="event.stopPropagation();">
                                <input type="hidden" name="action" value="aggiungi" />
                                <input type="hidden" name="idOcchiale" value="<%= occhiale.getId() %>" />
                                <input type="hidden" name="codiceVersioneOcchiale" value="<%= (versione != null) ? versione.getCodice() : 1 %>" />
                                <input type="hidden" name="coloreScelto" value="<%= (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) ? occhiale.getDisponibilita().iterator().next().getColore().getCodice() : "NERO" %>" />
                                <button type="submit" class="btn-cart-icon" aria-label="Aggiungi al carrello" title="Aggiungi al carrello">
                                    <svg viewBox="0 0 24 24">
                                        <path d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1zm16 16c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"/>
                                    </svg>
                                </button>
                            </form>
                        </div>

                        <!-- Riga Bottom: Prezzo + Stelle Voto Recensione -->
                        <div class="card-bottom-row">
                            <div class="prezzo-box">
                                <span class="prezzo-attuale">€<%= String.format("%.2f", prezzo) %></span>
                                <% if (isOutlet && prezzoOriginale > 0) { %>
                                    <span class="prezzo-originale">€<%= String.format("%.2f", prezzoOriginale) %></span>
                                <% } %>
                            </div>

                            <div class="rating-stars" title="<%= String.format("%.1f", mediaVoto) %> su 5 stelle">
                                <% 
                                    int interoVoto = (int) Math.round(mediaVoto);
                                    for (int s = 1; s <= 5; s++) {
                                        if (s <= interoVoto) {
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
                } // Fine ciclo for
            } else {
        %>
                <div class="msg-vuoto">
                    <p>Nessun occhiale disponibile al momento nel catalogo.</p>
                </div>
        <% 
            } 
        %>
    </div>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>