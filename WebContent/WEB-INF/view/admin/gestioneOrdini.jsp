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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/gestioneOrdini.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
<div class="container">
    
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-back">
        <img src="${pageContext.request.contextPath}/images/icons8-home-24.png" alt="Torna" style="width: 16px; height: 16px; margin-right: 6px; vertical-align: middle;" />
        Torna alla Dashboard Admin
    </a>

    <h1>GG Eyewear — Area Amministrazione</h1>
    <div class="subtitle">Gestione e aggiornamento degli ordini ricevuti</div>

    <% 
        String msg = request.getParameter("msg");
        if ("StatoAggiornato".equals(msg)) {
    %>
		<div class="success-banner" style="display: flex ; align-items: center ; justify-content: space-between ;">    
			<div></div>        	
			<div style="display: flex; align-items: center; gap: 8px;">
			        <span>✓</span>
                	<span>Stato dell'ordine aggiornato con successo!</span>
                </div>
                <button type="button" class="close-banner-btn" title="Chiudi banner" aria-label="Chiudi banner" onclick="this.parentElement.style.display='none';" style=" color:  #5A7261;">✕</button>
                
        </div>
    <% 
        } 
    %>

    
    <%
    String paramTipo = request.getParameter("tipologia") != null ? request.getParameter("tipologia") : "";
    String paramMarca = request.getParameter("marca") != null ? request.getParameter("marca") : "";
    String paramStato = request.getParameter("stato") != null ? request.getParameter("stato") : "";
    String paramMetodo = request.getParameter("metodoPagamento") != null ? request.getParameter("metodoPagamento") : "";
    String paramPrezzoMin = request.getParameter("prezzoMin") != null ? request.getParameter("prezzoMin") : "";
    String paramPrezzoMax = request.getParameter("prezzoMax") != null ? request.getParameter("prezzoMax") : "";
    String paramDataInizio = request.getParameter("dataInizio") != null ? request.getParameter("dataInizio") : "";
    String paramDataFine = request.getParameter("dataFine") != null ? request.getParameter("dataFine") : "";
    String paramEmailUtente = request.getParameter("emailUtente") != null ? request.getParameter("emailUtente") : "";
%>
    <form id="filtriOrdine" class="filters-section">
        <div class="filters-title">
            <img src="${pageContext.request.contextPath}/images/icons8-filter-24.png" alt="Filtra" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;" />
            Filtra gli Ordini
        </div>
        <div class="filters-grid">
            <div class="filter-field">
                <label class="filter-label">Tipologia Occhiale</label>
                <select name="tipologia" class="filter-input">
                    <option value="">Tutti</option>
                    <option value="DA_SOLE" <%= "DA_SOLE".equals(paramTipo) ? "selected" : "" %>>Sole</option>
                    <option value="DA_VISTA" <%= "DA_VISTA".equals(paramTipo) ? "selected" : "" %>>Vista</option>
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
                <select name="metodoPagamento" class="filter-input">
                    <option value="">Tutti</option>
                    <option value="Carta di Credito">Carta di Credito / Debito</option>
                    <option value="PayPal">PayPal</option>
                    <option value="Contrassegno">Contrassegno (Pagamento alla consegna)</option>
                </select>
            </div>
            <div class="filter-field">
                <label class="filter-label">Prezzo Min (€)</label>
                <input type="number" name="prezzoMin" step="0.1" value="<%= paramPrezzoMin %>" placeholder="Min" class="filter-input" />
            </div>
            <div class="filter-field">
                <label class="filter-label">Prezzo Max (€)</label>
                <input type="number" name="prezzoMax" step="0.1" value="<%= paramPrezzoMax %>" placeholder="Max" class="filter-input" />
            </div>
            <div class="filter-field">
                <label class="filter-label">Data Inizio</label>
                <input type="date" name="dataInizio" value="<%= paramDataInizio %>" class="filter-input" />
            </div>
            <div class="filter-field">
                <label class="filter-label">Data Fine</label>
                <input type="date" name="dataFine" value="<%= paramDataFine %>" class="filter-input" />
            </div>
            <div class="filter-field">
                <label class="filter-label">Email Utente</label>
                <input type="email" name="emailUtente" value="<%= paramEmailUtente %>" placeholder="mario.rossi@email.it" class="filter-input" />
            </div>
            
            <div class="filters-actions">
		        <button type="button" id="btnResetFiltriOrdini" class="btn-reset" style="width: 100%; cursor: pointer;">
				    Azzera Filtri
				</button>
		    </div>
        </div>
    </form>
    <div id="ordiniContainer">
    	<jsp:include page="/WEB-INF/view/admin/tabellaOrdini.jsp" /> 
	</div>

    
</div>

<%@ include file="../partials/footer.jsp" %>

<script>
    const contextPath = "<%= request.getContextPath() %>";
</script>
<script src="<%= request.getContextPath() %>/scripts/gestioneOrdini.js"></script>
</body>
</html>
