<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accedi - GG Eyewear</title>
    
    <!-- Font Premium da Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/login.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
    <div class="login-container">
        <h2>Bentornato</h2>
        <div class="subtitle">Accedi per gestire il tuo profilo e i tuoi acquisti</div>

        <% 
            String errore = (String) request.getAttribute("errore");
            if (errore != null) {
        %>
            <div class="error-banner">
                <span>⚠️</span> <%= errore %>
            </div>
        <% 
            } 
        %>

        <form action="login" method="POST">
            <div class="form-group">
                <label for="email">Indirizzo E-mail</label>
                <input type="email" id="email" name="email" required placeholder="Inserisci la tua email" />
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Inserisci la tua password" />
            </div>

            <button type="submit" class="btn-submit">Accedi</button>
        </form>

        <div class="footer-links">
            Non hai ancora un account? <a href="registrazione">Registrati ora</a>
        </div>
    </div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
