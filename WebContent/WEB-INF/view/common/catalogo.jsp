<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Base64" %>
<%@ page import="model.Occhiale" %>
<%@ page import="model.Disponibile" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Catalogo Occhiali</title>
  
</head>
<body>

    <h1>Il nostro Catalogo Occhiali</h1>

    <div class="catalogo-container">
        <% 
            // 1. Recuperiamo la collezione passata dalla Servlet tramite getAttribute
            Collection<Occhiale> prodotti = (Collection<Occhiale>) request.getAttribute("prodotti");
            
            // Sostituiamo <c:choose> / <c:when> con un classico if-else Java
            if (prodotti != null && !prodotti.isEmpty()) {
                
                // Sostituiamo <c:forEach> con un ciclo for-each Java
                for (Occhiale occhiale : prodotti) {
        %>
                    <div class="card-occhiale">
                        
                        <div class="container-immagine">
                            <% 
                                // Gestione Immagine BLOB con Scriptlet
                                if (occhiale.getImmagine() != null && occhiale.getImmagine().length > 0) {
                                    String base64Image = Base64.getEncoder().encodeToString(occhiale.getImmagine());
                            %>
                                    <img class="img-occhiale" src="data:image/jpeg;base64,<%= base64Image %>" alt="Immagine Occhiale" />
                            <% 
                                } else { 
                            %>
                                    <img class="img-occhiale" src="https://via.placeholder.com/200x150?text=No+Image" alt="Nessuna immagine" />
                            <% 
                                } 
                            %>
                        </div>

                        <h3 class="marca-modello">ID Occhiale: #<%= occhiale.getId() %></h3>
                        <p class="info-tecniche"><strong>Tipologia:</strong> <%= occhiale.getTipo() %></p>
                        
                        <% 
                            // Sostituiamo <c:if> controllando se la versione corrente non è null
                            if (occhiale.getVersioneCorrente() != null) { 
                        %>
                            <p class="info-tecniche"><strong>Genere:</strong> <%= occhiale.getVersioneCorrente().getGenere() %></p>
                            <p class="info-tecniche"><strong>Forma:</strong> <%= occhiale.getVersioneCorrente().getForma() %></p>
                            <p class="info-tecniche"><strong>Materiale:</strong> <%= occhiale.getVersioneCorrente().getMateriale() %></p>
                            <p class="info-tecniche"><strong>Montatura:</strong> <%= occhiale.getVersioneCorrente().getMontatura() %></p>
                            <p class="info-tecniche"><strong>Taglia:</strong> <%= occhiale.getVersioneCorrente().getTaglia() %></p>
                            
                            <p class="prezzo">Prezzo: € <%= occhiale.getVersioneCorrente().getPrezzo() %></p>
                        <% 
                            } 
                        %>

                        <div class="sezione-disponibilita">
                            <div class="titolo-disp">Varianti &amp; Stock:</div>
                            <% 
                                // Gestione disponibilità
                                if (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) {
                                    for (Disponibile disp : occhiale.getDisponibilita()) {
                            %>
                                        <span class="tag-disponibile">
                                            <strong><%= disp.getColore() %>:</strong> <%= disp.getQuantita() %> pz
                                        </span>
                            <% 
                                    }
                                } else { 
                            %>
                                    <span style="color: #e53e3e; font-size: 0.9em;">Esaurito</span>
                            <% 
                                } 
                            %>
                        </div>

                    </div>
        <% 
                } // Fine del ciclo for sugli occhiali
            } else { // Else dell'if iniziale (Catalogo vuoto)
        %>
                <div class="msg-vuoto">
                    <p>Nessun occhiale disponibile al momento nel catalogo.</p>
                </div>
        <% 
            } 
        %>
    </div>

</body>
</html>