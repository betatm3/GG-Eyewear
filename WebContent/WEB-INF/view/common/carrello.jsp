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
    
    <style>
        :root {
            --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #311042 100%);
            --glass-bg: rgba(255, 255, 255, 0.03);
            --glass-border: rgba(255, 255, 255, 0.07);
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --accent-gradient: linear-gradient(135deg, #818cf8 0%, #c084fc 100%);
            --accent-glow: rgba(129, 140, 248, 0.3);
            --success-color: #34d399;
            --danger-color: #f87171;
            --shadow-primary: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: var(--bg-gradient);
            background-attachment: fixed;
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        .container {
            width: 100%;
            max-width: 1000px;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            box-shadow: var(--shadow-primary);
            padding: 40px;
            animation: fadeIn 0.8s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h1 {
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 30px;
            text-align: center;
            background: linear-gradient(to right, #ffffff, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Bottone Indietro */
        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            margin-bottom: 30px;
            transition: all 0.3s ease;
            width: fit-content;
        }

        .btn-back:hover {
            color: var(--text-primary);
            transform: translateX(-5px);
        }

        .btn-back svg {
            width: 20px;
            height: 20px;
        }

        /* Tabella Carrello */
        .cart-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        .cart-header-row {
            border-bottom: 1px solid var(--glass-border);
        }

        .cart-header-cell {
            text-align: left;
            padding: 12px 15px;
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .cart-row {
            border-bottom: 1px solid rgba(255, 255, 255, 0.03);
            transition: background 0.3s ease;
        }

        .cart-row:hover {
            background: rgba(255, 255, 255, 0.01);
        }

        .cart-cell {
            padding: 20px 15px;
            vertical-align: middle;
        }

        /* Foto Prodotto */
        .product-img-container {
            width: 80px;
            height: 60px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border: 1px solid var(--glass-border);
        }

        .product-img {
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
        }

        /* Info Dettagli */
        .product-title {
            font-size: 1.05rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 4px;
        }

        .product-details {
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        /* Prezzo */
        .product-price {
            font-size: 1rem;
            font-weight: 600;
        }

        /* Sezione Quantità */
        .qty-controls {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn-qty {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
            color: #ffffff;
            text-decoration: none;
            border-radius: 50%;
            font-weight: 700;
            font-size: 0.95rem;
            transition: all 0.2s ease;
        }

        .btn-qty:hover {
            background: var(--accent-gradient);
            border-color: transparent;
            transform: scale(1.1);
        }

        .qty-val {
            font-size: 1rem;
            font-weight: 700;
            min-width: 15px;
            text-align: center;
        }

        /* Bottone Rimuovi */
        .btn-remove {
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 1.2rem;
            transition: color 0.2s ease;
            display: inline-block;
            cursor: pointer;
        }

        .btn-remove:hover {
            color: var(--danger-color);
            transform: scale(1.1);
        }

        /* Riepilogo Cassa */
        .cart-summary {
            background: rgba(255, 255, 255, 0.01);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 30px;
            max-width: 400px;
            margin-left: auto;
            text-align: right;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .summary-label {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-secondary);
        }

        .summary-total {
            font-size: 1.8rem;
            font-weight: 800;
            color: #34d399;
        }

        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .btn-checkout {
            background: var(--accent-gradient);
            color: #ffffff;
            text-decoration: none;
            text-align: center;
            padding: 14px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 1rem;
            box-shadow: 0 4px 15px var(--accent-glow);
            transition: all 0.3s ease;
            display: block;
        }

        .btn-checkout:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(129, 140, 248, 0.5);
            filter: brightness(1.1);
        }

        .btn-shopping {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            color: var(--text-primary);
            text-decoration: none;
            text-align: center;
            padding: 12px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            display: block;
        }

        .btn-shopping:hover {
            background: rgba(255, 255, 255, 0.08);
            border-color: rgba(255, 255, 255, 0.2);
        }

        /* Cart vuoto */
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-cart-icon {
            font-size: 3.5rem;
            margin-bottom: 20px;
            display: block;
            opacity: 0.7;
        }

        .empty-cart-text {
            font-size: 1.15rem;
            color: var(--text-secondary);
            margin-bottom: 30px;
        }
    </style>
</head>
<body>

    <div class="container">
        
        
        <a href="catalogo" class="btn-back">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="19" y1="12" x2="5" y2="12"></line>
                <polyline points="12 19 5 12 12 5"></polyline>
            </svg>
            Torna al Catalogo
        </a>
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
                                            <% if (item.getOcchiale().getImmagine() != null && item.getOcchiale().getImmagine().length > 0) { %>
                                                <% String base64 = Base64.getEncoder().encodeToString(item.getOcchiale().getImmagine()); %>
                                                <img class="product-img" src="data:image/jpeg;base64,<%= base64 %>" alt="<%= modello %>" />
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

                                    <td class="cart-cell item-subtotal" style="text-align: right; font-weight: 700; color: #ffffff;">
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
                        <a href="checkout" class="btn-checkout">Procedi al Checkout</a>
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

    <!-- Script AJAX per il carrello -->
    <script src="<%= request.getContextPath() %>/scripts/carrelloAjax.js"></script>
</body>
</html>