<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="model.Ordine" %>
<%@ page import="model.Stato" %>
<%@ page import="model.ProdottoAcquistato" %>
<%@ page import="model.Utente" %>
<%@ page import="model.Colore" %>
<%@ page import="model.Occhiale" %>
<%@ page import="model.VersioneOcchiale" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestione Ordini (Admin) - GG Eyewear</title>
    
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/gestioneOrdini.css">
</head>
<body>
	<div class="orders-list">
        <% 
            Collection<Ordine> ordini = (Collection<Ordine>) request.getAttribute("listaOrdini");
            if (ordini != null && !ordini.isEmpty()) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                for (Ordine ordine : ordini) {
                    String dataStr = ordine.getDataOrdine() != null ? ordine.getDataOrdine().format(formatter) : "N/D";
                    String utenteEmail = (ordine.getUtente() != null && ordine.getUtente().getEmail() != null) ? ordine.getUtente().getEmail() : "Ospite";
        %>
                    <div class="order-card">
                        <div class="order-row">
                            
                            <div class="order-toggle-btn">
                                <svg class="chevron-icon" viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                            
                            <div class="order-info">
                                <div class="order-id">Ordine #<%= ordine.getId() %></div>
                                <div class="order-customer">Cliente: <span><%= utenteEmail %></span></div>
                            </div>
                            
                            <div class="order-meta">
                                <div class="meta-item">
                                    <div class="meta-label">Data</div>
                                    <div class="meta-value"><%= dataStr %></div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Totale</div>
                                    <div class="meta-value price">€ <%= String.format("%.2f", ordine.getTotale()) %></div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Pagamento</div>
                                    <div class="meta-value"><%= ordine.getMetodoPagamento() %></div>
                                </div>
                            </div>

                           
                            <% if (ordine.getStato() == Stato.CONSEGNATO) { %>
                                <div class="status-form" style="border-color: rgba(52, 211, 153, 0.2); background: rgba(52, 211, 153, 0.03);">
                                    <span style="color: #10B981; font-weight: 700; font-size: 0.85rem; letter-spacing: 0.05em; padding: 4px 12px; text-transform: uppercase;">Consegnato</span>
                                </div>
                            <% } else { %>
                                <form action="${pageContext.request.contextPath}/admin/ModificaStato" method="POST" class="status-form">
                                    <input type="hidden" name="idOrdine" value="<%= ordine.getId() %>" />
                                    <select name="nuovoStato" class="status-select">
                                        <% 
                                            for (Stato s : Stato.values()) {
                                                String selected = (ordine.getStato() == s) ? "selected" : "";
                                                String disabled = (ordine.getStato() != null && s.ordinal() < ordine.getStato().ordinal()) ? "disabled" : "";
                                        %>
                                                <option value="<%= s.name() %>" <%= selected %> <%= disabled %>><%= s.name().replace("_", " ") %></option>
                                        <% 
                                            } 
                                        %>
                                    </select>
                                    <button type="submit" class="status-btn">Aggiorna</button>
                                </form>
                            <% } %>
                        </div>
                        
                        <% 
                            Map<Integer, Collection<ProdottoAcquistato>> prodottiMap = (Map<Integer, Collection<ProdottoAcquistato>>) request.getAttribute("prodottiOrdineMap");
                            Collection<ProdottoAcquistato> items = (prodottiMap != null) ? prodottiMap.get(ordine.getId()) : null;
                            Utente cliente = ordine.getUtente();
                        %>
                        <div class="order-details">
                            <div class="details-grid">
                                <div class="details-section shipping-info">
                                    <h4 class="details-title">
                                        Dettagli Spedizione
                                    </h4>
                                    <div class="shipping-details-content">
                                        <p><strong>Destinatario:</strong> <%= (cliente != null && cliente.getNome() != null) ? (cliente.getNome() + " " + cliente.getCognome()) : "N/D" %></p>
                                        <p><strong>Indirizzo:</strong> <%= (cliente != null && cliente.getIndirizzo() != null) ? cliente.getIndirizzo() : "N/D" %></p>
                                        <p><strong>Telefono:</strong> <%= (cliente != null && cliente.getTelefono() != null) ? cliente.getTelefono() : "N/D" %></p>
                                    </div>
                                </div>
                                
                                <div class="details-section order-items">
                                    <h4 class="details-title">Prodotti Ordinati</h4>
                                    <% if (items != null && !items.isEmpty()) { %>
                                        <div class="items-table-wrapper">
                                            <table class="items-table">
                                                <thead>
                                                    <tr>
                                                        <th>Marca &amp; Modello</th>
                                                        <th>Colore</th>
                                                        <th>Misura</th>
                                                        <th style="text-align: center;">Q.tà</th>
                                                        <th style="text-align: right;">Prezzo</th>
                                                        <th style="text-align: right;">Subtotale</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% 
                                                        for (ProdottoAcquistato item : items) { 
                                                            double prezzoUnitario = (item.getVersioneOcchiale() != null) ? item.getVersioneOcchiale().getPrezzo() : 0.0;
                                                            double subtotale = prezzoUnitario * item.getQuantita();
                                                            String marcaStr = (item.getVersioneOcchiale() != null) ? item.getVersioneOcchiale().getMarca() : "N/D";
                                                            String modelloStr = (item.getVersioneOcchiale() != null) ? item.getVersioneOcchiale().getModello() : "N/D";
                                                            String coloreStr = (item.getColore() != null) ? item.getColore().getNome() : "N/D";
                                                            String tagliaStr = (item.getVersioneOcchiale() != null && item.getVersioneOcchiale().getTaglia() != null) ? item.getVersioneOcchiale().getTaglia().name() : "N/D";
                                                    %>
                                                        <tr>
                                                            <td><strong><%= marcaStr %></strong> — <%= modelloStr %></td>
                                                            <td><%= coloreStr %></td>
                                                            <td><%= tagliaStr %></td>
                                                            <td style="text-align: center;"><%= item.getQuantita() %></td>
                                                            <td style="text-align: right;">€ <%= String.format("%.2f", prezzoUnitario) %></td>
                                                            <td style="text-align: right; font-weight: 600;">€ <%= String.format("%.2f", subtotale) %></td>
                                                        </tr>
                                                    <% } %>
                                                </tbody>
                                            </table>
                                        </div>
                                    <% } else { %>
                                        <p class="no-items">Nessun dettaglio sui prodotti disponibile.</p>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
        <% 
                }
            } else {
        %>
                <div class="empty-orders">
                    Nessun ordine presente o corrispondente ai filtri impostati.
                </div>
        <% 
            }
        %>
    </div>
</body>
</html>