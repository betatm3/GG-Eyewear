<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accesso Negato - GG Eyewear</title>
    
    <!-- Font Premium da Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #311042 100%);
            --glass-bg: rgba(255, 255, 255, 0.03);
            --glass-border: rgba(255, 255, 255, 0.07);
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --accent-gradient: linear-gradient(135deg, #f43f5e 0%, #fb7185 100%); /* Colore rosso/rosa per indicare errore */
            --accent-glow: rgba(244, 63, 94, 0.2);
            --shadow-primary: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: var(--bg-gradient);
            background-attachment: fixed;
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .error-card {
            width: 100%;
            max-width: 500px;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            box-shadow: var(--shadow-primary);
            padding: 40px;
            text-align: center;
            animation: scaleUp 0.5s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes scaleUp {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        .error-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 25px;
            background: rgba(244, 63, 94, 0.1);
            border: 1px solid rgba(244, 63, 94, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #f43f5e;
            box-shadow: 0 0 20px var(--accent-glow);
        }

        .error-icon svg {
            width: 36px;
            height: 36px;
            fill: currentColor;
        }

        h1 {
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 12px;
            background: linear-gradient(to right, #ffffff, #fb7185);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .error-message {
            font-size: 1rem;
            color: var(--text-secondary);
            line-height: 1.6;
            margin-bottom: 35px;
        }

        .actions {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .btn-home {
            background: linear-gradient(135deg, #818cf8 0%, #c084fc 100%);
            border: none;
            color: #ffffff;
            font-family: inherit;
            font-size: 0.95rem;
            font-weight: 700;
            padding: 14px 20px;
            border-radius: 12px;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(129, 140, 248, 0.25);
        }

        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(129, 140, 248, 0.35);
        }

        .btn-login {
            background: transparent;
            border: 1px solid var(--glass-border);
            color: var(--text-primary);
            font-family: inherit;
            font-size: 0.95rem;
            font-weight: 600;
            padding: 14px 20px;
            border-radius: 12px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            background: rgba(255, 255, 255, 0.03);
            border-color: rgba(255, 255, 255, 0.15);
        }
    </style>
</head>
<body>

<div class="error-card">
    <div class="error-icon">
        <!-- Icona Lucchetto Chiuso Premium -->
        <svg viewBox="0 0 24 24">
            <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/>
        </svg>
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

</body>
</html>
