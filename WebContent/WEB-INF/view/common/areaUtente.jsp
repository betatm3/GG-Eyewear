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
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/home" class="btn-back" style="margin-bottom: 0;">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Torna alla Home
            </a>

            <% 
                Utente utenteCheckAdmin = (Utente) session.getAttribute("utenteLoggato");
                if (utenteCheckAdmin != null && utenteCheckAdmin.getRuolo() != null && "AMMINISTRATORE".equalsIgnoreCase(utenteCheckAdmin.getRuolo().name())) { 
            %>
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn-admin-dashboard" style="width: auto; margin-top: 0; padding: 8px 16px;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width: 16px; height: 16px; margin-right: 6px;"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
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
                    <svg viewBox="0 0 24 24">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
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

                <% if (utente.getRuolo() != null && "AMMINISTRATORE".equalsIgnoreCase(utente.getRuolo().name())) { %>
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn-admin-dashboard">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width: 18px; height: 18px; margin-right: 8px;"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                        Pannello Amministratore
                    </a>
                <% } %>

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
                                                        <% if (item.getOcchiale() != null && item.getOcchiale().getImmagine() != null && item.getOcchiale().getImmagine().length > 0) { %>
                                                            <% String base64 = Base64.getEncoder().encodeToString(item.getOcchiale().getImmagine()); %>
                                                            <img class="item-img" src="data:image/jpeg;base64,<%= base64 %>" alt="<%= modello %>" />
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
