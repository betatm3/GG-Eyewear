<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - GG Eyewear</title>
    
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/dashboard.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
<div class="container">
    <h1>GG Eyewear — Area Admin</h1>
    <div class="subtitle">Benvenuto nella dashboard di controllo del tuo negozio</div>

    
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-label">Ricavi Totali</div>
            <div class="stat-value highlight">€ <%= String.format("%.2f", (Double) request.getAttribute("totaleGuadagni")) %></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Ordini Totali</div>
            <div class="stat-value"><%= request.getAttribute("totaleOrdini") %></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Utenti Registrati</div>
            <div class="stat-value"><%= request.getAttribute("totaleUtenti") %></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Prodotti in Catalogo</div>
            <div class="stat-value"><%= request.getAttribute("totaleProdotti") %></div>
        </div>
    </div>

    
    <div class="actions-grid">
        <!-- Azione: Gestione Prodotti -->
        <a href="${pageContext.request.contextPath}/admin/GestioneProdotti" class="action-card">
            <div class="action-icon">
                <img src="${pageContext.request.contextPath}/images/icons8-product-24.png" alt="Gestione Prodotti" style="width: 28px; height: 28px; object-fit: contain;" />
            </div>
            <div class="action-title">Gestione Prodotti</div>
            <div class="action-desc">Inserisci nuovi occhiali, modifica le informazioni commerciali, i prezzi e gestisci le varianti di colore a magazzino.</div>
        </a>

      
        <a href="${pageContext.request.contextPath}/admin/VisualizzaOrdini" class="action-card">
            <div class="action-icon">
                <img src="${pageContext.request.contextPath}/images/icons8-order-24.png" alt="Gestione Ordini" style="width: 28px; height: 28px; object-fit: contain;" />
            </div>
            <div class="action-title">Gestione Ordini</div>
            <div class="action-desc">Visualizza gli ordini effettuati dai clienti, applica filtri avanzati e aggiorna lo stato degli ordini in tempo reale.</div>
        </a>

        
        <a href="${pageContext.request.contextPath}/home" class="action-card">
            <div class="action-icon">
                <img src="${pageContext.request.contextPath}/images/icons8-home-24.png" alt="Torna al Negozio" style="width: 28px; height: 28px; object-fit: contain;" />
            </div>
            <div class="action-title">Torna al Negozio</div>
            <div class="action-desc">Esci dall'area di amministrazione e torna alla home page pubblica dell'e-commerce per verificare i cambiamenti.</div>
        </a>
    </div>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
