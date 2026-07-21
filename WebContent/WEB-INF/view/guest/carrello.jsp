<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Base64" %>
<%@ page import="model.ProdottoAcquistato" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Il tuo Carrello - GG Eyewear</title>
    
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/carrello.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
    <div class="container">
        <h1>Il tuo Carrello</h1>
        <% 
            ArrayList<ProdottoAcquistato> carrello = (ArrayList<ProdottoAcquistato>) session.getAttribute("carrello");
        %>
        <div id="activeCartContent" style="<%= (carrello != null && !carrello.isEmpty()) ? "" : "display: none;" %>">
        <% 
            if (carrello != null && !carrello.isEmpty()) {
                double totaleCarrello = 0.0;
        %>
                <table class="cart-table" id="cartTable">
                    <thead>
                        <tr class="cart-header-row">
                            <th class="cart-header-cell" style="width: 100px;">Prodotto</th>
                            <th class="cart-header-cell">Dettagli</th>
                            <th class="cart-header-cell" style="width: 120px;">Prezzo</th>
                            <th class="cart-header-cell" style="width: 150px; text-align: center;">Quantità</th>
                            <th class="cart-header-cell" style="width: 120px; text-align: right;">Subtotale</th>
                            <th class="cart-header-cell" style="width: 60px; text-align: center;">Rimuovi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            for (ProdottoAcquistato item : carrello) {
                                int idOcchiale = item.getOcchiale().getId();
                                int codiceVersione = item.getVersioneOcchiale().getCodice();
                                String codiceColore = item.getColore().getCodice();
                                String nomeColore = item.getColore().getNome() != null ? item.getColore().getNome() : codiceColore;
                                String marca = item.getVersioneOcchiale().getMarca() != null ? item.getVersioneOcchiale().getMarca() : "Brand";
                                String modello = item.getVersioneOcchiale().getModello() != null ? item.getVersioneOcchiale().getModello() : "Modello";
                                double prezzoUnitario = item.getVersioneOcchiale().getPrezzo();
                                double subtotale = prezzoUnitario * item.getQuantita();
                                totaleCarrello += subtotale;
                        %>
                                <tr class="cart-row" data-id="<%= idOcchiale %>" data-codice="<%= codiceVersione %>" data-colore="<%= codiceColore %>">
                                    
                                    <td class="cart-cell">
                                        <div class="product-img-container">
                                             <% 
                                                String primaImgCart = (item.getOcchiale() != null) ? item.getOcchiale().getImmagine(0) : null;
                                                String imgSrcCart = null;
                                                if (primaImgCart != null && !primaImgCart.trim().isEmpty()) {
                                                    String trimmed = primaImgCart.trim();
                                                    if (trimmed.startsWith("data:") || trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
                                                        imgSrcCart = trimmed;
                                                    } else if (trimmed.startsWith("/") || trimmed.startsWith("images/")) {
                                                        imgSrcCart = request.getContextPath() + (trimmed.startsWith("/") ? "" : "/") + trimmed;
                                                    } else {
                                                        imgSrcCart = "data:image/jpeg;base64," + trimmed;
                                                    }
                                                }
                                                if (imgSrcCart != null) { 
                                             %>
                                                 <img class="product-img" src="<%= imgSrcCart %>" alt="<%= modello %>" />
                                             <% } else { %>
                                                 <img class="product-img" src="https://via.placeholder.com/80x60?text=No+Image" alt="No Image" />
                                             <% } %>
                                        </div>
                                    </td>

                                    <td class="cart-cell">
                                        <div class="product-title"><%= marca %> - <%= modello %></div>
                                        <div class="product-details">
                                            <span>Colore: <strong><%= nomeColore %></strong></span> | 
                                            <span>Taglia: <strong><%= item.getVersioneOcchiale().getTaglia() != null ? item.getVersioneOcchiale().getTaglia() : "N/D" %></strong></span>
                                        </div>
                                    </td>

                                    <td class="cart-cell">
                                        <div class="product-price">€ <%= String.format("%.2f", prezzoUnitario) %></div>
                                    </td>

                                    <!-- Quantità (con controlli + e -) -->
                                    <td class="cart-cell" style="text-align: center;">
                                        <div class="qty-controls" style="justify-content: center;">
                                            <a href="carrello?action=modificaQuantita&idOcchiale=<%= idOcchiale %>&codiceVersioneOcchiale=<%= codiceVersione %>&coloreScelto=<%= codiceColore %>&quantita=<%= item.getQuantita() - 1 %>" class="btn-qty btn-minus">-</a>
                                            <span class="qty-val"><%= item.getQuantita() %></span>
                                            <a href="carrello?action=modificaQuantita&idOcchiale=<%= idOcchiale %>&codiceVersioneOcchiale=<%= codiceVersione %>&coloreScelto=<%= codiceColore %>&quantita=<%= item.getQuantita() + 1 %>" class="btn-qty btn-plus">+</a>
                                        </div>
                                    </td>

                                    <td class="cart-cell item-subtotal" style="text-align: right; font-weight: 700;">
                                        € <%= String.format("%.2f", subtotale) %>
                                    </td>

                                    <td class="cart-cell" style="text-align: center;">
                                        <a href="carrello?action=rimuovi&idOcchiale=<%= idOcchiale %>&codiceVersioneOcchiale=<%= codiceVersione %>&coloreScelto=<%= codiceColore %>" class="btn-remove" title="Rimuovi prodotto">
                                            🗑️
                                        </a>
                                    </td>

                                </tr>
                        <% 
                            } 
                        %>
                    </tbody>
                </table>
               
                <div class="cart-summary">
                    <div class="summary-row">
                        <div class="summary-label">Totale Carrello</div>
                        <div class="summary-total" id="cartTotal">€ <%= String.format("%.2f", totaleCarrello) %></div>
                    </div>
                    
                    <div class="action-buttons">
                        <a href="/common/checkout" class="btn-checkout">Procedi al Checkout</a>
                        <a href="carrello?action=svuota" class="btn-shopping btn-clear-cart" style="color: var(--danger-color); border-color: rgba(248, 113, 113, 0.2);">Svuota Carrello</a>
                        <a href="catalogo" class="btn-shopping">Continua lo Shopping</a>
                    </div>
                </div>
        <% 
            } 
        %>
        </div>

        <div id="emptyCartContent" style="<%= (carrello == null || carrello.isEmpty()) ? "" : "display: none;" %>">
            <div class="empty-cart">
                <span class="empty-cart-icon">🛒</span>
                <div class="empty-cart-text">Il tuo carrello è attualmente vuoto.</div>
                <a href="catalogo" class="btn-checkout" style="display: inline-block; width: auto; padding: 14px 35px;">Inizia lo Shopping</a>
            </div>
        </div>

    </div>
<%@ include file="../partials/footer.jsp" %>
    <!-- Script AJAX per il carrello -->
    <script src="<%= request.getContextPath() %>/scripts/carrelloAjax.js"></script>
</body>
</html>