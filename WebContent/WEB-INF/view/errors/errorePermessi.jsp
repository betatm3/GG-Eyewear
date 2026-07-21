<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accesso Negato - GG Eyewear</title>
    
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/errori.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
<div class="error-card">
    <div class="error-icon">
       
        <img src="${pageContext.request.contextPath}/images/icons8-lock-24.png" alt="Accesso Negato" style="width: 48px; height: 48px; object-fit: contain;" />
    </div>

    <h1>Accesso Negato</h1>
    
    <div class="error-message">
        <% 
            String msg = (String) request.getAttribute("messaggioErrore");
            if (msg == null || msg.trim().isEmpty()) {
                msg = "Non hai le autorizzazioni necessarie per visualizzare questa pagina.";
            }
        %>
        <%= msg %>
    </div>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/home" class="btn-home">Torna alla Home</a>
        <a href="${pageContext.request.contextPath}/login" class="btn-login">Effettua il Login</a>
    </div>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
