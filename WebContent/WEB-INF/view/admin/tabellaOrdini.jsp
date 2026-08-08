<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="model.Ordine" %>
<%@ page import="model.Stato" %>
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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/gestioneOrdiniAdmin.css">
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