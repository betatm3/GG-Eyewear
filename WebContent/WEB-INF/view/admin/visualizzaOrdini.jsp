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
    
    <!-- Font Premium da Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/visualizzaOrdiniAdmin.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
<div class="container">
    <!-- Torna alla Dashboard Admin -->
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-back">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="19" y1="12" x2="5" y2="12"></line>
            <polyline points="12 19 5 12 12 5"></polyline>
        </svg>
        Torna alla Dashboard Admin
    </a>

    <h1>GG Eyewear — Area Amministrazione</h1>
    <div class="subtitle">Gestione e aggiornamento degli ordini ricevuti</div>

    <% 
        String msg = request.getParameter("msg");
        if ("StatoAggiornato".equals(msg)) {
    %>
            <div class="success-banner">
                Stato dell'ordine aggiornato con successo!
            </div>
    <% 
        } 
    %>

    <!-- Sezione Filtri -->
    <%
        String paramGenere = request.getParameter("genere");
        if (paramGenere == null) paramGenere = "";
        
        String paramMarca = request.getParameter("marca");
        if (paramMarca == null) paramMarca = "";
        
        String paramStato = request.getParameter("stato");
        if (paramStato == null) paramStato = "";
        
        String paramMetodo = request.getParameter("metodoPagamento");
        if (paramMetodo == null) paramMetodo = "";
        
        String paramPrezzoMin = request.getParameter("prezzoMin");
        if (paramPrezzoMin == null) paramPrezzoMin = "";
        
        String paramPrezzoMax = request.getParameter("prezzoMax");
        if (paramPrezzoMax == null) paramPrezzoMax = "";
        
        String paramDataInizio = request.getParameter("dataInizio");
        if (paramDataInizio == null) paramDataInizio = "";
        
        String paramDataFine = request.getParameter("dataFine");
        if (paramDataFine == null) paramDataFine = "";
    %>
    <form action="${pageContext.request.contextPath}/admin/VisualizzaOrdini" method="GET" class="filters-section">
        <div class="filters-title">
            <svg viewBox="0 0 24 24"><path d="M10 18h4v-2h-4v2zM3 6v2h18V6H3zm3 7h12v-2H6v2z"/></svg>
            Filtra gli Ordini
        </div>
        <div class="filters-grid">
            <div class="filter-field">
                <label class="filter-label">Genere Occhiale</label>
                <select name="genere" class="filter-input">
                    <option value="">Tutti</option>
                    <option value="DA_SOLE" <%= "DA_SOLE".equals(paramGenere) ? "selected" : "" %>>Sole</option>
                    <option value="DA_VISTA" <%= "DA_VISTA".equals(paramGenere) ? "selected" : "" %>>Vista</option>
                </select>
            </div>
            <div class="filter-field">
                <label class="filter-label">Marca</label>
                <input type="text" name="marca" value="<%= paramMarca %>" placeholder="es. Ray-Ban" class="filter-input" />
            </div>
            <div class="filter-field">
                <label class="filter-label">Stato Ordine</label>
                <select name="stato" class="filter-input">
                    <option value="">Tutti</option>
                    <%
                        for (Stato s : Stato.values()) {
                            String sel = s.name().equals(paramStato) ? "selected" : "";
                    %>
                            <option value="<%= s.name() %>" <%= sel %>><%= s.name().replace("_", " ") %></option>
                    <%
                        }
                    %>
                </select>
            </div>
            <div class="filter-field">
                <label class="filter-label">Metodo Pagamento</label>
                <input type="text" name="metodoPagamento" value="<%= paramMetodo %>" placeholder="es. Carta di Credito" class="filter-input" />
            </div>
            <div class="filter-field">
                <label class="filter-label">Prezzo Min (€)</label>
                <input type="number" name="prezzoMin" step="0.01" value="<%= paramPrezzoMin %>" placeholder="Min" class="filter-input" />
            </div>
            <div class="filter-field">
                <label class="filter-label">Prezzo Max (€)</label>
                <input type="number" name="prezzoMax" step="0.01" value="<%= paramPrezzoMax %>" placeholder="Max" class="filter-input" />
            </div>
            <div class="filter-field">
                <label class="filter-label">Data Inizio</label>
                <input type="date" name="dataInizio" value="<%= paramDataInizio %>" class="filter-input" />
            </div>
            <div class="filter-field">
                <label class="filter-label">Data Fine</label>
                <input type="date" name="dataFine" value="<%= paramDataFine %>" class="filter-input" />
            </div>
        </div>
        <div class="filters-actions">
            <a href="${pageContext.request.contextPath}/admin/VisualizzaOrdini" class="btn-reset">Azzera filtri</a>
            <button type="submit" class="btn-filter">Filtra</button>
        </div>
    </form>

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
                            <!-- Informazioni Ordine -->
                            <div class="order-info">
                                <div class="order-id">Ordine #<%= ordine.getId() %></div>
                                <div class="order-customer">Cliente: <span><%= utenteEmail %></span></div>
                            </div>

                            <!-- Meta Informazioni -->
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

                            <!-- Form Modifica Stato -->
                            <% if (ordine.getStato() == Stato.CONSEGNATO) { %>
                                <div class="status-form" style="border-color: rgba(52, 211, 153, 0.2); background: rgba(52, 211, 153, 0.03);">
                                    <span style="color: #34d399; font-weight: 700; font-size: 0.85rem; letter-spacing: 0.05em; padding: 4px 12px; text-transform: uppercase;">Consegnato</span>
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
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
