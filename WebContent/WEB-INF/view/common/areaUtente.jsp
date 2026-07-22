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
    
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/areaUtente.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
    <div class="container">
        
        
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
            <div class="errore-banner" style="background: rgba(239, 68, 68, 0.1); border: 1px solid rgb(239, 68, 68); color: rgb(239, 68, 68); padding: 12px 16px; border-radius: 8px; font-weight: 600; margin-bottom: 20px; text-align: center; font-family: 'Outfit', sans-serif;">
                <span>⚠️</span> <%= errore %>
            </div>
        <% 
            } 
            String msgSuccesso = (String) request.getAttribute("msgSuccesso");
            if (msgSuccesso != null) {
        %>
            <div class="successo-banner" style="background: rgba(16, 185, 129, 0.1); border: 1px solid rgb(16, 185, 129); color: rgb(16, 185, 129); padding: 12px 16px; border-radius: 8px; font-weight: 600; margin-bottom: 20px; text-align: center; font-family: 'Outfit', sans-serif;">
                <span>✓</span> <%= msgSuccesso %>
            </div>
        <% 
            } 
            String msgErrore = (String) request.getAttribute("msgErrore");
            if (msgErrore != null) {
        %>
            <div class="errore-banner" style="background: rgba(239, 68, 68, 0.1); border: 1px solid rgb(239, 68, 68); color: rgb(239, 68, 68); padding: 12px 16px; border-radius: 8px; font-weight: 600; margin-bottom: 20px; text-align: center; font-family: 'Outfit', sans-serif;">
                <span>⚠️</span> <%= msgErrore %>
            </div>
        <% 
            } 
            
            Utente utente = (Utente) session.getAttribute("utenteLoggato");
            if (utente != null) {
        %>

        <div class="area-grid">
            
            
            <div class="profile-card">
                
                <div style="display: flex; justify-content: flex-end; width: 100%; margin-bottom: -15px; position: relative; z-index: 10;">
                    <a href="javascript:void(0);" onclick="toggleEditProfile(true);" class="btn-edit-profile" title="Modifica dati" style="display: inline-flex; align-items: center; gap: 6px; text-decoration: none; font-size: 10px; font-weight: 700; color: #7F7159; text-transform: uppercase; letter-spacing: 0.05em; background: rgba(0, 0, 0, 0.04); padding: 6px 12px; border-radius: 20px; transition: all 0.2s ease;">
                        <img src="<%= request.getContextPath() %>/images/editProfile.png" alt="Modifica Dati" style="width: 12px; height: 12px; object-fit: contain;">
                        <span>Modifica dati</span>
                    </a>
                </div>
                
                <div class="user-icon-container" style="margin-top: 15px;">
                    <img src="<%= request.getContextPath() %>/images/user.png" alt="Profilo" style="width: 42px; height: 42px; object-fit: contain;" />
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

                <a href="<%= request.getContextPath() %>/common/logout" class="btn-logout" onclick="return confirm('Sei sicuro di voler uscire dal profilo?');">
                    <img src="<%= request.getContextPath() %>/images/icons8-logout-50.png" alt="Esci" style="width: 18px; height: 18px; margin-right: 8px; vertical-align: middle;" />
                    Esci dal Profilo
                </a>

            </div>

           
            <div class="orders-card" id="orders-card-section">
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
                                                                } else if (trimmed.startsWith("/") || trimmed.startsWith("images/") || trimmed.startsWith("img/")) {
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

            <!-- SCHEDA MODIFICA DATI UTENTE -->
            <div class="orders-card" id="edit-profile-card" style="display: none;">
                <div class="section-title">
                    <span>✏️</span> Modifica Dati Utente
                </div>
                
                <form action="<%= request.getContextPath() %>/area-utente" method="POST" class="edit-profile-form" style="display: flex; flex-direction: column; gap: 20px; font-family: 'Outfit', sans-serif;">
                    <input type="hidden" name="action" value="modifica" />
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div style="display: flex; flex-direction: column; gap: 6px;">
                            <label for="edit_nome" style="font-size: 13px; font-weight: 600; color: #555;">Nome</label>
                            <input type="text" id="edit_nome" name="nome" value="<%= utente.getNome() %>" required style="padding: 10px 14px; border: 1px solid var(--line); border-radius: 8px; font-size: 14px; background: #FFF;" />
                        </div>
                        
                        <div style="display: flex; flex-direction: column; gap: 6px;">
                            <label for="edit_cognome" style="font-size: 13px; font-weight: 600; color: #555;">Cognome</label>
                            <input type="text" id="edit_cognome" name="cognome" value="<%= utente.getCognome() %>" required style="padding: 10px 14px; border: 1px solid var(--line); border-radius: 8px; font-size: 14px; background: #FFF;" />
                        </div>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div style="display: flex; flex-direction: column; gap: 6px;">
                            <label for="edit_telefono" style="font-size: 13px; font-weight: 600; color: #555;">Telefono</label>
                            <input type="tel" id="edit_telefono" name="telefono" value="<%= utente.getTelefono() != null ? utente.getTelefono() : "" %>" style="padding: 10px 14px; border: 1px solid var(--line); border-radius: 8px; font-size: 14px; background: #FFF;" />
                        </div>
                        
                        <div style="display: flex; flex-direction: column; gap: 6px;">
                            <label for="edit_data_nascita" style="font-size: 13px; font-weight: 600; color: #555;">Data di Nascita</label>
                            <input type="date" id="edit_data_nascita" name="data_nascita" value="<%= utente.getDataNascita() != null ? utente.getDataNascita().toString() : "" %>" style="padding: 10px 14px; border: 1px solid var(--line); border-radius: 8px; font-size: 14px; background: #FFF;" />
                        </div>
                    </div>
                    
                    <div style="display: flex; flex-direction: column; gap: 6px;">
                        <label for="edit_indirizzo" style="font-size: 13px; font-weight: 600; color: #555;">Indirizzo di Spedizione</label>
                        <input type="text" id="edit_indirizzo" name="indirizzo" value="<%= utente.getIndirizzo() != null ? utente.getIndirizzo() : "" %>" style="padding: 10px 14px; border: 1px solid var(--line); border-radius: 8px; font-size: 14px; background: #FFF;" />
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 6px;">
                        <label for="edit_password" style="font-size: 13px; font-weight: 600; color: #555;">Nuova Password (Lascia vuoto per non cambiarla)</label>
                        <input type="password" id="edit_password" name="password" placeholder="Minimo 6 caratteri..." style="padding: 10px 14px; border: 1px solid var(--line); border-radius: 8px; font-size: 14px; background: #FFF;" />
                    </div>
                    
                    <div style="display: flex; gap: 12px; margin-top: 10px;">
                        <button type="submit" class="btn-admin-dashboard" style="background: #2B2B2B; color: #FFF; width: auto; margin-top: 0; padding: 10px 24px; border-radius: 8px; cursor: pointer; border: none; font-weight: 600;">Salva modifiche</button>
                        <button type="button" onclick="toggleEditProfile(false);" class="btn-cancel" style="background: #FAF8F5; color: #555; border: 1px solid var(--line); padding: 10px 24px; border-radius: 8px; cursor: pointer; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">Annulla</button>
                    </div>
                </form>
            </div>

        </div>

        <% 
            } 
        %>

    </div>
    
    <script>
        function toggleEditProfile(show) {
            var ordersCard = document.getElementById("orders-card-section");
            var editCard = document.getElementById("edit-profile-card");
            if (ordersCard && editCard) {
                if (show) {
                    ordersCard.style.display = "none";
                    editCard.style.display = "block";
                } else {
                    ordersCard.style.display = "block";
                    editCard.style.display = "none";
                }
            }
        }
    </script>
    
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
