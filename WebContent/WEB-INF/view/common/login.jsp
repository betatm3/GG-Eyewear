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
    
    <style>
        :root {
            --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #311042 100%);
            --glass-bg: rgba(255, 255, 255, 0.03);
            --glass-border: rgba(255, 255, 255, 0.07);
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --accent-gradient: linear-gradient(135deg, #818cf8 0%, #c084fc 100%);
            --accent-glow: rgba(129, 140, 248, 0.3);
            --danger-color: #f87171;
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

        .login-container {
            width: 100%;
            max-width: 450px;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            box-shadow: var(--shadow-primary);
            padding: 40px;
            animation: fadeIn 0.8s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 8px;
            text-align: center;
            background: linear-gradient(to right, #ffffff, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .subtitle {
            font-size: 0.9rem;
            color: var(--text-secondary);
            text-align: center;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 24px;
            position: relative;
        }

        label {
            display: block;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        input {
            width: 100%;
            padding: 14px 16px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            color: var(--text-primary);
            font-family: inherit;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }

        input:focus {
            outline: none;
            border-color: #818cf8;
            box-shadow: 0 0 10px rgba(129, 140, 248, 0.3);
            background: rgba(255, 255, 255, 0.05);
        }

        /* Bottone submit */
        .btn-submit {
            background: var(--accent-gradient);
            color: #ffffff;
            border: none;
            width: 100%;
            padding: 14px;
            font-size: 1rem;
            font-weight: 700;
            border-radius: 12px;
            cursor: pointer;
            margin-top: 10px;
            box-shadow: 0 4px 15px var(--accent-glow);
            transition: all 0.3s ease;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(129, 140, 248, 0.5);
            filter: brightness(1.1);
        }

        /* Banner errori */
        .error-banner {
            background: rgba(248, 113, 113, 0.1);
            border: 1px solid rgba(248, 113, 113, 0.2);
            color: var(--danger-color);
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-weight: 500;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Footer links */
        .footer-links {
            margin-top: 30px;
            text-align: center;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }

        .footer-links a {
            color: #818cf8;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: #c084fc;
            text-decoration: underline;
        }
    </style>
</head>
<body>

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

</body>
</html>
