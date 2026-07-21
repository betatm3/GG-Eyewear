<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="model.Utente" %>
<%@ page import="model.Ordine" %>
<%@ page import="model.ProdottoAcquistato" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Area Personale - GG Eyewear</title>
    
    <!-- Font Premium da Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/areaUtente.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
    <div class="container">
        
        <!-- Header Action Bar -->
        <div style="display: flex; justify-content: flex-end; align-items: center; margin-bottom: 20px;">
            <% 
                Utente utenteCheckAdmin = (Utente) session.getAttribute("utenteLoggato");
                if (utenteCheckAdmin != null && utenteCheckAdmin.getRuolo() != null && "AMMINISTRATORE".equalsIgnoreCase(utenteCheckAdmin.getRuolo().name())) { 
            %>
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn-admin-dashboard" style="width: auto; margin-top: 0; padding: 8px 16px;">
                    <img src="<%= request.getContextPath() %>/images/icons8-product-24.png" alt="Admin" style="width: 16px; height: 16px; margin-right: 6px; vertical-align: middle;" />
                    Pannello Amministratore
                </a>
            <% } %>
        </div>

        <h1>Area Personale</h1>

        <% 
            String errore = (String) request.getAttribute("errore");
            if (errore != null) {
        %>
            <div class="errore-banner">
                <span>⚠️</span> <%= errore %>
            </div>
        <% 
            } 
            
            Utente utente = (Utente) session.getAttribute("utenteLoggato");
            if (utente != null) {
        %>

        <div class="area-grid">
            
            <!-- Colonna Profilo -->
            <div class="profile-card">
                
                <!-- Icona utente silhouette -->
                <div class="user-icon-container">
                    <img src="<%= request.getContextPath() %>/images/icons8-user-24.png" alt="Profilo" style="width: 42px; height: 42px; object-fit: contain;" />
                </div>

                <div class="profile-name"><%= utente.getNome() %> <%= utente.getCognome() %></div>
                <div class="profile-role"><%= utente.getRuolo() %></div>

                <div class="info-list">
                    <div class="info-group">
                        <div class="info-label">Email dell'Account</div>
                        <div class="info-value"><%= utente.getEmail() %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Indirizzo di Spedizione</div>
                        <div class="info-value">
                            <%= utente.getIndirizzo() != null && !utente.getIndirizzo().isEmpty() ? utente.getIndirizzo() : "Non inserito" %>
                        </div>
                    </div>

                    <div class="info-group">
                        <div class="info-label">Recapito Telefonico</div>
                        <div class="info-value">
                            <%= utente.getTelefono() != null && !utente.getTelefono().isEmpty() ? utente.getTelefono() : "Non inserito" %>
                        </div>
                    </div>

                    <div class="info-group">
                        <div class="info-label">Data di Nascita</div>
                        <div class="info-value">
                            <% 
                                if (utente.getDataNascita() != null) { 
                                    DateTimeFormatter formatterData = DateTimeFormatter.ofPattern("dd / myyyy"); 
                                    // Utilizziamo un semplice formato localizzato
                                    DateTimeFormatter formatterIT = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                                    out.print(utente.getDataNascita().format(formatterIT));
                                } else {
                                    out.print("Non inserita");
                                }
                            %>
                        </div>
                    </div>
                </div>

                <a href="<%= request.getContextPath() %>/common/logout" class="btn-logout">
                    <img src="<%= request.getContextPath() %>/images/icons8-logout-50.png" alt="Esci" style="width: 18px; height: 18px; margin-right: 8px; vertical-align: middle;" />
                    Esci dal Profilo
                </a>

            </div>

            <!-- Colonna Storico Ordini -->
            <div class="orders-card">
                <div class="section-title">
                    <span>🛍️</span> Il tuo Storico Ordini
                </div>

                <% 
                    Collection<Ordine> ordini = (Collection<Ordine>) request.getAttribute("ordini");
                    Map<Integer, Collection<ProdottoAcquistato>> prodottiMap = 
                        (Map<Integer, Collection<ProdottoAcquistato>>) request.getAttribute("prodottiOrdineMap");
                    
                    if (ordini != null && !ordini.isEmpty()) {
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy - HH:mm");
                        for (Ordine ordine : ordini) {
                %>
                            <div class="order-box">
                                
                                <!-- Intestazione Ordine -->
                                <div class="order-header">
                                    <div>
                                        <div class="order-id">Ordine #<%= ordine.getId() %></div>
                                        <div class="order-date">Effettuato il <%= ordine.getDataOrdine().format(formatter) %></div>
                                    </div>
                                    <div class="order-meta-info">
                                        <div class="order-status">Stato: <%= ordine.getStato().toString().replace("_", " ") %></div>
                                        <div class="order-total">€ <%= String.format("%.2f", ordine.getTotale()) %></div>
                                    </div>
                                </div>

                                <!-- Lista articoli all'interno dell'ordine -->
                                <div class="order-details-title">Articoli acquistati:</div>
                                <% 
                                    if (prodottiMap != null) {
                                        Collection<ProdottoAcquistato> items = prodottiMap.get(ordine.getId());
                                        if (items != null && !items.isEmpty()) {
                                            for (ProdottoAcquistato item : items) {
                                                String marca = item.getVersioneOcchiale() != null && item.getVersioneOcchiale().getMarca() != null 
                                                        ? item.getVersioneOcchiale().getMarca() : "Brand";
                                                String modello = item.getVersioneOcchiale() != null && item.getVersioneOcchiale().getModello() != null 
                                                        ? item.getVersioneOcchiale().getModello() : "Modello";
                                                String colore = item.getColore() != null && item.getColore().getNome() != null 
                                                        ? item.getColore().getNome() : (item.getColore() != null ? item.getColore().getCodice() : "N/D");
                                                double prezzoUnitario = item.getVersioneOcchiale() != null ? item.getVersioneOcchiale().getPrezzo() : 0.0;
                                                double subtotale = prezzoUnitario * item.getQuantita();
                                %>
                                                <div class="order-item-row">
                                                    <div class="item-img-container">
                                                         <% 
                                                            String primaImgUser = (item.getOcchiale() != null) ? item.getOcchiale().getImmagine(0) : null;
                                                            String imgSrcUser = null;
                                                            if (primaImgUser != null && !primaImgUser.trim().isEmpty()) {
                                                                String trimmed = primaImgUser.trim();
                                                                if (trimmed.startsWith("data:") || trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
                                                                    imgSrcUser = trimmed;
                                                                } else if (trimmed.startsWith("/") || trimmed.startsWith("images/")) {
                                                                    imgSrcUser = request.getContextPath() + (trimmed.startsWith("/") ? "" : "/") + trimmed;
                                                                } else {
                                                                    imgSrcUser = "data:image/jpeg;base64," + trimmed;
                                                                }
                                                            }
                                                            if (imgSrcUser != null) { 
                                                         %>
                                                             <img class="item-img" src="<%= imgSrcUser %>" alt="<%= modello %>" />
                                                         <% } else { %>
                                                             <img class="item-img" src="https://via.placeholder.com/50x50?text=No" alt="No Image" />
                                                         <% } %>
                                                    </div>
                                                    
                                                    <div class="item-info">
                                                        <div class="item-name"><%= marca %> - <%= modello %></div>
                                                        <div class="item-meta">Colore: <%= colore %> | Qtà: <%= item.getQuantita() %> | Prezzo Unitario: € <%= String.format("%.2f", prezzoUnitario) %></div>
                                                    </div>
                                                    
                                                    <div class="item-subtotal">
                                                        € <%= String.format("%.2f", subtotale) %>
                                                    </div>
                                                </div>
                                <% 
                                            }
                                        }
                                    } 
                                %>

                            </div>
                <% 
                        }
                    } else { 
                %>
                        <div class="no-orders">
                            <span class="no-orders-icon">🛒</span>
                            Non hai ancora effettuato ordini sul nostro store.
                        </div>
                <% 
                    } 
                %>
            </div>

        </div>

        <% 
            } 
        %>

    </div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
