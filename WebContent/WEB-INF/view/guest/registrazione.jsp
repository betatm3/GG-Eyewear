<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrazione - GG Eyewear</title>
    
    
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
		   String erroreServlet = (String) request.getAttribute("errore");
		   boolean haErroreServlet = (erroreServlet != null && !erroreServlet.trim().isEmpty());
		%>
		
		<div id="js-error-banner" class="error-banner" style="<%= haErroreServlet ? "display: flex;" : "display: none;" %> align-items: center; justify-content: space-between;">
		    <span>⚠️</span>
		    <span id="js-error-text"><%= haErroreServlet ? erroreServlet : "" %></span>
		    <button type="button" style="text-align: right;" class="close-banner-btn" onclick="this.parentElement.style.display='none';" title="Chiudi banner" aria-label="Chiudi banner">✕</button>
		    
		</div>

        <form action="registrazione" method="POST">
            <div class="form-grid">
                
                
                <div class="form-group">
                    <label for="nome">Nome</label>
                    <input type="text" id="nome" name="nome" placeholder="Es. Mario" />
                </div>

                <div class="form-group">
                    <label for="cognome">Cognome</label>
                    <input type="text" id="cognome" name="cognome" placeholder="Es. Rossi" />
                </div>

                
                <div class="form-group full-width">
                    <label for="email">Indirizzo E-mail</label>
                    <input type="email" id="email" name="email" placeholder="mario.rossi@email.it" />
                </div>

                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Scegli una password" />
                </div>

                <div class="form-group">
                    <label for="confermaPassword">Conferma Password</label>
                    <input type="password" id="confermaPassword" name="confermaPassword" placeholder="Ripeti la password" />
                </div>

                
                <div class="form-group">
                    <label for="telefono">Numero di Telefono</label>
                    <input type="tel" id="telefono" name="telefono" placeholder="Es. 3331234567" maxlength="16"/>
                </div>

                <div class="form-group">
                    <label for="dataNascita">Data di Nascita</label>
                    <input type="date" id="dataNascita" name="dataNascita" />
                </div>

                
                <div class="form-group full-width">
                    <label for="indirizzo">Indirizzo di Spedizione predefinito</label>
                    <input type="text" id="indirizzo" name="indirizzo" placeholder="Es. Via Roma 12, 80100 Napoli" />
                </div>
            </div>

            <button type="submit" class="btn-submit">Registrati</button>
        </form>

        <div class="footer-links">
            Hai già un account? <a href="login">Accedi qui</a>
        </div>
    </div>
<%@ include file="../partials/footer.jsp" %>
<script src="${pageContext.request.contextPath}/scripts/registrazione.js"></script>
</body>
</html>
