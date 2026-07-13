<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - GG Eyewear</title>
    
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
            padding: 50px 40px;
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h1 {
            font-size: 2.4rem;
            font-weight: 800;
            margin-bottom: 8px;
            text-align: center;
            background: linear-gradient(to right, #ffffff, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .subtitle {
            font-size: 1.05rem;
            color: var(--text-secondary);
            text-align: center;
            margin-bottom: 45px;
        }

        /* Griglia delle Statistiche */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 45px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.015);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 24px;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: var(--accent-gradient);
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: 0;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            border-color: rgba(255, 255, 255, 0.15);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.25);
        }

        .stat-card:hover::before {
            opacity: 0.02;
        }

        .stat-card * {
            position: relative;
            z-index: 1;
        }

        .stat-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-secondary);
            margin-bottom: 12px;
            font-weight: 600;
        }

        .stat-value {
            font-size: 1.8rem;
            font-weight: 800;
            color: #ffffff;
        }

        .stat-value.highlight {
            background: linear-gradient(to right, #34d399, #818cf8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Griglia dei Pulsanti di Navigazione */
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }

        .action-card {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 30px;
            text-decoration: none;
            color: var(--text-primary);
            display: flex;
            flex-direction: column;
            gap: 12px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .action-card::after {
            content: '';
            position: absolute;
            inset: 0;
            border-radius: 20px;
            padding: 1px;
            background: var(--accent-gradient);
            -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
            -webkit-mask-composite: xor;
            mask-composite: exclude;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .action-card:hover {
            transform: translateY(-4px);
            background: rgba(255, 255, 255, 0.04);
            box-shadow: 0 12px 30px rgba(129, 140, 248, 0.15);
        }

        .action-card:hover::after {
            opacity: 0.5;
        }

        .action-icon {
            width: 48px;
            height: 48px;
            background: rgba(129, 140, 248, 0.1);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #c084fc;
            transition: all 0.3s ease;
        }

        .action-card:hover .action-icon {
            background: var(--accent-gradient);
            color: #ffffff;
            transform: scale(1.05);
        }

        .action-icon svg {
            width: 24px;
            height: 24px;
            fill: currentColor;
        }

        .action-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #ffffff;
        }

        .action-desc {
            font-size: 0.9rem;
            color: var(--text-secondary);
            line-height: 1.4;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>GG Eyewear — Area Admin</h1>
    <div class="subtitle">Benvenuto nella dashboard di controllo del tuo negozio</div>

    <!-- Sezione Statistiche -->
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

    <!-- Pulsanti Azioni Rapide -->
    <div class="actions-grid">
        <!-- Azione: Gestione Prodotti -->
        <a href="${pageContext.request.contextPath}/admin/GestioneProdotti" class="action-card">
            <div class="action-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M19 13H5v-2h14v2zM12 5L5 12h14L12 5zm0 14l7-7H5l7 7z"/>
                </svg>
            </div>
            <div class="action-title">Gestione Prodotti</div>
            <div class="action-desc">Inserisci nuovi occhiali, modifica le informazioni commerciali, i prezzi e gestisci le varianti di colore a magazzino.</div>
        </a>

        <!-- Azione: Gestione Ordini -->
        <a href="${pageContext.request.contextPath}/admin/VisualizzaOrdini" class="action-card">
            <div class="action-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
                </svg>
            </div>
            <div class="action-title">Gestione Ordini</div>
            <div class="action-desc">Visualizza gli ordini effettuati dai clienti, applica filtri avanzati e aggiorna lo stato degli ordini in tempo reale.</div>
        </a>

        <!-- Azione: Torna al Negozio -->
        <a href="${pageContext.request.contextPath}/home" class="action-card">
            <div class="action-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
                </svg>
            </div>
            <div class="action-title">Torna al Negozio</div>
            <div class="action-desc">Esci dall'area di amministrazione e torna alla home page pubblica dell'e-commerce per verificare i cambiamenti.</div>
        </a>
    </div>
</div>

</body>
</html>
