<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrazione - GG Eyewear</title>
    
    <!-- Font Premium da Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/registrazione.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
    <div class="reg-container">
        <h2>Crea un Account</h2>
        <div class="subtitle">Registrati per ordinare online e salvare il tuo indirizzo</div>

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

        <form action="registrazione" method="POST">
            <div class="form-grid">
                
                <!-- Nome e Cognome -->
                <div class="form-group">
                    <label for="nome">Nome</label>
                    <input type="text" id="nome" name="nome" required placeholder="Es. Mario" />
                </div>

                <div class="form-group">
                    <label for="cognome">Cognome</label>
                    <input type="text" id="cognome" name="cognome" required placeholder="Es. Rossi" />
                </div>

                <!-- E-mail -->
                <div class="form-group full-width">
                    <label for="email">Indirizzo E-mail</label>
                    <input type="email" id="email" name="email" required placeholder="mario.rossi@email.it" />
                </div>

                <!-- Password e Conferma Password -->
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required placeholder="Scegli una password" />
                </div>

                <div class="form-group">
                    <label for="confermaPassword">Conferma Password</label>
                    <input type="password" id="confermaPassword" name="confermaPassword" required placeholder="Ripeti la password" />
                </div>

                <!-- Telefono e Data di Nascita -->
                <div class="form-group">
                    <label for="telefono">Numero di Telefono</label>
                    <input type="tel" id="telefono" name="telefono" required placeholder="Es. 3331234567" />
                </div>

                <div class="form-group">
                    <label for="dataNascita">Data di Nascita</label>
                    <input type="date" id="dataNascita" name="dataNascita" required />
                </div>

                <!-- Indirizzo di Spedizione Completo -->
                <div class="form-group full-width">
                    <label for="indirizzo">Indirizzo di Spedizione predefinito</label>
                    <input type="text" id="indirizzo" name="indirizzo" required placeholder="Es. Via Roma 12, 80100 Napoli" />
                </div>
            </div>

            <button type="submit" class="btn-submit">Registrati</button>
        </form>

        <div class="footer-links">
            Hai già un account? <a href="login">Accedi qui</a>
        </div>
    </div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
