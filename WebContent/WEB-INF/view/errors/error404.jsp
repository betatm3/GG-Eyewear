<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pagina Non Trovata (404) - GG Eyewear</title>
    
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&family=Fraunces:wght@600&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/comune.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/errori.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>

<div class="error-card">
    <div class="error-code">404</div>
    <h1>Pagina Non Trovata</h1>
    <div class="error-message">
        Ci dispiace, la pagina che stai cercando non esiste, è stata rimossa o l'indirizzo inserito non è corretto.
    </div>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/home" class="btn-home">Torna alla Home</a>
        <a href="${pageContext.request.contextPath}/catalogo" class="btn-secondary">Esplora il Catalogo</a>
    </div>
</div>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>
