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
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/checkout.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
    <div class="container">

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
                    <form action="/common/checkout" method="POST">
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
                                         <% 
                                            String primaImgCheck = (item.getOcchiale() != null) ? item.getOcchiale().getImmagine(0) : null;
                                            String imgSrcCheck = null;
                                            if (primaImgCheck != null && !primaImgCheck.trim().isEmpty()) {
                                                String trimmed = primaImgCheck.trim();
                                                if (trimmed.startsWith("data:") || trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
                                                    imgSrcCheck = trimmed;
                                                } else if (trimmed.startsWith("/") || trimmed.startsWith("images/")) {
                                                    imgSrcCheck = request.getContextPath() + (trimmed.startsWith("/") ? "" : "/") + trimmed;
                                                } else {
                                                    imgSrcCheck = "data:image/jpeg;base64," + trimmed;
                                                }
                                            }
                                            if (imgSrcCheck != null) { 
                                         %>
                                             <img class="item-img" src="<%= imgSrcCheck %>" alt="<%= modello %>" />
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
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
