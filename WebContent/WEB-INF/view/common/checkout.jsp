<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%@ page import="model.ProdottoAcquistato" %>
<%@ page import="model.Utente" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout Ordine - GG Eyewear</title>
    
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

        h1 {
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 30px;
            text-align: center;
            background: linear-gradient(to right, #ffffff, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Banner Feedback */
        .alert {
            border-radius: 16px;
            padding: 16px 20px;
            margin-bottom: 30px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-error {
            background: rgba(248, 113, 113, 0.1);
            border: 1px solid rgba(248, 113, 113, 0.2);
            color: var(--danger-color);
            box-shadow: 0 4px 15px rgba(248, 113, 113, 0.1);
        }

        .alert-success {
            background: rgba(52, 211, 153, 0.1);
            border: 1px solid rgba(52, 211, 153, 0.2);
            color: var(--success-color);
            box-shadow: 0 4px 15px rgba(52, 211, 153, 0.1);
            flex-direction: column;
            text-align: center;
            padding: 40px 20px;
        }

        .alert-success h2 {
            font-size: 1.8rem;
            margin-bottom: 10px;
        }

        .alert-success p {
            color: var(--text-secondary);
            margin-bottom: 25px;
        }

        /* Layout Grid */
        .checkout-grid {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 40px;
        }

        @media (max-width: 868px) {
            .checkout-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Sezione Modulo */
        .checkout-card {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 30px;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 1px solid var(--glass-border);
            padding-bottom: 12px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1.5fr 1fr;
            gap: 15px;
        }

        label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        input, select {
            width: 100%;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            color: var(--text-primary);
            font-family: inherit;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #818cf8;
            box-shadow: 0 0 10px rgba(129, 140, 248, 0.3);
            background: rgba(255, 255, 255, 0.05);
        }

        /* Carrello Riepilogo */
        .cart-summary {
            background: rgba(255, 255, 255, 0.01);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 30px;
            height: fit-content;
        }

        .cart-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.03);
        }

        .item-img-container {
            width: 60px;
            height: 60px;
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

        .item-details {
            flex-grow: 1;
        }

        .item-title {
            font-size: 0.95rem;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 4px;
        }

        .item-subtitle {
            font-size: 0.75rem;
            color: var(--text-secondary);
        }

        .item-price {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--text-primary);
            text-align: right;
        }

        .total-box {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid var(--glass-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .total-label {
            font-size: 1.1rem;
            font-weight: 700;
        }

        .total-price {
            font-size: 1.8rem;
            font-weight: 800;
            color: #34d399;
        }

        /* Pulsanti */
        .btn-order {
            background: var(--accent-gradient);
            color: #ffffff;
            border: none;
            width: 100%;
            padding: 14px;
            font-size: 1rem;
            font-weight: 700;
            border-radius: 12px;
            cursor: pointer;
            margin-top: 25px;
            box-shadow: 0 4px 15px var(--accent-glow);
            transition: all 0.3s ease;
        }

        .btn-order:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(129, 140, 248, 0.5);
            filter: brightness(1.1);
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            margin-bottom: 25px;
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

        .btn-success-home {
            background: var(--accent-gradient);
            color: #ffffff;
            text-decoration: none;
            font-weight: 600;
            padding: 12px 24px;
            border-radius: 10px;
            display: inline-block;
            box-shadow: 0 4px 12px var(--accent-glow);
            transition: all 0.3s ease;
        }

        .btn-success-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(129, 140, 248, 0.5);
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

        <% 
            String successo = (String) request.getAttribute("successo");
            String errore = (String) request.getAttribute("errore");
            
            if (successo != null) {
        %>
            <!-- Schermata di Conferma Ordine Riuscito -->
            <div class="alert alert-success">
                <h2>🎉 Ordine Confermato!</h2>
                <p><%= successo %></p>
                <a href="catalogo" class="btn-success-home">Continua lo Shopping</a>
            </div>
        <% 
            } else { 
        %>

            <h1>Completa il tuo Ordine</h1>

            <% if (errore != null) { %>
                <div class="alert alert-error">
                    <span>⚠️</span> <%= errore %>
                </div>
            <% } %>

            <div class="checkout-grid">
                
                <!-- Dettagli Spedizione e Pagamento -->
                <div class="checkout-card">
                    <form action="checkout" method="POST">
                        <div class="section-title">
                            <span>📦</span> Indirizzo di Spedizione
                        </div>
                        
                        <%
                            Utente utente = (Utente) session.getAttribute("utenteLoggato");
                            String nome = utente != null ? utente.getNome() : "";
                            String cognome = utente != null ? utente.getCognome() : "";
                            String indirizzoEsteso = utente != null && utente.getIndirizzo() != null ? utente.getIndirizzo() : "";
                            String telefono = utente != null && utente.getTelefono() != null ? utente.getTelefono() : "";
                            
                            // Splittiamo l'indirizzo per precompilare se possibile
                            String via = indirizzoEsteso;
                            String capVal = "";
                            String cittaVal = "";
                            if (indirizzoEsteso.contains(",")) {
                                String[] parti = indirizzoEsteso.split(",");
                                via = parti[0].trim();
                                if (parti.length > 1) {
                                    String resto = parti[1].trim();
                                    String[] restoParti = resto.split(" ");
                                    if (restoParti.length > 0) capVal = restoParti[0];
                                    if (restoParti.length > 1) {
                                        StringBuilder sb = new StringBuilder();
                                        for(int i=1; i<restoParti.length; i++) {
                                            sb.append(restoParti[i]).append(" ");
                                        }
                                        cittaVal = sb.toString().trim();
                                    }
                                }
                            }
                        %>
                        
                        <div class="form-group">
                            <label>Destinatario</label>
                            <input type="text" value="<%= nome %> <%= cognome %>" disabled style="opacity: 0.6; cursor: not-allowed;" />
                        </div>

                        <div class="form-group">
                            <label for="indirizzo">Indirizzo (Via, Piazza, Numero Civico)</label>
                            <input type="text" id="indirizzo" name="indirizzo" value="<%= via %>" required placeholder="Es. Via Roma 12" />
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="citta">Città</label>
                                <input type="text" id="citta" name="citta" value="<%= cittaVal %>" required placeholder="Es. Napoli" />
                            </div>
                            <div class="form-group">
                                <label for="cap">CAP</label>
                                <input type="text" id="cap" name="cap" value="<%= capVal %>" required placeholder="Es. 80100" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="telefono">Recapito Telefonico</label>
                            <input type="tel" id="telefono" name="telefono" value="<%= telefono %>" required placeholder="Es. 3331234567" />
                        </div>

                        <div class="section-title" style="margin-top: 40px;">
                            <span>💳</span> Metodo di Pagamento
                        </div>

                        <div class="form-group">
                            <label for="metodoPagamento">Scegli come pagare</label>
                            <select id="metodoPagamento" name="metodoPagamento" required>
                                <option value="" disabled selected>Seleziona un'opzione...</option>
                                <option value="Carta di Credito">Carta di Credito / Debito</option>
                                <option value="PayPal">PayPal</option>
                                <option value="Contrassegno">Contrassegno (Pagamento alla consegna)</option>
                            </select>
                        </div>

                        <button type="submit" class="btn-order">Conferma e Ordina</button>
                    </form>
                </div>

                <!-- Riepilogo Carrello -->
                <div class="cart-summary">
                    <div class="section-title">
                        <span>🛒</span> Riepilogo Ordine
                    </div>

                    <% 
                        List<ProdottoAcquistato> carrello = (List<ProdottoAcquistato>) session.getAttribute("carrello");
                        double totaleOrdine = 0.0;
                        if (carrello != null && !carrello.isEmpty()) {
                            for (ProdottoAcquistato item : carrello) {
                                String marca = item.getVersioneOcchiale().getMarca() != null ? item.getVersioneOcchiale().getMarca() : "Brand";
                                String modello = item.getVersioneOcchiale().getModello() != null ? item.getVersioneOcchiale().getModello() : "Modello";
                                String colore = item.getColore().getNome() != null ? item.getColore().getNome() : item.getColore().getCodice();
                                double prezzo = item.getVersioneOcchiale().getPrezzo();
                                double subtotale = prezzo * item.getQuantita();
                                totaleOrdine += subtotale;
                    %>
                                <div class="cart-item">
                                    <div class="item-img-container">
                                        <% if (item.getOcchiale().getImmagine() != null && item.getOcchiale().getImmagine().length > 0) { %>
                                            <% String base64 = Base64.getEncoder().encodeToString(item.getOcchiale().getImmagine()); %>
                                            <img class="item-img" src="data:image/jpeg;base64,<%= base64 %>" alt="<%= modello %>" />
                                        <% } else { %>
                                            <img class="item-img" src="https://via.placeholder.com/60x60?text=No" alt="No Image" />
                                        <% } %>
                                    </div>
                                    <div class="item-details">
                                        <div class="item-title"><%= marca %> - <%= modello %></div>
                                        <div class="item-subtitle">Colore: <%= colore %> | Qta: <%= item.getQuantita() %></div>
                                    </div>
                                    <div class="item-price">
                                        € <%= String.format("%.2f", subtotale) %>
                                    </div>
                                </div>
                    <% 
                            }
                        } else { 
                    %>
                            <p style="color: var(--text-secondary); text-align: center; padding: 20px 0;">Il carrello è vuoto.</p>
                    <% 
                        } 
                    %>

                    <div class="total-box">
                        <div class="total-label">Totale da Pagare</div>
                        <div class="total-price">€ <%= String.format("%.2f", totaleOrdine) %></div>
                    </div>
                </div>

            </div>

        <% 
            } 
        %>
    </div>

</body>
</html>
