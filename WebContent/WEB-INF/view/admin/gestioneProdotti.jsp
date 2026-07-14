<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Base64" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="model.*" %>
<%@ page import="dao.*" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestione Prodotti - Area Amministratore</title>
    
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
            --accent-glow: rgba(129, 140, 248, 0.2);
            --danger-gradient: linear-gradient(135deg, #f87171 0%, #ef4444 100%);
            --danger-glow: rgba(248, 113, 113, 0.2);
            --success-color: #34d399;
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
            padding: 40px 20px;
        }

        .container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            gap: 40px;
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
            background: linear-gradient(to right, #ffffff, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 5px;
        }

        .subtitle {
            font-size: 1rem;
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        /* Layout Principale */
        .main-layout {
            display: grid;
            grid-template-columns: 1.4fr 1fr;
            gap: 40px;
            align-items: start;
        }

        @media (max-width: 1024px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
        }

        /* Card Generica Glassmorphic */
        .card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            box-shadow: var(--shadow-primary);
            padding: 30px;
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .card-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 25px;
            border-bottom: 1px solid var(--glass-border);
            padding-bottom: 12px;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Tabella Prodotti */
        .prod-table-container {
            overflow-x: auto;
        }

        .prod-table {
            width: 100%;
            border-collapse: collapse;
        }

        .prod-th {
            text-align: left;
            padding: 12px;
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-bottom: 1px solid var(--glass-border);
        }

        .prod-tr {
            border-bottom: 1px solid rgba(255, 255, 255, 0.02);
            transition: background 0.3s ease;
        }

        .prod-tr:hover {
            background: rgba(255, 255, 255, 0.015);
        }

        .prod-tr.inactive {
            opacity: 0.5;
        }

        .prod-td {
            padding: 15px 12px;
            font-size: 0.9rem;
            vertical-align: middle;
        }

        .prod-img-container {
            width: 60px;
            height: 45px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .prod-img {
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
        }

        .status-badge {
            font-size: 0.75rem;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 6px;
            text-transform: uppercase;
        }

        .status-badge.active {
            background: rgba(52, 211, 153, 0.15);
            color: var(--success-color);
        }

        .status-badge.inactive {
            background: rgba(248, 113, 113, 0.15);
            color: var(--danger-gradient);
        }

        /* Pulsanti Azione */
        .actions-group {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-action {
            text-decoration: none;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .btn-action.edit {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
            color: #ffffff;
        }

        .btn-action.edit:hover {
            background: rgba(255, 255, 255, 0.12);
        }

        .btn-action.color {
            background: rgba(129, 140, 248, 0.15);
            color: #818cf8;
            border: 1px solid rgba(129, 140, 248, 0.2);
        }

        .btn-action.color:hover {
            background: rgba(129, 140, 248, 0.25);
            transform: scale(1.03);
        }

        .btn-action.delete {
            background: rgba(248, 113, 113, 0.15);
            color: #f87171;
            border: 1px solid rgba(248, 113, 113, 0.2);
        }

        .btn-action.delete:hover {
            background: rgba(248, 113, 113, 0.25);
        }

        /* Form di Inserimento/Modifica */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .form-group {
            margin-bottom: 12px;
        }

        label {
            display: block;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        input, select {
            width: 100%;
            padding: 10px 14px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            color: var(--text-primary);
            font-family: inherit;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #818cf8;
            box-shadow: 0 0 10px rgba(129, 140, 248, 0.3);
            background: rgba(255, 255, 255, 0.05);
        }

        select option {
            background: #1e1b4b;
            color: #ffffff;
        }

        .btn-submit {
            background: var(--accent-gradient);
            color: #ffffff;
            border: none;
            width: 100%;
            padding: 12px;
            font-size: 0.95rem;
            font-weight: 700;
            border-radius: 10px;
            cursor: pointer;
            margin-top: 15px;
            box-shadow: 0 4px 12px var(--accent-glow);
            transition: all 0.3s ease;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(129, 140, 248, 0.4);
            filter: brightness(1.1);
        }

        .btn-cancel {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            color: var(--text-secondary);
            text-decoration: none;
            display: block;
            text-align: center;
            padding: 10px;
            font-size: 0.9rem;
            font-weight: 600;
            border-radius: 10px;
            margin-top: 8px;
            transition: all 0.3s ease;
        }

        .btn-cancel:hover {
            background: rgba(255, 255, 255, 0.08);
            color: #ffffff;
        }

        /* Varianti Colore Dinamiche nell'Aggiunta */
        .color-variants-container {
            border: 1px dashed var(--glass-border);
            border-radius: 12px;
            padding: 15px;
            margin-top: 10px;
        }

        .color-row {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }

        .color-row:last-child {
            margin-bottom: 0;
        }

        /* Pannello Gestione Colori (Sezione 4) */
        .color-manager-list {
            margin-bottom: 25px;
        }

        .color-manager-item {
            background: rgba(255, 255, 255, 0.01);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .color-manager-name {
            font-weight: 700;
            font-size: 0.95rem;
        }

        .color-update-form {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .color-update-form input[type="number"] {
            width: 80px;
            padding: 8px;
        }

        .btn-mini {
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 0.8rem;
            cursor: pointer;
            border: none;
            font-weight: 700;
            transition: all 0.2s ease;
        }

        .btn-mini.save {
            background: #34d399;
            color: #0f172a;
        }

        .btn-mini.save:hover {
            filter: brightness(1.1);
        }

        .btn-mini.delete {
            background: #f87171;
            color: #ffffff;
            text-decoration: none;
        }

        .btn-mini.delete:hover {
            filter: brightness(1.1);
        }
    </style>
</head>
<body>

<%
    // Recupero del DataSource e DAO in modo dinamico all'interno della JSP
    DataSource ds = null;
    try {
        InitialContext ctx = new InitialContext();
        ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ecommerce_db");
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (ds != null) {
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);
        ColoreDAOImpl coloreDAO = new ColoreDAOImpl(ds);
        DisponibileDAOImpl disponibileDAO = new DisponibileDAOImpl(ds);

        Collection<VersioneOcchiale> versioniCorrenti = versioneDAO.doRetrieveByCorrente(true);
        Collection<Colore> tuttiColori = coloreDAO.doRetrieveAll(null);

        // Controllo se siamo in modalità modifica caratteristiche o modifica colori
        String editIdStr = request.getParameter("editId");
        String editCodiceStr = request.getParameter("editCodice");
        VersioneOcchiale versioneInModifica = null;
        if (editIdStr != null && editCodiceStr != null) {
            try {
                int editId = Integer.parseInt(editIdStr);
                int editCodice = Integer.parseInt(editCodiceStr);
                versioneInModifica = versioneDAO.doRetrieveByKey(editCodice, editId);
            } catch (Exception e) {
                // Ignore parsing errors
            }
        }

        String manageColorsIdStr = request.getParameter("manageColorsId");
        Occhiale occhialeColori = null;
        Collection<Disponibile> coloriAssociati = null;
        if (manageColorsIdStr != null) {
            try {
                int manageColorsId = Integer.parseInt(manageColorsIdStr);
                occhialeColori = occhialeDAO.doRetrieveByKey(manageColorsId);
                coloriAssociati = disponibileDAO.doRetrieveByOcchiale(manageColorsId);
            } catch (Exception e) {
                // Ignore
            }
        }
%>

<div class="container">
    
    <!-- Torna alla Dashboard Admin -->
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-back">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="19" y1="12" x2="5" y2="12"></line>
            <polyline points="12 19 5 12 12 5"></polyline>
        </svg>
        Torna alla Dashboard Admin
    </a>

    <div>
        <h1>Gestione Catalogo Prodotti</h1>
        <div class="subtitle">Visualizza, aggiungi o modifica i modelli e regola le scorte di magazzino</div>
    </div>

    <div class="main-layout">
        
        <!-- SEZIONE 1: Lista Prodotti Esistenti -->
        <div class="card">
            <div class="card-title">
                <span>🕶️</span> Prodotti in Catalogo
            </div>
            
            <div class="prod-table-container">
                <table class="prod-table">
                    <thead>
                        <tr>
                            <th class="prod-th" style="width: 70px;">Foto</th>
                            <th class="prod-th">Marca / Modello</th>
                            <th class="prod-th" style="width: 100px;">Prezzo</th>
                            <th class="prod-th" style="width: 120px;">Tipo / Genere</th>
                            <th class="prod-th" style="width: 80px; text-align: center;">Stato</th>
                            <th class="prod-th" style="width: 180px;">Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (versioniCorrenti != null && !versioniCorrenti.isEmpty()) {
                                for (VersioneOcchiale v : versioniCorrenti) {
                                    Occhiale occ = v.getOcchiale();
                                    boolean attivo = occ != null && occ.isAttivo();
                        %>
                                    <tr class="prod-tr <%= attivo ? "" : "inactive" %>">
                                        <td class="prod-td">
                                            <div class="prod-img-container">
                                                <% if (occ != null && occ.getImmagine() != null && occ.getImmagine().length > 0) { %>
                                                    <% String base64 = Base64.getEncoder().encodeToString(occ.getImmagine()); %>
                                                    <img class="prod-img" src="data:image/jpeg;base64,<%= base64 %>" alt="<%= v.getModello() %>" />
                                                <% } else { %>
                                                    <img class="prod-img" src="https://via.placeholder.com/60x45?text=No" alt="No Image" />
                                                <% } %>
                                            </div>
                                        </td>
                                        <td class="prod-td">
                                            <div style="font-weight: 700; color: #ffffff;"><%= v.getMarca() %></div>
                                            <div style="font-size: 0.8rem; color: var(--text-secondary);"><%= v.getModello() %> (ID: <%= occ.getId() %>)</div>
                                        </td>
                                        <td class="prod-td" style="font-weight: 700;">
                                            € <%= String.format("%.2f", v.getPrezzo()) %>
                                        </td>
                                        <td class="prod-td">
                                            <div style="font-weight: 600;"><%= occ.getTipo() != null ? occ.getTipo().name().replace("_", " ") : "N/D" %></div>
                                            <div style="font-size: 0.75rem; color: var(--text-secondary); text-transform: uppercase;"><%= v.getGenere() %></div>
                                        </td>
                                        <td class="prod-td" style="text-align: center;">
                                            <span class="status-badge <%= attivo ? "active" : "inactive" %>">
                                                <%= attivo ? "Attivo" : "Disattivato" %>
                                            </span>
                                        </td>
                                        <td class="prod-td">
                                            <div class="actions-group">
                                                <a href="GestioneProdotti?editId=<%= occ.getId() %>&editCodice=<%= v.getCodice() %>" class="btn-action edit" title="Modifica caratteristiche">✏️ Modifica</a>
                                                <a href="GestioneProdotti?manageColorsId=<%= occ.getId() %>" class="btn-action color" title="Gestisci quantità colori">🎨 Colori</a>
                                                <% if (attivo) { %>
                                                    <a href="GestioneProdotti?action=delete&id=<%= occ.getId() %>" class="btn-action delete" onclick="return confirm('Sicuro di voler disattivare questo prodotto dal catalogo pubblico?');" title="Disattiva prodotto">❌</a>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="6" class="prod-td" style="text-align: center; color: var(--text-secondary); padding: 30px;">
                                    Nessun prodotto presente nel database.
                                </td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- AREA OPERAZIONI (Aggiungi, Modifica o Colori in base ai parametri) -->
        <div class="card" id="form-container">
            
            <% if (versioneInModifica != null) { %>
                <!-- SEZIONE 3: Modifica Caratteristiche -->
                <div class="card-title">
                    <span>✏️</span> Modifica Caratteristiche
                </div>
                
                <form action="GestioneProdotti?action=updatecaratteristiche" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="idOcchiale" value="<%= versioneInModifica.getOcchiale().getId() %>" />
                    <input type="hidden" name="codiceVersione" value="<%= versioneInModifica.getCodice() %>" />
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="edit_marca">Marca</label>
                            <input type="text" id="edit_marca" name="marca" required value="<%= versioneInModifica.getMarca() %>" />
                        </div>
                        <div class="form-group">
                            <label for="edit_modello">Modello</label>
                            <input type="text" id="edit_modello" name="modello" required value="<%= versioneInModifica.getModello() %>" />
                        </div>
                        <div class="form-group">
                            <label for="edit_prezzo">Prezzo (€)</label>
                            <input type="number" id="edit_prezzo" name="prezzo" step="0.01" required value="<%= versioneInModifica.getPrezzo() %>" />
                        </div>
                        <div class="form-group">
                            <label for="edit_tipologia">Tipologia</label>
                            <select id="edit_tipologia" name="tipologia">
                                <% for (Tipologia t : Tipologia.values()) { %>
                                    <option value="<%= t.name() %>" <%= versioneInModifica.getOcchiale().getTipo() == t ? "selected" : "" %>><%= t.name().replace("_", " ") %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="edit_genere">Genere</label>
                            <select id="edit_genere" name="genere">
                                <% for (Genere g : Genere.values()) { %>
                                    <option value="<%= g.name() %>" <%= versioneInModifica.getGenere() == g ? "selected" : "" %>><%= g.name() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="edit_montatura">Montatura</label>
                            <select id="edit_montatura" name="montatura">
                                <% for (Montatura m : Montatura.values()) { %>
                                    <option value="<%= m.name() %>" <%= versioneInModifica.getMontatura() == m ? "selected" : "" %>><%= m.name() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="edit_forma">Forma Lenti</label>
                            <input type="text" id="edit_forma" name="forma" required value="<%= versioneInModifica.getForma() %>" />
                        </div>
                        <div class="form-group">
                            <label for="edit_taglia">Taglia</label>
                            <input type="text" id="edit_taglia" name="taglia" required value="<%= versioneInModifica.getTaglia() %>" />
                        </div>
                        <div class="form-group">
                            <label for="edit_materiale">Materiale</label>
                            <input type="text" id="edit_materiale" name="materiale" required value="<%= versioneInModifica.getMateriale() %>" />
                        </div>
                        <div class="form-group full-width">
                            <label for="edit_immagine">Nuova Immagine (Lascia vuoto per non cambiare)</label>
                            <input type="file" id="edit_immagine" name="immagine" accept="image/*" />
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-submit">Salva Modifiche</button>
                    <a href="GestioneProdotti" class="btn-cancel">Annulla Modifica</a>
                </form>

            <% } else if (occhialeColori != null) { %>
                <!-- SEZIONE 4: Gestione Colori -->
                <div class="card-title">
                    <span>🎨</span> Gestione Colori & Scorte
                </div>
                
                <div style="margin-bottom: 20px; font-size: 0.95rem; color: var(--text-secondary);">
                    Stai gestendo le varianti di colore del prodotto: <strong style="color: #ffffff;">ID <%= occhialeColori.getId() %></strong>
                </div>

                <!-- Lista colori correnti -->
                <div class="color-manager-list">
                    <%
                        if (coloriAssociati != null && !coloriAssociati.isEmpty()) {
                            for (Disponibile disp : coloriAssociati) {
                                // Recupera nome colore
                                Colore cDettaglio = coloreDAO.doRetrieveByKey(disp.getColore().getCodice());
                                String nomeC = cDettaglio != null ? cDettaglio.getNome() : disp.getColore().getCodice();
                    %>
                                <div class="color-manager-item">
                                    <div class="color-manager-name">
                                        🎨 <%= nomeC %> <span style="font-size: 0.8rem; color: var(--text-secondary);">(<%= disp.getColore().getCodice() %>)</span>
                                    </div>
                                    
                                    <div class="color-update-form">
                                        <!-- Aggiornamento quantità -->
                                        <form action="GestioneProdotti?action=updatecolori&subAction=updatequantity" method="POST" style="display: flex; gap: 6px;">
                                            <input type="hidden" name="idOcchiale" value="<%= occhialeColori.getId() %>" />
                                            <input type="hidden" name="codiceColore" value="<%= disp.getColore().getCodice() %>" />
                                            <input type="number" name="quantita" value="<%= disp.getQuantita() %>" min="0" required />
                                            <button type="submit" class="btn-mini save">Aggiorna</button>
                                        </form>

                                        <!-- Rimozione colore -->
                                        <a href="GestioneProdotti?action=updatecolori&subAction=removecolor&idOcchiale=<%= occhialeColori.getId() %>&codiceColore=<%= disp.getColore().getCodice() %>" 
                                           class="btn-mini delete" 
                                           onclick="return confirm('Sicuro di voler rimuovere questa variante colore? Verrà azzerato il magazzino per questa opzione.');">
                                            Rimuovi
                                        </a>
                                    </div>
                                </div>
                    <%
                            }
                        } else {
                    %>
                        <div style="text-align: center; color: var(--text-secondary); padding: 15px;">
                            Nessuna variante colore associata a questo modello.
                        </div>
                    <%
                        }
                    %>
                </div>

                <!-- Form Aggiungi Nuova Variante Colore -->
                <div style="border-top: 1px solid var(--glass-border); padding-top: 20px; margin-top: 20px;">
                    <div style="font-weight: 700; font-size: 1rem; margin-bottom: 15px; color: #ffffff;">Associa Nuova Variante Colore</div>
                    
                    <form action="GestioneProdotti?action=updatecolori&subAction=addcolor" method="POST">
                        <input type="hidden" name="idOcchiale" value="<%= occhialeColori.getId() %>" />
                        
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="nuovo_colore">Colore</label>
                                <select id="nuovo_colore" name="codiceColore" required>
                                    <option value="">Seleziona Colore...</option>
                                    <%
                                        if (tuttiColori != null) {
                                            for (Colore col : tuttiColori) {
                                    %>
                                                <option value="<%= col.getCodice() %>"><%= col.getNome() %> (<%= col.getCodice() %>)</option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="nuova_quantita">Quantità Iniziale</label>
                                <input type="number" id="nuova_quantita" name="quantita" min="0" required value="10" />
                            </div>
                        </div>
                        
                        <button type="submit" class="btn-submit">Associa Colore</button>
                        <a href="GestioneProdotti" class="btn-cancel">Chiudi Pannello Colori</a>
                    </form>
                </div>

            <% } else { %>
                <!-- SEZIONE 2: Form di Inserimento (Aggiungi Nuovo Prodotto) -->
                <div class="card-title">
                    <span>➕</span> Aggiungi Nuovo Occhiale
                </div>
                
                <form action="GestioneProdotti?action=add" method="POST" enctype="multipart/form-data">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="marca">Marca</label>
                            <input type="text" id="marca" name="marca" required placeholder="Es. Ray-Ban" />
                        </div>
                        <div class="form-group">
                            <label for="modello">Modello</label>
                            <input type="text" id="modello" name="modello" required placeholder="Es. Aviator Classic" />
                        </div>
                        <div class="form-group">
                            <label for="prezzo">Prezzo (€)</label>
                            <input type="number" id="prezzo" name="prezzo" step="0.01" required placeholder="Es. 129.90" />
                        </div>
                        <div class="form-group">
                            <label for="tipologia">Tipologia</label>
                            <select id="tipologia" name="tipologia">
                                <% for (Tipologia t : Tipologia.values()) { %>
                                    <option value="<%= t.name() %>"><%= t.name().replace("_", " ") %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="genere">Genere</label>
                            <select id="genere" name="genere">
                                <% for (Genere g : Genere.values()) { %>
                                    <option value="<%= g.name() %>"><%= g.name() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="montatura">Montatura</label>
                            <select id="montatura" name="montatura">
                                <% for (Montatura m : Montatura.values()) { %>
                                    <option value="<%= m.name() %>"><%= m.name() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="forma">Forma Lenti</label>
                            <input type="text" id="forma" name="forma" required placeholder="Es. Goccia / Tonda" />
                        </div>
                        <div class="form-group">
                            <label for="taglia">Taglia</label>
                            <input type="text" id="taglia" name="taglia" required placeholder="Es. L / 58-14" />
                        </div>
                        <div class="form-group">
                            <label for="materiale">Materiale</label>
                            <input type="text" id="materiale" name="materiale" required placeholder="Es. Metallo dorato" />
                        </div>
                        <div class="form-group full-width">
                            <label for="immagine">Immagine Prodotto</label>
                            <input type="file" id="immagine" name="immagine" accept="image/*" required />
                        </div>
                    </div>

                    <!-- Inserimento Rapido Varianti Colore -->
                    <div class="color-variants-container">
                        <label>Inserisci Fino a 3 Varianti Colore Iniziali</label>
                        
                        <div class="color-row">
                            <select name="codiceColore">
                                <option value="">Scegli primo colore...</option>
                                <% if (tuttiColori != null) { for (Colore col : tuttiColori) { %>
                                    <option value="<%= col.getCodice() %>"><%= col.getNome() %></option>
                                <% } } %>
                            </select>
                            <input type="number" name="quantitaColore" min="0" placeholder="Qta scorta" />
                        </div>

                        <div class="color-row">
                            <select name="codiceColore">
                                <option value="">Scegli secondo colore...</option>
                                <% if (tuttiColori != null) { for (Colore col : tuttiColori) { %>
                                    <option value="<%= col.getCodice() %>"><%= col.getNome() %></option>
                                <% } } %>
                            </select>
                            <input type="number" name="quantitaColore" min="0" placeholder="Qta scorta" />
                        </div>

                        <div class="color-row">
                            <select name="codiceColore">
                                <option value="">Scegli terzo colore...</option>
                                <% if (tuttiColori != null) { for (Colore col : tuttiColori) { %>
                                    <option value="<%= col.getCodice() %>"><%= col.getNome() %></option>
                                <% } } %>
                            </select>
                            <input type="number" name="quantitaColore" min="0" placeholder="Qta scorta" />
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-submit">Aggiungi Occhiale</button>
                </form>
            <% } %>

        </div>

    </div>
</div>

<%
    } else {
%>
    <div class="container" style="text-align: center; padding: 50px;">
        <h2>Errore di Configurazione Database</h2>
        <p style="color: var(--text-secondary); margin-top: 15px;">Impossibile recuperare il DataSource JNDI.</p>
    </div>
<%
    }
%>

</body>
</html>
