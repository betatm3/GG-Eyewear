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
    
    <style>
        :root {
            --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #311042 100%);
            --glass-bg: rgba(255, 255, 255, 0.03);
            --glass-border: rgba(255, 255, 255, 0.07);
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --accent-gradient: linear-gradient(135deg, #818cf8 0%, #c084fc 100%);
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
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(15px); }
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
            fill: currentColor;
        }

        h1 {
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 10px;
            text-align: center;
            background: linear-gradient(to right, #ffffff, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .subtitle {
            font-size: 1rem;
            color: var(--text-secondary);
            text-align: center;
            margin-bottom: 40px;
        }

        /* Banner Successo */
        .success-banner {
            background: rgba(52, 211, 153, 0.1);
            border: 1px solid rgba(52, 211, 153, 0.3);
            color: #34d399;
            padding: 14px 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            font-weight: 500;
            text-align: center;
            font-size: 0.95rem;
            animation: slideDown 0.4s ease-out;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Lista Ordini */
        .orders-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .order-card {
            background: rgba(255, 255, 255, 0.01);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .order-card:hover {
            border-color: rgba(255, 255, 255, 0.12);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        }

        .order-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 24px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .order-info {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .order-id {
            font-size: 1.1rem;
            font-weight: 700;
            color: #ffffff;
        }

        .order-customer {
            font-size: 0.9rem;
            color: var(--text-secondary);
        }

        .order-customer span {
            color: #c084fc;
            font-weight: 500;
        }

        .order-meta {
            display: flex;
            gap: 24px;
            align-items: center;
            flex-wrap: wrap;
        }

        .meta-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .meta-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-secondary);
        }

        .meta-value {
            font-size: 0.95rem;
            font-weight: 600;
        }

        .meta-value.price {
            color: #34d399;
            font-size: 1.05rem;
        }

        /* Form di modifica stato */
        .status-form {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            padding: 6px 12px;
            border-radius: 12px;
        }

        .status-select {
            background: transparent;
            border: none;
            color: var(--text-primary);
            font-family: inherit;
            font-size: 0.9rem;
            font-weight: 600;
            outline: none;
            cursor: pointer;
            padding-right: 10px;
        }

        .status-select option {
            background: #1e1b4b;
            color: var(--text-primary);
        }

        .status-btn {
            background: var(--accent-gradient);
            border: none;
            color: #ffffff;
            font-family: inherit;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 8px 16px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .status-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(192, 132, 252, 0.2);
        }

        .status-btn:active {
            transform: translateY(0);
        }

        .empty-orders {
            text-align: center;
            color: var(--text-secondary);
            font-style: italic;
            padding: 40px 0;
            font-size: 1.05rem;
        }

        /* Sezione Filtri */
        .filters-section {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 30px;
        }

        .filters-title {
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 16px;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filters-title svg {
            width: 18px;
            height: 18px;
            fill: currentColor;
        }

        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
        }

        .filter-field {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .filter-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-secondary);
            font-weight: 600;
        }

        .filter-input {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            padding: 10px 12px;
            color: var(--text-primary);
            font-family: inherit;
            font-size: 0.85rem;
            outline: none;
            transition: all 0.3s ease;
        }

        .filter-input:focus {
            border-color: rgba(192, 132, 252, 0.4);
            background: rgba(255, 255, 255, 0.05);
        }

        .filter-input::placeholder {
            color: rgba(255, 255, 255, 0.2);
        }

        .filters-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            align-items: center;
            border-top: 1px solid rgba(255, 255, 255, 0.04);
            padding-top: 16px;
        }

        .btn-filter {
            background: var(--accent-gradient);
            border: none;
            color: #ffffff;
            font-family: inherit;
            font-size: 0.85rem;
            font-weight: 700;
            padding: 10px 20px;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-filter:hover {
            box-shadow: 0 4px 15px rgba(192, 132, 252, 0.3);
            transform: translateY(-1px);
        }

        .btn-reset {
            background: transparent;
            border: 1px solid var(--glass-border);
            color: var(--text-secondary);
            font-family: inherit;
            font-size: 0.85rem;
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 10px;
            text-decoration: none;
            transition: all 0.3s ease;
            text-align: center;
        }

        .btn-reset:hover {
            color: var(--text-primary);
            border-color: rgba(255, 255, 255, 0.2);
        }
    </style>
</head>
<body>

<div class="container">
    <!-- Pulsante per tornare all'area o alla home -->
    <a href="${pageContext.request.contextPath}/home" class="btn-back">
        <svg viewBox="0 0 24 24">
            <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/>
        </svg>
        Torna alla Home
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

</body>
</html>
