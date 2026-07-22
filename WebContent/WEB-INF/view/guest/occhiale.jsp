<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%@ page import="model.Occhiale" %>
<%@ page import="model.Disponibile" %>
<%@ page import="model.VersioneOcchiale" %>
<%@ page import="model.Recensione" %>
<%@ page import="model.Utente" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dettaglio Occhiale - GG Eyewear</title>
    
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/occhiale.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
    <div class="container product-detail-container">

        <% 
            Occhiale occhiale = (Occhiale) request.getAttribute("prodotto");
            if (occhiale != null) {
                VersioneOcchiale versione = occhiale.getVersioneCorrente();
                String marca = (versione != null && versione.getMarca() != null && !versione.getMarca().trim().isEmpty()) ? versione.getMarca().trim() : "";
                String modello = (versione != null && versione.getModello() != null && !versione.getModello().trim().isEmpty()) ? versione.getModello().trim() : "";
                
                String titleDisplay;
                if (!marca.isEmpty() && !modello.isEmpty()) {
                    titleDisplay = marca + " - " + modello;
                } else if (!modello.isEmpty()) {
                    titleDisplay = modello;
                } else if (!marca.isEmpty()) {
                    titleDisplay = marca + " #" + occhiale.getId();
                } else {
                    titleDisplay = "Codice #" + occhiale.getId();
                }

                double prezzo = (versione != null) ? versione.getPrezzo() : 0.00;
                String taglia = (versione != null && versione.getTaglia() != null) ? versione.getTaglia() : "M";
                String materiale = (versione != null && versione.getMateriale() != null) ? versione.getMateriale() : "N/D";
                String genere = (versione != null && versione.getGenere() != null) ? versione.getGenere().name() : "N/D";
                String forma = (versione != null && versione.getForma() != null) ? versione.getForma() : "N/D";
                String montatura = (versione != null && versione.getMontatura() != null) ? versione.getMontatura().name() : "N/D";
                
                ArrayList<String> listaImmagini = (occhiale != null) ? occhiale.getImmagini() : null;
                List<String> immaginiResolute = new ArrayList<>();
                if (listaImmagini != null && !listaImmagini.isEmpty()) {
                    for (String path : listaImmagini) {
                        if (path != null && !path.trim().isEmpty()) {
                            String trimmed = path.trim();
                             if (trimmed.startsWith("data:") || trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
                                 immaginiResolute.add(trimmed);
                             } else if (trimmed.startsWith("/") || trimmed.startsWith("images/") || trimmed.startsWith("img/")) {
                                 String cleanPath = trimmed.replace("img/", "")
                                                           .replace("images/occhiali/", "")
                                                           .replace("images/", "");
                                 if (cleanPath.startsWith("/")) {
                                     cleanPath = cleanPath.substring(1);
                                 }
                                 immaginiResolute.add(request.getContextPath() + "/images/occhiali/" + cleanPath);
                             } else {
                                 immaginiResolute.add("data:image/jpeg;base64," + trimmed);
                             }
                        }
                    }
                }
                if (immaginiResolute.isEmpty()) {
                    immaginiResolute.add("https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=600&auto=format&fit=crop&q=80");
                }
                String imgSrc = immaginiResolute.get(0);

                
                Double mediaVotoObj = (Double) request.getAttribute("mediaVoto");
                Integer numRecensioniObj = (Integer) request.getAttribute("numRecensioni");
                double mediaVoto = (mediaVotoObj != null) ? mediaVotoObj : 0.0;
                int numRecensioni = (numRecensioniObj != null) ? numRecensioniObj : 0;
                @SuppressWarnings("unchecked")
                Collection<Recensione> recensioni = (Collection<Recensione>) request.getAttribute("recensioni");
        %>
        
        <div class="product-grid">
            
           
            <div class="gallery-wrapper">
                <div class="thumbnails-col">
                    <% 
                        for (int t = 0; t < immaginiResolute.size(); t++) {
                            String currentThumb = immaginiResolute.get(t);
                    %>
                            <div class="thumb-box <%= t == 0 ? "active" : "" %>" onclick="changeMainImage('<%= currentThumb %>', this)">
                                <img src="<%= currentThumb %>" alt="Vista <%= t + 1 %>" />
                            </div>
                    <% 
                        } 
                    %>
                </div>

                <div class="main-image-card">
                    <img id="mainProductImg" class="product-image" src="<%= imgSrc %>" alt="Foto <%= titleDisplay %>" />
                </div>
            </div>

            
            <div class="info-section">
                
                <div class="info-header-row">
                    <h1 class="model-name"><%= titleDisplay %></h1>
                </div>

                
                <div class="price-row">
                    <span class="price-val">€<%= String.format("%.2f", prezzo) %></span>
                </div>

                
                <div class="reviews-row">
                    <div class="rating-stars" title="<%= String.format("%.1f", mediaVoto) %> su 5 stelle">
                        <% 
                            int interoVotoHeader = (int) Math.round(mediaVoto);
                            for (int s = 1; s <= 5; s++) {
                                if (s <= interoVotoHeader) {
                        %>
                                    <span class="star filled">★</span>
                        <% 
                                } else { 
                        %>
                                    <span class="star empty">☆</span>
                        <% 
                                }
                            } 
                        %>
                    </div>
                    <a href="#recensioni" class="reviews-link">
                        <%= numRecensioni %> <%= (numRecensioni == 1) ? "Recensione" : "Recensioni" %>
                    </a>
                </div>

                
                <div class="details-grid-section" style="margin: 20px 0; display: grid; grid-template-columns: repeat(2, 1fr); gap: 14px; padding: 16px; background: rgba(0,0,0,0.02); border-radius: 8px; border: 1px solid var(--line); font-family: 'Outfit', sans-serif;">
                    <div style="display: flex; flex-direction: column; gap: 4px;">
                        <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: #888; font-weight: 600;">Taglia</span>
                        <span style="font-size: 14px; font-weight: 500; color: #2B2B2B;"><%= taglia %></span>
                    </div>
                    <div style="display: flex; flex-direction: column; gap: 4px;">
                        <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: #888; font-weight: 600;">Genere</span>
                        <span style="font-size: 14px; font-weight: 500; color: #2B2B2B;"><%= genere %></span>
                    </div>
                    <div style="display: flex; flex-direction: column; gap: 4px;">
                        <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: #888; font-weight: 600;">Materiale</span>
                        <span style="font-size: 14px; font-weight: 500; color: #2B2B2B;"><%= materiale %></span>
                    </div>
                    <div style="display: flex; flex-direction: column; gap: 4px;">
                        <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: #888; font-weight: 600;">Forma</span>
                        <span style="font-size: 14px; font-weight: 500; color: #2B2B2B;"><%= forma %></span>
                    </div>
                    <div style="display: flex; flex-direction: column; gap: 4px; grid-column: span 2;">
                        <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: #888; font-weight: 600;">Montatura</span>
                        <span style="font-size: 14px; font-weight: 500; color: #2B2B2B;"><%= montatura %></span>
                    </div>
                </div>

               
                <form action="carrello" method="POST" class="purchase-form">
                    <input type="hidden" name="action" value="aggiungi" />
                    <input type="hidden" name="idOcchiale" value="<%= occhiale.getId() %>" />
                    <input type="hidden" name="codiceVersioneOcchiale" value="<%= versione != null ? versione.getCodice() : 0 %>" />

                    <div class="color-selection-header">
                        <% 
                            String primoNomeColore = "Nero";
                            if (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) {
                                Disponibile d1 = occhiale.getDisponibilita().iterator().next();
                                if (d1.getColore() != null && d1.getColore().getNome() != null) {
                                    primoNomeColore = d1.getColore().getNome();
                                }
                            }
                        %>
                        <span class="field-title">Seleziona il colore: <strong id="selectedColorName"><%= primoNomeColore %></strong></span>
                        <span class="stock-badge in-stock">in magazzino</span>
                    </div>

                    <div class="color-swatches-container">
                        <% 
                            if (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) {
                                boolean first = true;
                                boolean hasInStock = false;
                                for (Disponibile disp : occhiale.getDisponibilita()) {
                                    String codiceColore = disp.getColore().getCodice();
                                    String nomeColore = disp.getColore().getNome() != null ? disp.getColore().getNome() : codiceColore;
                                    boolean inStock = disp.getQuantita() > 0;
                                    if (inStock) hasInStock = true;
                                    
                                    String cNameLower = nomeColore.toLowerCase();
                                    String hexColor = "#111111"; // default nero
                                    if (cNameLower.contains("marrone") || cNameLower.contains("tartarugato")) hexColor = "#5A3825";
                                    else if (cNameLower.contains("rosso") || cNameLower.contains("bordeaux")) hexColor = "#6B0F24";
                                    else if (cNameLower.contains("verde")) hexColor = "#3E6B48";
                                    else if (cNameLower.contains("oro") || cNameLower.contains("gold")) hexColor = "#D4AF37";
                                    else if (cNameLower.contains("argento") || cNameLower.contains("silver")) hexColor = "#C0C0C0";
                                    else if (cNameLower.contains("blu")) hexColor = "#1E3A8A";
                                    else if (cNameLower.contains("rosa")) hexColor = "#E8A598";
                        %>
                                    <label class="swatch-label <%= inStock ? "" : "disabled" %>">
                                        <input type="radio" name="coloreScelto" value="<%= codiceColore %>" 
                                               <%= inStock && first ? "checked" : "" %> 
                                               <%= inStock ? "" : "disabled" %>
                                               onchange="document.getElementById('selectedColorName').innerText = '<%= nomeColore %>'" />
                                        <span class="swatch-circle-btn" style="background-color: <%= hexColor %>;" title="<%= nomeColore %>"></span>
                                    </label>
                        <% 
                                    if (inStock) first = false;
                                }
                            } else { 
                        %>
                                <label class="swatch-label">
                                    <input type="radio" name="coloreScelto" value="C1" checked />
                                    <span class="swatch-circle-btn" style="background-color: #111111;" title="Nero"></span>
                                </label>
                                <label class="swatch-label">
                                    <input type="radio" name="coloreScelto" value="C2" />
                                    <span class="swatch-circle-btn" style="background-color: #5A3825;" title="Tartarugato"></span>
                                </label>
                        <% 
                            } 
                        %>
                    </div>

                    
                    <button type="submit" class="btn-main-action">
                        Aggiungi al Carrello
                    </button>
                </form>

                
                <div class="trust-list">
                    <div class="trust-item">
                        <span>1 Anno di garanzia</span>
                    </div>
                </div>

            </div>

        </div>

        
        <div id="recensioni" class="reviews-section-box">
            <h2 class="reviews-section-title">Recensioni dei Clienti</h2>

            <div class="reviews-summary-wrapper">
                
                <div class="summary-left-card">
                    <span class="big-rating-number"><%= numRecensioni > 0 ? String.format("%.1f", mediaVoto) : "0.0" %></span>
                    <div class="rating-stars big-stars">
                        <% 
                            int interoVotoSummary = (int) Math.round(mediaVoto);
                            for (int s = 1; s <= 5; s++) {
                                if (s <= interoVotoSummary) {
                        %>
                                    <span class="star filled">★</span>
                        <% 
                                } else { 
                        %>
                                    <span class="star empty">☆</span>
                        <% 
                                }
                            } 
                        %>
                    </div>
                    <span class="total-reviews-count"><%= numRecensioni %> <%= numRecensioni == 1 ? "valutazione totale" : "valutazioni totali" %></span>
                </div>

                
                <div class="write-review-card">
                    <h3>Scrivi la tua Recensione</h3>
                    <form action="${pageContext.request.contextPath}/recensione" method="POST" class="review-form">
                        <input type="hidden" name="occhialeId" value="<%= occhiale.getId() %>" />
                        
                        <% 
                            Utente uLog = (session != null) ? (Utente) session.getAttribute("utente") : null;
                            if (uLog == null) {
                        %>
                            <div class="form-group-field">
                                <label for="utenteEmail">La tua Email:</label>
                                <input type="email" id="utenteEmail" name="utenteEmail" placeholder="inserisci la tua email..." required class="review-input" />
                            </div>
                        <% } %>

                        <div class="form-group-field">
                            <label for="votoSelect">Valutazione (Stelle):</label>
                            <select id="votoSelect" name="voto" required class="review-select">
                                <option value="5">★★★★★ (5 Stelle - Eccellente)</option>
                                <option value="4">★★★★☆ (4 Stelle - Molto Buono)</option>
                                <option value="3">★★★☆☆ (3 Stelle - Medio)</option>
                                <option value="2">★★☆☆☆ (2 Stelle - Scarso)</option>
                                <option value="1">★☆☆☆☆ (1 Stella - Pessimo)</option>
                            </select>
                        </div>

                        <div class="form-group-field">
                            <label for="descrizioneInput">Commento / Esperienza:</label>
                            <textarea id="descrizioneInput" name="descrizione" rows="3" placeholder="Scrivi un commento sul comfort, lo stile e la qualità..." required class="review-textarea"></textarea>
                        </div>

                        <button type="submit" class="btn-submit-review">Invia Recensione</button>
                    </form>
                </div>
            </div>

            
            <div class="reviews-list-container">
                <% 
                    if (recensioni != null && !recensioni.isEmpty()) {
                        for (Recensione r : recensioni) {
                %>
                            <div class="single-review-card">
                                <div class="review-card-top">
                                    <span class="reviewer-email"><%= r.getUtenteEmail() %></span>
                                    <div class="rating-stars">
                                        <% 
                                            for (int s = 1; s <= 5; s++) {
                                                if (s <= r.getVoto()) {
                                        %>
                                                    <span class="star filled">★</span>
                                        <% 
                                                } else { 
                                        %>
                                                    <span class="star empty">☆</span>
                                        <% 
                                                }
                                            } 
                                        %>
                                    </div>
                                </div>
                                <p class="review-body-text"><%= r.getDescrizione() %></p>
                            </div>
                <% 
                        }
                    } else { 
                %>
                        <div class="no-reviews-box">
                            <p>Non ci sono ancora recensioni per questo occhiale. Sii il primo a lasciarne una!</p>
                        </div>
                <% 
                    } 
                %>
            </div>
        </div>

        <% 
            } else { 
        %>
            <div style="text-align: center; padding: 60px 0;">
                <h2 style="color: var(--rust); margin-bottom: 20px;">Prodotto Non Trovato</h2>
                <p style="color: rgba(43, 43, 43, 0.6); margin-bottom: 30px;">L'occhiale richiesto non esiste o non è disponibile.</p>
                <a href="catalogo" class="btn-main-action" style="display: inline-block; width: auto; padding: 12px 24px;">Vai al Catalogo</a>
            </div>
        <% 
            } 
        %>
    </div>

    <script>
        function changeMainImage(src, element) {
            document.getElementById('mainProductImg').src = src;
            document.querySelectorAll('.thumb-box').forEach(el => el.classList.remove('active'));
            element.classList.add('active');
        }
    </script>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>
