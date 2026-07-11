<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Base64" %>
<%@ page import="model.Occhiale" %>
<%@ page import="model.Disponibile" %>
<%@ page import="model.VersioneOcchiale" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogo Occhiali - GG Eyewear</title>
    
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
            padding: 50px 20px;
        }

        h1 {
            text-align: center;
            font-size: 2.8rem;
            font-weight: 800;
            margin-bottom: 50px;
            background: linear-gradient(to right, #ffffff, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -0.02em;
        }

        .catalogo-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
            animation: fadeIn 0.8s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card-occhiale {
            background: var(--glass-bg);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 24px;
            box-shadow: var(--shadow-primary);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.4s cubic-bezier(0.25, 1, 0.5, 1);
            position: relative;
            overflow: hidden;
        }

        .card-occhiale:hover {
            transform: translateY(-8px);
            border-color: rgba(255, 255, 255, 0.15);
            box-shadow: 0 12px 40px 0 rgba(129, 140, 248, 0.15);
        }

        .container-immagine {
            width: 100%;
            height: 180px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.03);
            transition: transform 0.4s ease;
        }

        .card-occhiale:hover .container-immagine {
            transform: scale(1.02);
        }

        .img-occhiale {
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
            transition: transform 0.4s ease;
        }

        .marca-modello {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 12px;
            color: #ffffff;
        }

        .info-tecniche {
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin-bottom: 8px;
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid rgba(255, 255, 255, 0.03);
            padding-bottom: 6px;
        }

        .info-tecniche strong {
            color: var(--text-primary);
        }

        .prezzo {
            font-size: 1.5rem;
            font-weight: 700;
            color: #34d399;
            margin-top: 15px;
            margin-bottom: 20px;
        }

        .sezione-disponibilita {
            margin-bottom: 20px;
        }

        .titolo-disp {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 10px;
        }

        .variants-wrap {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .tag-disponibile {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--glass-border);
            border-radius: 8px;
            padding: 4px 8px;
            font-size: 0.75rem;
            color: var(--text-primary);
        }

        .tag-esaurito {
            color: #f87171;
            font-size: 0.8rem;
            font-weight: 600;
        }

        /* Bottone Dettagli */
        .btn-dettaglio {
            background: var(--accent-gradient);
            color: #ffffff;
            text-align: center;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            padding: 12px;
            border-radius: 12px;
            display: block;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px var(--accent-glow);
        }

        .btn-dettaglio:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(129, 140, 248, 0.5);
            filter: brightness(1.1);
        }

        .msg-vuoto {
            grid-column: 1 / -1;
            text-align: center;
            padding: 60px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            color: var(--text-secondary);
            font-size: 1.1rem;
        }
    </style>
</head>
<body>

    <h1>Il nostro Catalogo Occhiali</h1>

    <div class="catalogo-container">
        <% 
            // 1. Recuperiamo la collezione passata dalla Servlet tramite getAttribute
            Collection<Occhiale> prodotti = (Collection<Occhiale>) request.getAttribute("prodotti");
            
            if (prodotti != null && !prodotti.isEmpty()) {
                for (Occhiale occhiale : prodotti) {
                    VersioneOcchiale versione = occhiale.getVersioneCorrente();
                    String marca = (versione != null && versione.getMarca() != null) ? versione.getMarca() : "Brand";
                    String modello = (versione != null && versione.getModello() != null) ? versione.getModello() : "Modello #" + occhiale.getId();
        %>
                    <div class="card-occhiale">
                        <div>
                            <div class="container-immagine">
                                <% 
                                    // Gestione Immagine BLOB con Scriptlet
                                    if (occhiale.getImmagine() != null && occhiale.getImmagine().length > 0) {
                                        String base64Image = Base64.getEncoder().encodeToString(occhiale.getImmagine());
                                Long.toString(occhiale.getImmagine().length);
                                %>
                                        <img class="img-occhiale" src="data:image/jpeg;base64,<%= base64Image %>" alt="Foto <%= modello %>" />
                                <% 
                                    } else { 
                                %>
                                        <img class="img-occhiale" src="https://via.placeholder.com/200x150?text=No+Image" alt="Nessuna immagine" />
                                <% 
                                    } 
                                %>
                            </div>

                            <h3 class="marca-modello"><%= marca %> - <%= modello %></h3>
                            
                            <p class="info-tecniche"><strong>Tipologia:</strong> <span><%= occhiale.getTipo() %></span></p>
                            
                            <% 
                                if (versione != null) { 
                            %>
                                <p class="info-tecniche"><strong>Genere:</strong> <span><%= versione.getGenere() %></span></p>
                                <p class="info-tecniche"><strong>Forma:</strong> <span><%= versione.getForma() != null ? versione.getForma() : "N/D" %></span></p>
                                <p class="info-tecniche"><strong>Taglia:</strong> <span><%= versione.getTaglia() != null ? versione.getTaglia() : "N/D" %></span></p>
                                
                                <p class="prezzo">€ <%= String.format("%.2f", versione.getPrezzo()) %></p>
                            <% 
                                } else {
                            %>
                                <p class="prezzo">Prezzo N/D</p>
                            <%
                                } 
                            %>

                            <div class="sezione-disponibilita">
                                <div class="titolo-disp">Colori disponibili:</div>
                                <div class="variants-wrap">
                                    <% 
                                        if (occhiale.getDisponibilita() != null && !occhiale.getDisponibilita().isEmpty()) {
                                            for (Disponibile disp : occhiale.getDisponibilita()) {
                                                String nomeColore = disp.getColore().getNome() != null ? disp.getColore().getNome() : disp.getColore().getCodice();
                                    %>
                                                <span class="tag-disponibile">
                                                    <%= nomeColore %>
                                                </span>
                                    <% 
                                            }
                                        } else { 
                                    %>
                                            <span class="tag-esaurito">Esaurito</span>
                                    <% 
                                        } 
                                    %>
                                </div>
                            </div>
                        </div>

                        <!-- Bottone per visualizzare il dettaglio -->
                        <a href="dettaglio?id=<%= occhiale.getId() %>" class="btn-dettaglio">Vedi Dettagli</a>
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