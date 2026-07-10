<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Catalogo Occhiali</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .catalogo-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
            padding: 20px;
        }
        .card-occhiale {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 16px;
            width: 280px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .container-immagine {
            text-align: center;
            margin-bottom: 12px;
            height: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #fafafa;
            border-radius: 4px;
        }
        .img-occhiale {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }
        .marca-modello {
            margin: 0 0 8px 0;
            color: #222;
            font-size: 1.2em;
        }
        .info-tecniche {
            font-size: 0.9em;
            color: #666;
            margin: 4px 0;
        }
        .prezzo {
            font-weight: bold;
            color: #2c3e50;
            font-size: 1.2em;
            margin: 10px 0;
        }
        .sezione-disponibilita {
            border-top: 1px solid #eee;
            padding-top: 8px;
            margin-top: auto;
        }
        .titolo-disp {
            font-size: 0.85em;
            color: #888;
            text-transform: uppercase;
            margin-bottom: 6px;
        }
        .tag-disponibile {
            font-size: 0.85em;
            background-color: #e2e8f0;
            color: #4a5568;
            padding: 4px 8px;
            border-radius: 4px;
            display: inline-block;
            margin-right: 4px;
            margin-bottom: 4px;
        }
        .msg-vuoto {
            text-align: center;
            color: #777;
            font-size: 1.2em;
            margin-top: 50px;
        }
    </style>
</head>
<body>

    <h1>Il nostro Catalogo Occhiali</h1>

    <div class="catalogo-container">
        <%-- Verifichiamo se ci sono prodotti passati dalla Servlet --%>
        <c:choose>
            <c:when test="${not empty prodotti}">
                
                <%-- Ciclo principale sulla collezione degli occhiali --%>
                <c:forEach var="occhiale" items="${prodotti}">
                    <div class="card-occhiale">
                        
                        <div class="container-immagine">
                            <c:choose>
                                <c:when test="${not empty occhiale.immagine}">
                                    <%-- Conversione dinamica dei byte del BLOB in stringa Base64 per tag img --%>
                                    <% 
                                        model.Occhiale occ = (model.Occhiale) pageContext.getAttribute("occhiale");
                                        String base64Image = Base64.getEncoder().encodeToString(occ.getImmagine());
                                        pageContext.setAttribute("base64Img", base64Image);
                                    %>
                                    <img class="img-occhiale" src="data:image/jpeg;base64,${base64Img}" alt="Immagine Occhiale" />
                                </c:when>
                                <c:otherwise>
                                    <img class="img-occhiale" src="https://via.placeholder.com/200x150?text=No+Image" alt="Nessuna immagine" />
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <h3 class="marca-modello">ID Occhiale: #${occhiale.id}</h3>
                        <p class="info-tecniche"><strong>Tipologia:</strong> ${occhiale.tipo}</p>
                        
                        <c:if test="${not empty occhiale.versioneCorrente}">
                            <p class="info-tecniche"><strong>Genere:</strong> ${occhiale.versioneCorrente.genere}</p>
                            <p class="info-tecniche"><strong>Forma:</strong> ${occhiale.versioneCorrente.forma}</p>
                            <p class="info-tecniche"><strong>Materiale:</strong> ${occhiale.versioneCorrente.materiale}</p>
                            <p class="info-tecniche"><strong>Montatura:</strong> ${occhiale.versioneCorrente.montatura}</p>
                            <p class="info-tecniche"><strong>Taglia:</strong> ${occhiale.versioneCorrente.taglia}</p>
                            
                            <p class="prezzo">Prezzo: € ${occhiale.versioneCorrente.prezzo}</p>
                        </c:if>

                        <div class="sezione-disponibilita">
                            <div class="titolo-disp">Varianti &amp; Stock:</div>
                            <c:choose>
                                <c:when test="${not empty occhiale.disponibilita}">
                                    <c:forEach var="disp" items="${occhiale.disponibilita}">
                                        <span class="tag-disponibile">
                                            <strong>${disp.colore}:</strong> ${disp.quantita} pz
                                        </span>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #e53e3e; font-size: 0.9em;">Esaurito</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </div>
                </c:forEach>
                
            </c:when>
            <c:otherwise>
                <div class="msg-vuoto">
                    <p>Nessun occhiale disponibile al momento nel catalogo.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</body>
</html>