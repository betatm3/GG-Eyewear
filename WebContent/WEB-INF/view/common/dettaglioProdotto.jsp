<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Base64" %>
<%@ page import="model.Occhiale" %>
<%@ page import="model.Disponibile" %>
<%@ page import="model.VersioneOcchiale" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dettaglio Prodotto - GG Eyewear</title>
    
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
            --accent-glow: #818cf8;
            --accent-gradient: linear-gradient(135deg, #818cf8 0%, #c084fc 100%);
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
            overflow-x: hidden;
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
            position: relative;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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
            transition: transform 0.3s ease;
        }

        /* Layout Grid */
        .product-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 50px;
        }

        @media (max-width: 868px) {
            .product-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
            .container {
                padding: 24px;
            }
        }

        /* Area Immagine */
        .image-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 20px;
            position: relative;
            overflow: hidden;
            box-shadow: inset 0 0 20px rgba(0,0,0,0.2);
            min-height: 380px;
        }

        .image-glow {
            position: absolute;
            width: 250px;
            height: 250px;
            background: var(--accent-gradient);
            filter: blur(80px);
            opacity: 0.15;
            z-index: 0;
            pointer-events: none;
        }

        .product-image {
            max-width: 100%;
            max-height: 340px;
            object-fit: contain;
            border-radius: 12px;
            z-index: 1;
            transition: transform 0.5s cubic-bezier(0.25, 1, 0.5, 1);
        }

        .image-section:hover .product-image {
            transform: scale(1.05) rotate(1deg);
        }

        /* Area Dettagli */
        .info-section {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .badge-type {
            background: var(--accent-gradient);
            color: #ffffff;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            padding: 6px 14px;
            border-radius: 50px;
            width: fit-content;
            margin-bottom: 15px;
            box-shadow: 0 4px 12px rgba(129, 140, 248, 0.3);
        }

        .brand {
            font-size: 1.2rem;
            text-transform: uppercase;
            letter-spacing: 0.15em;
            color: var(--text-secondary);
            font-weight: 400;
            margin-bottom: 5px;
        }

        .model-name {
            font-size: 2.5rem;
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 20px;
            background: linear-gradient(to right, #ffffff, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .price-tag {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .price-tag span {
            background: linear-gradient(135deg, #a7f3d0 0%, #34d399 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Spec Tab */
        .specs-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 30px;
        }

        .spec-item {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .spec-icon {
            font-size: 1.3rem;
            opacity: 0.8;
            color: var(--accent-glow);
        }

        .spec-label {
            font-size: 0.75rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .spec-value {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-primary);
        }

        /* Sezione Varianti */
        .variants-section {
            border-top: 1px solid var(--glass-border);
            padding-top: 25px;
        }

        .variants-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .variants-container {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .variant-pill {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 10px 16px;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
        }

        .variant-pill:hover {
            background: rgba(255, 255, 255, 0.06);
            transform: translateY(-2px);
            border-color: rgba(255, 255, 255, 0.15);
        }

        .color-dot {
            width: 14px;
            height: 14px;
            border-radius: 50%;
            box-shadow: 0 0 8px rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
        }

        .variant-info {
            display: flex;
            flex-direction: column;
        }

        .variant-color {
            font-size: 0.85rem;
            font-weight: 600;
        }

        .variant-qty {
            font-size: 0.7rem;
            color: var(--text-secondary);
        }

        .status-badge {
            font-size: 0.75rem;
            padding: 3px 8px;
            border-radius: 6px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .status-instock {
            background: rgba(52, 211, 153, 0.15);
            color: var(--success-color);
            border: 1px solid rgba(52, 211, 153, 0.2);
        }

        .status-out {
            background: rgba(248, 113, 113, 0.15);
            color: var(--danger-color);
            border: 1px solid rgba(248, 113, 113, 0.2);
        }

        .empty-variants {
            font-size: 0.9rem;
            color: var(--danger-color);
            display: flex;
            align-items: center;
            gap: 6px;
        }
    </style>
</head>
<body>

    <div class="container">
        
        <!-- Bottone Indietro -->
        <a href="catalogo" class="btn-back">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="19" y1="12" x2="5" y2="12"></line>
                <polyline points="12 19 5 12 12 5"></polyline>
            </svg>
            Torna al Catalogo
        </a>

        <% 
            Occhiale occhiale = (Occhiale) request.getAttribute("prodotto");
            if (occhiale != null) {
                VersioneOcchiale versione = occhiale.getVersioneCorrente();
                String marca = (versione != null && versione.getMarca() != null) ? versione.getMarca() : "Brand Generico";
                String modello = (versione != null && versione.getModello() != null) ? versione.getModello() : "Modello #" + occhiale.getId();
                double prezzo = (versione != null) ? versione.getPrezzo() : 0.00;
        %>
        
        <div class="product-grid">
            
            <!-- Immagine Occhiale -->
            <div class="image-section">
                <div class="image-glow"></div>
                <% 
                    if (occhiale.getImmagine() != null && occhiale.getImmagine().length > 0) {
                        String base64Image = Base64.getEncoder().encodeToString(occhiale.getImmagine());
                %>
                        <img class="product-image" src="data:image/jpeg;base64,<%= base64Image %>" alt="Foto <%= modello %>" />
                <% 
                    } else { 
                %>
                        <img class="product-image" src="https://via.placeholder.com/400x300?text=Immagine+Non+Disponibile" alt="Nessuna immagine" />
                <% 
                    } 
                %>
            </div>

            <!-- Dettagli Prodotto -->
            <div class="info-section">
                <div>
                    <div class="badge-type"><%= occhiale.getTipo() %></div>
                    <div class="brand"><%= marca %></div>
                    <h1 class="model-name"><%= modello %></h1>
                    
                    <div class="price-tag">
                        <span>€ <%= String.format("%.2f", prezzo) %></span>
                    </div>

                    <!-- Griglia Specifiche Tecniche -->
                    <div class="specs-grid">
                        
                        <% if (versione != null) { %>
                            <div class="spec-item">
                                <div class="spec-icon">👤</div>
                                <div>
                                    <div class="spec-label">Genere</div>
                                    <div class="spec-value"><%= versione.getGenere() %></div>
                                </div>
                            </div>
                            
                            <div class="spec-item">
                                <div class="spec-icon">📐</div>
                                <div>
                                    <div class="spec-label">Taglia</div>
                                    <div class="spec-value"><%= versione.getTaglia() != null ? versione.getTaglia() : "N/D" %></div>
                                </div>
                            </div>
                            
                            <div class="spec-item">
                                <div class="spec-icon">🛠</div>
                                <div>
                                    <div class="spec-label">Montatura</div>
                                    <div class="spec-value"><%= versione.getMontatura() != null ? versione.getMontatura() : "N/D" %></div>
                                </div>
                            </div>
                            
                            <div class="spec-item">
                                <div class="spec-icon">🕶</div>
                                <div>
                                    <div class="spec-label">Forma</div>
                                    <div class="spec-value"><%= versione.getForma() != null ? versione.getForma() : "N/D" %></div>
                                </div>
                            </div>
                            
                            <div class="spec-item">
                                <div class="spec-icon">💎</div>
                                <div>
                                    <div class="spec-label">Materiale</div>
                                    <div class="spec-value"><%= versione.getMateriale() != null ? versione.getMateriale() : "N/D" %></div>
                                </div>
                            </div>
                        <% } %>
                        
                        <div class="spec-item">
                            <div class="spec-icon">🏷</div>
                            <div>
                                <div class="spec-label">Codice Articolo</div>
                                <div class="spec-value">#<%= occhiale.getId() %></div>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- Varianti e Disponibilità -->
                <div class="variants-section">
                    <div class="variants-title">
                        <span>🎨</span> Varianti di Colore &amp; Stock
                    </div>
                    
                    <div class="variants-container">
                        <% 
                            if (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) {
                                for (Disponibile disp : occhiale.getDisponibilita()) {
                                    String codiceColore = disp.getColore().getCodice();
                                    String nomeColore = disp.getColore().getNome() != null ? disp.getColore().getNome() : codiceColore;
                                    
                                    // Determiniamo il colore esadecimale per l'anteprima visiva del pallino.
                                    // Se il codice colore assomiglia a un esadecimale (es: #FFFFFF o FFFFFF), lo usiamo.
                                    // Altrimenti mappiamo alcuni codici standard o usiamo una sfumatura generica.
                                    String hexColor = "#888888"; 
                                    if (codiceColore != null) {
                                        String upperCol = codiceColore.toUpperCase();
                                        if (upperCol.startsWith("#")) {
                                            hexColor = codiceColore;
                                        } else if (upperCol.contains("NERO") || upperCol.contains("BLACK")) {
                                            hexColor = "#1a1a1a";
                                        } else if (upperCol.contains("ROSSO") || upperCol.contains("RED")) {
                                            hexColor = "#dc2626";
                                        } else if (upperCol.contains("BLU") || upperCol.contains("BLUE")) {
                                            hexColor = "#2563eb";
                                        } else if (upperCol.contains("VERDE") || upperCol.contains("GREEN")) {
                                            hexColor = "#16a34a";
                                        } else if (upperCol.contains("ORO") || upperCol.contains("GOLD")) {
                                            hexColor = "#d97706";
                                        } else if (upperCol.contains("BIANCO") || upperCol.contains("WHITE")) {
                                            hexColor = "#ffffff";
                                        } else if (upperCol.contains("GRIGIO") || upperCol.contains("GREY") || upperCol.contains("GRAY")) {
                                            hexColor = "#6b7280";
                                        } else if (upperCol.contains("MARRONE") || upperCol.contains("BROWN")) {
                                            hexColor = "#78350f";
                                        }
                                    }
                        %>
                                    <div class="variant-pill">
                                        <div class="color-dot" style="background-color: <%= hexColor %>;"></div>
                                        <div class="variant-info">
                                            <span class="variant-color"><%= nomeColore %></span>
                                            <span class="variant-qty">
                                                <% if (disp.getQuantita() > 0) { %>
                                                    <span class="status-badge status-instock"><%= disp.getQuantita() %> Disponibili</span>
                                                <% } else { %>
                                                    <span class="status-badge status-out">Esaurito</span>
                                                <% } %>
                                            </span>
                                        </div>
                                    </div>
                        <% 
                                }
                            } else { 
                        %>
                                <div class="empty-variants">
                                    <span>⚠️</span> Nessuna variante disponibile al momento.
                                </div>
                        <% 
                            } 
                        %>
                    </div>
                </div>

            </div>

        </div>

        <% 
            } else { 
        %>
            <div style="text-align: center; padding: 40px 0;">
                <h2 style="color: var(--danger-color); margin-bottom: 20px;">Dettaglio Prodotto Non Trovato</h2>
                <p style="color: var(--text-secondary); margin-bottom: 30px;">Il prodotto richiesto non esiste o non è attualmente disponibile.</p>
                <a href="catalogo" class="btn-back" style="margin-bottom: 0;">Torna al Catalogo</a>
            </div>
        <% 
            } 
        %>
    </div>

</body>
</html>
