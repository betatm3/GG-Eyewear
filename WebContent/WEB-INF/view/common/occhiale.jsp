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
    <title>Occhiale - GG Eyewear</title>
    
    <!-- Font Premium da Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/occhiale.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
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
                    <form action="carrello" method="GET">
                        <input type="hidden" name="action" value="aggiungi" />
                        <input type="hidden" name="idOcchiale" value="<%= occhiale.getId() %>" />
                        <input type="hidden" name="codiceVersioneOcchiale" value="<%= versione != null ? versione.getCodice() : 0 %>" />

                        <div class="variants-title">
                            <span>🎨</span> Scegli Colore &amp; Disponibilità
                        </div>
                        
                        <div class="variants-container">
                            <% 
                                if (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) {
                                    boolean first = true;
                                    boolean hasInStock = false;
                                    for (Disponibile disp : occhiale.getDisponibilita()) {
                                        String codiceColore = disp.getColore().getCodice();
                                        String nomeColore = disp.getColore().getNome() != null ? disp.getColore().getNome() : codiceColore;
                                        boolean inStock = disp.getQuantita() > 0;
                                        if (inStock) hasInStock = true;
                                        
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
                                        <div class="variant-pill <%= inStock ? "" : "disabled" %>">
                                            <label>
                                                <input type="radio" name="coloreScelto" value="<%= codiceColore %>" 
                                                       <%= inStock && first ? "checked" : "" %> 
                                                       <%= inStock ? "" : "disabled" %> />
                                                <div class="color-dot" style="background-color: <%= hexColor %>;"></div>
                                                <div class="variant-info">
                                                    <span class="variant-color"><%= nomeColore %></span>
                                                    <span class="variant-qty">
                                                        <% if (inStock) { %>
                                                            <span class="status-badge status-instock"><%= disp.getQuantita() %> Disponibili</span>
                                                        <% } else { %>
                                                            <span class="status-badge status-out">Esaurito</span>
                                                        <% } %>
                                                    </span>
                                                </div>
                                            </label>
                                        </div>
                            <% 
                                        if (inStock) {
                                            first = false;
                                        }
                                    }
                            %>
                                    </div>
                                    <button type="submit" class="btn-add-to-cart" <%= hasInStock ? "" : "disabled" %>>
                                        <%= hasInStock ? "🛒 Aggiungi al Carrello" : "❌ Prodotto Esaurito" %>
                                    </button>
                            <%
                                } else { 
                            %>
                                    <div class="empty-variants">
                                        <span>⚠️</span> Nessuna variante disponibile al momento.
                                    </div>
                                    </div>
                                    <button type="submit" class="btn-add-to-cart" disabled>
                                        ❌ Prodotto Esaurito
                                    </button>
                            <% 
                                } 
                            %>
                    </form>
                </div>

            </div>

        </div>

        <% 
            } else { 
        %>
            <div style="text-align: center; padding: 40px 0;">
                <h2 style="color: var(--danger-color); margin-bottom: 20px;">Prodotto Non Trovato</h2>
                <p style="color: var(--text-secondary); margin-bottom: 30px;">L'occhiale richiesto non esiste o non è attualmente disponibile.</p>
                <a href="catalogo" class="btn-back" style="margin-bottom: 0;">Torna al Catalogo</a>
            </div>
        <% 
            } 
        %>
    </div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
