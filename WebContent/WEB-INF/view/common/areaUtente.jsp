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
    
    <style>
        :root {
            --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #311042 100%);
            --glass-bg: rgba(255, 255, 255, 0.03);
            --glass-border: rgba(255, 255, 255, 0.07);
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --accent-gradient: linear-gradient(135deg, #818cf8 0%, #c084fc 100%);
            --accent-glow: rgba(129, 140, 248, 0.3);
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
            max-width: 1100px;
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

        h1 {
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 40px;
            text-align: center;
            background: linear-gradient(to right, #ffffff, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Layout Grid */
        .area-grid {
            display: grid;
            grid-template-columns: 1fr 1.8fr;
            gap: 40px;
            align-items: start;
        }

        @media (max-width: 868px) {
            .area-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
        }

        /* Profilo Card */
        .profile-card {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 30px;
            text-align: center;
            position: relative;
        }

        /* Icona Utente Silhouette SVG */
        .user-icon-container {
            width: 100px;
            height: 100px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, rgba(129, 140, 248, 0.15) 0%, rgba(192, 132, 252, 0.15) 100%);
            border: 1px solid var(--glass-border);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .user-icon-container svg {
            width: 50px;
            height: 50px;
            fill: var(--text-primary);
            opacity: 0.85;
        }

        .profile-name {
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 5px;
            color: #ffffff;
        }

        .profile-role {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: #c084fc;
            margin-bottom: 30px;
        }

        .info-list {
            text-align: left;
            border-top: 1px solid rgba(255, 255, 255, 0.04);
            padding-top: 20px;
        }

        .info-group {
            margin-bottom: 18px;
        }

        .info-label {
            font-size: 0.75rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 4px;
        }

        .info-value {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-primary);
            word-break: break-all;
        }

        /* Storico Ordini Card */
        .orders-card {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 30px;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 25px;
            border-bottom: 1px solid var(--glass-border);
            padding-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Singolo Ordine Box */
        .order-box {
            background: rgba(255, 255, 255, 0.01);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            margin-bottom: 25px;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .order-box:hover {
            border-color: rgba(255, 255, 255, 0.15);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .order-header {
            background: rgba(255, 255, 255, 0.02);
            padding: 16px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            border-bottom: 1px solid var(--glass-border);
        }

        .order-id {
            font-size: 1rem;
            font-weight: 700;
            color: #ffffff;
        }

        .order-date {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .order-meta-info {
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 0.85rem;
        }

        .order-status {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.03em;
        }

        .order-total {
            font-size: 1.1rem;
            font-weight: 700;
            color: #34d399;
        }

        .order-details-title {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-secondary);
            padding: 12px 20px 4px;
            font-weight: 600;
        }

        /* Prodotti Acquistati Righe */
        .order-item-row {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.02);
        }

        .order-item-row:last-child {
            border-bottom: none;
        }

        .item-img-container {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border: 1px solid var(--glass-border);
        }

        .item-img {
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
        }

        .item-info {
            flex-grow: 1;
        }

        .item-name {
            font-size: 0.9rem;
            font-weight: 600;
            color: #ffffff;
        }

        .item-meta {
            font-size: 0.75rem;
            color: var(--text-secondary);
        }

        .item-subtotal {
            font-size: 0.9rem;
            font-weight: 700;
            text-align: right;
        }

        .no-orders {
            text-align: center;
            padding: 40px 0;
            color: var(--text-secondary);
            font-size: 1rem;
        }

        .no-orders-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
            display: block;
        }

        .errore-banner {
            background: rgba(248, 113, 113, 0.1);
            border: 1px solid rgba(248, 113, 113, 0.2);
            color: var(--danger-color);
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }
    </style>
</head>
<body>

    <div class="container">
        
        <!-- Bottone Catalogo -->
        <a href="catalogo" class="btn-back">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="19" y1="12" x2="5" y2="12"></line>
                <polyline points="12 19 5 12 12 5"></polyline>
            </svg>
            Torna al Catalogo
        </a>

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

</body>
</html>
