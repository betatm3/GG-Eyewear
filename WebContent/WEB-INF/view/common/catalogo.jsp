<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
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
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/catalogo.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>

    <h1>Il nostro Catalogo Occhiali</h1>

    <!-- Sezione Filtri -->
    <div class="filters-section">
        <div class="filters-title">
            <svg viewBox="0 0 24 24"><path d="M10 18h4v-2h-4v2zM3 6v2h18V6H3zm3 7h12v-2H6v2z"/></svg>
            Filtra Catalogo
        </div>
        <form action="catalogo" method="GET">
            <!-- Manteniamo il parametro tipo se l'utente ci è arrivato cliccando sui link del menu -->
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
                        <option value="UOMO" <%= "Uomo".equalsIgnoreCase(request.getParameter("genere")) ? "selected" : "" %>>Uomo</option>
                        <option value="DONNA" <%= "Donna".equalsIgnoreCase(request.getParameter("genere")) ? "selected" : "" %>>Donna</option>
                        <option value="UNISEX" <%= "Unisex".equalsIgnoreCase(request.getParameter("genere")) ? "selected" : "" %>>Unisex</option>
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
                <a href="catalogo<%= (currentTipo != null) ? "?tipo=" + currentTipo : "" %>" class="btn-reset">Reset</a>
            </div>
        </form>
    </div>

    <div class="catalogo-container">
        <% 
            // 1. Recuperiamo la collezione passata dalla Servlet tramite getAttribute
            Collection<Occhiale> prodotti = (Collection<Occhiale>) request.getAttribute("prodotti");
            
            if (prodotti != null && !prodotti.isEmpty()) {
                for (Occhiale occhiale : prodotti) {
                    VersioneOcchiale versione = occhiale.getVersioneCorrente();
                    String marca = (versione != null && versione.getMarca() != null) ? versione.getMarca() : "Brand";
                    String modello = (versione != null && versione.getModello() != null) ? versione.getModello() : "Modello #" + occhiale.getId();
        %>
                    <div class="card-occhiale">
                        <div>
                            <div class="container-immagine">
                                <% 
                                    // Gestione Immagine BLOB con Scriptlet
                                    if (occhiale.getImmagine() != null && occhiale.getImmagine().length > 0) {
                                        String base64Image = Base64.getEncoder().encodeToString(occhiale.getImmagine());
                                Long.toString(occhiale.getImmagine().length);
                                %>
                                        <img class="img-occhiale" src="data:image/jpeg;base64,<%= base64Image %>" alt="Foto <%= modello %>" />
                                <% 
                                    } else { 
                                %>
                                        <img class="img-occhiale" src="https://via.placeholder.com/200x150?text=No+Image" alt="Nessuna immagine" />
                                <% 
                                    } 
                                %>
                            </div>

                            <h3 class="marca-modello"><%= marca %> - <%= modello %></h3>
                            
                            <p class="info-tecniche"><strong>Tipologia:</strong> <span><%= occhiale.getTipo() %></span></p>
                            
                            <% 
                                if (versione != null) { 
                            %>
                                <p class="info-tecniche"><strong>Genere:</strong> <span><%= versione.getGenere() %></span></p>
                                <p class="info-tecniche"><strong>Forma:</strong> <span><%= versione.getForma() != null ? versione.getForma() : "N/D" %></span></p>
                                <p class="info-tecniche"><strong>Taglia:</strong> <span><%= versione.getTaglia() != null ? versione.getTaglia() : "N/D" %></span></p>
                                
                                <p class="prezzo">€ <%= String.format("%.2f", versione.getPrezzo()) %></p>
                            <% 
                                } else {
                            %>
                                <p class="prezzo">Prezzo N/D</p>
                            <%
                                } 
                            %>

                            <div class="sezione-disponibilita">
                                <div class="titolo-disp">Colori disponibili:</div>
                                <div class="variants-wrap">
                                    <% 
                                        if (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) {
                                            for (Disponibile disp : occhiale.getDisponibilita()) {
                                                String nomeColore = disp.getColore().getNome() != null ? disp.getColore().getNome() : disp.getColore().getCodice();
                                    %>
                                                <span class="tag-disponibile">
                                                    <%= nomeColore %>
                                                </span>
                                    <% 
                                            }
                                        } else { 
                                    %>
                                            <span class="tag-esaurito">Esaurito</span>
                                    <% 
                                        } 
                                    %>
                                </div>
                            </div>
                        </div>

                        <!-- Bottone per visualizzare l'occhiale -->
                        <a href="occhiale?id=<%= occhiale.getId() %>" class="btn-occhiale">Vedi Dettagli</a>
                    </div>
        <% 
                } // Fine del ciclo for sugli occhiali
            } else { // Else dell'if iniziale (Catalogo vuoto)
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