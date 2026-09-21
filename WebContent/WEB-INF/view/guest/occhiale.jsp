<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%@ page import="model.Occhiale" %>
<%@ page import="model.Disponibile" %>
<%@ page import="model.Colore" %>
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
                String taglia = (versione != null && versione.getTaglia() != null) ? versione.getTaglia().getDescrizione() : "N/D";
                String materiale = (versione != null && versione.getMateriale() != null) ? versione.getMateriale() : "N/D";
                String genere = (versione != null && versione.getGenere() != null) ? versione.getGenere().name() : "N/D";
                String forma = (versione != null && versione.getForma() != null) ? versione.getForma().getDisplayName() : "N/D";
                String montatura = (versione != null && versione.getMontatura() != null) ? versione.getMontatura().name() : "N/D";
                
                ArrayList<String> listaImmagini = (occhiale != null) ? occhiale.getImmagini() : null;
                List<String> immaginiResolute = new ArrayList<>();
                
                if (listaImmagini != null && !listaImmagini.isEmpty()) {
				    for (String path : listaImmagini) {
				        if (path != null && !path.trim().isEmpty()) {
				            // Aggiungiamo il contextPath davanti al percorso salvato nel DB
				            immaginiResolute.add(request.getContextPath() + "/" + path.trim());
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

                
                <div class="details-grid-section">
				    <div class="detail-item">
				        <span class="detail-label">Taglia</span>
				        <span class="detail-value"><%= taglia %></span>
				    </div>
				    <div class="detail-item">
				        <span class="detail-label">Genere</span>
				        <span class="detail-value"><%= genere %></span>
				    </div>
				    <div class="detail-item">
				        <span class="detail-label">Materiale</span>
				        <span class="detail-value"><%= materiale %></span>
				    </div>
				    <div class="detail-item">
				        <span class="detail-label">Forma</span>
				        <span class="detail-value"><%= forma %></span>
				    </div>
				    <div class="detail-item full-width">
				        <span class="detail-label">Montatura</span>
				        <span class="detail-value"><%= montatura %></span>
				    </div>
				</div>

               
                <form action="carrello" method="POST" class="purchase-form">
                    <input type="hidden" name="action" value="aggiungi" />
                    <input type="hidden" name="idOcchiale" value="<%= occhiale.getId() %>" />
                    <input type="hidden" name="codiceVersioneOcchiale" value="<%= versione != null ? versione.getCodice() : 0 %>" />
					
					<% 
                    	String primoNomeColore = "Nessuna disponibilità";
                        if (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) {
                            Disponibile d1 = occhiale.getDisponibilita().iterator().next();
                            if (d1.getColore() != null && d1.getColore().getNome() != null) {
                                primoNomeColore = d1.getColore().getNome();
                            }
                        }
                    %>
                    <div class="color-selection-header">
                        <span class="field-title">Seleziona il colore: <strong id="selectedColorName"><%= primoNomeColore %></strong></span>
                        <% 
                        	if (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) {
                        %>
  							<span class="stock-badge in-stock">in magazzino</span>
                        <%
                        	}
                    	%>
                    </div>

                    <div class="color-swatches-container">
                        <% 
                            if (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) {
                                boolean first = true;
                                for (Disponibile disp : occhiale.getDisponibilita()) {
                                	Colore c = disp.getColore();
                                	if(c == null)	continue;
                                	
                                    String codiceColore = c.getCodice();
                                    String nomeColore = c.getNome() != null ? c.getNome() : codiceColore;
                                    boolean inStock = disp.getQuantita() > 0;
                                    
                                    String hexColor = (c.getHex() != null && !c.getHex().isBlank()) ? c.getHex() : "#111111";
                                    String cNameLower = nomeColore.toLowerCase();
                        %>
                                    <label class="swatch-label <%= inStock ? "" : "disabled" %>">
                                        <input type="radio" name="coloreScelto" value="<%= codiceColore %>" 
                                               <%= inStock && first ? "checked" : "" %> 
                                               <%= inStock ? "" : "disabled" %>
                                               onchange="updateSelectedColorName('<%= nomeColore %>')" />
                                        <span class="swatch-circle-btn" style="background-color: <%= hexColor %>;" title="<%= nomeColore %>"></span>
                                    </label>
                        <% 
                                    if (inStock) first = false;
                                }
                            } else { 
                        %>
                        <span class="color-not-found">
							Nessun colore disponibile per questo modello.
						</span>
                        <% 
                            } 
                        %>
                    </div>

                    <% 
                    	if (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) {
                    %>
		                    <button type="submit" class="btn-main-action">
		                        Aggiungi al Carrello
		                    </button>
                    <%
                     	} 
                     %>
                        
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
                    <% 
                    	Utente uLog = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;
                        if (uLog != null) {
                    %>
						<form action="${pageContext.request.contextPath}/common/recensione" method="POST" class="review-form">
	                        <input type="hidden" name="occhialeId" value="<%= occhiale.getId() %>" />
	                        
	                        <div class="form-group-field">
	                            <label for="votoSelect">Valutazione (Stelle):</label>
	                            <select id="votoSelect" name="voto" class="review-select">
	                                <option value="5">★★★★★ (5 Stelle - Eccellente)</option>
	                                <option value="4">★★★★☆ (4 Stelle - Molto Buono)</option>
	                                <option value="3">★★★☆☆ (3 Stelle - Medio)</option>
	                                <option value="2">★★☆☆☆ (2 Stelle - Scarso)</option>
	                                <option value="1">★☆☆☆☆ (1 Stella - Pessimo)</option>
	                            </select>
	                        </div>
	
	                        <div class="form-group-field">
	                            <label for="descrizioneInput">Commento / Esperienza:</label>
	                            <textarea id="descrizioneInput" name="descrizione" rows="3" placeholder="Scrivi un commento sul comfort, lo stile e la qualità..." class="review-textarea"></textarea>
	                        </div>
	
	                        <button type="submit" class="btn-submit-review">Invia Recensione</button>
	                    </form>
	                <% } else { %>
						<div class="review-login-prompt">
				            <p>Vuoi lasciare una recensione per questo prodotto?</p>
				            <a href="<%= request.getContextPath() %>/login" class="btn-submit-review">
				                Accedi per recensire
				            </a>
				        </div>
				    <% } %>
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
            <div class="product-not-found-container">
			    <h2 class="not-found-title">Prodotto Non Trovato</h2>
			    <p class="not-found-message">L'occhiale richiesto non esiste o non è disponibile.</p>
			    <a href="catalogo" class="btn-not-found">Vai al Catalogo</a>
			</div>
        <% 
            } 
        %>
    </div>

<%@ include file="../partials/footer.jsp" %>
<script src="${pageContext.request.contextPath}/scripts/occhiale.js"></script>
<script src="${pageContext.request.contextPath}/scripts/recensione.js"></script>
</body>
</html>
