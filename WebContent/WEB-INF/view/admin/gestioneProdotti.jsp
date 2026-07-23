<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Base64" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="model.*" %>
<%@ page import="dao.*" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestione Prodotti - Area Amministratore</title>
    
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/gestioneProdotti.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>
<%
   
    DataSource ds = null;
    try {
        InitialContext ctx = new InitialContext();
        ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ecommerce_db");
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (ds != null) {
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);
        ColoreDAOImpl coloreDAO = new ColoreDAOImpl(ds);
        DisponibileDAOImpl disponibileDAO = new DisponibileDAOImpl(ds);

        Collection<VersioneOcchiale> versioniCorrenti = versioneDAO.doRetrieveByCorrente(true);
        Collection<Colore> tuttiColori = coloreDAO.doRetrieveAll(null);

        
        String editIdStr = request.getParameter("editId");
        String editCodiceStr = request.getParameter("editCodice");
        VersioneOcchiale versioneInModifica = null;
        if (editIdStr != null && editCodiceStr != null) {
            try {
                int editId = Integer.parseInt(editIdStr);
                int editCodice = Integer.parseInt(editCodiceStr);
                versioneInModifica = versioneDAO.doRetrieveByKey(editCodice, editId);
            } catch (Exception e) {
                
            }
        }

        String manageColorsIdStr = request.getParameter("manageColorsId");
        Occhiale occhialeColori = null;
        Collection<Disponibile> coloriAssociati = null;
        if (manageColorsIdStr != null) {
            try {
                int manageColorsId = Integer.parseInt(manageColorsIdStr);
                occhialeColori = occhialeDAO.doRetrieveByKey(manageColorsId);
                coloriAssociati = disponibileDAO.doRetrieveByOcchiale(manageColorsId);
            } catch (Exception e) {
                
            }
        }
%>

<div class="container">
    
    
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-back">
        <img src="${pageContext.request.contextPath}/images/icons8-home-24.png" alt="Torna" style="width: 16px; height: 16px; margin-right: 6px; vertical-align: middle;" />
        Torna alla Dashboard Admin
    </a>

    <div>
        <h1>Gestione Catalogo Prodotti</h1>
        <div class="subtitle">Visualizza, aggiungi o modifica i modelli e regola le scorte di magazzino</div>
    </div>

    <div class="main-layout">
        
        
        <div class="card">
            <div class="card-title">
                <span>🕶️</span> Prodotti in Catalogo
            </div>
            
            <div class="prod-table-container">
                <table class="prod-table">
                    <thead>
                        <tr>
                            <th class="prod-th" style="width: 70px;">Foto</th>
                            <th class="prod-th">Marca / Modello</th>
                            <th class="prod-th" style="width: 100px;">Prezzo</th>
                            <th class="prod-th" style="width: 120px;">Tipo / Genere</th>
                            <th class="prod-th" style="width: 80px; text-align: center;">Stato</th>
                            <th class="prod-th" style="width: 180px;">Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (versioniCorrenti != null && !versioniCorrenti.isEmpty()) {
                                for (VersioneOcchiale v : versioniCorrenti) {
                                    Occhiale occ = v.getOcchiale();
                                    boolean attivo = occ != null && occ.isAttivo();
                        %>
                                    <tr class="prod-tr">
                                        <td class="prod-td">
                                            <div class="prod-img-container">
                                                 <% 
                                                    String primaImgProd = (occ != null) ? occ.getImmagine(0) : null;
                                                    String imgSrcProd = null;
                                                    if (primaImgProd != null && !primaImgProd.trim().isEmpty()) {
                                                        String trimmed = primaImgProd.trim();
                                                        if (trimmed.startsWith("data:") || trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
                                                            imgSrcProd = trimmed;
                                                        } else if (trimmed.startsWith("/") || trimmed.startsWith("images/") || trimmed.startsWith("img/")) {
                                                        	String cleanPath = trimmed.replace("img/", "")
                                                                    .replace("images/occhiali/", "")
                                                                    .replace("images/", "");
                                          					if (cleanPath.startsWith("/")) {
                                              					cleanPath = cleanPath.substring(1);
                                          					}
                                          					imgSrcProd= request.getContextPath() + "/images/occhiali/" + cleanPath;
                                                        } else {
                                                            imgSrcProd = "data:image/jpeg;base64," + trimmed;
                                                        }
                                                    }
                                                    if (imgSrcProd != null) { 
                                                 %>
                                                     <img class="prod-img" src="<%= imgSrcProd %>" alt="<%= v.getModello() %>" />
                                                 <% } else { %>
                                                     <img class="prod-img" src="https://via.placeholder.com/60x45?text=No" alt="No Image" />
                                                 <% } %>
                                            </div>
                                        </td>
                                        <td class="prod-td">
                                            <div style="font-weight: 700; color: #000000;"><%= v.getMarca() %></div>
                                            <div style="font-size: 0.8rem; color: var(--text-secondary);"><%= v.getModello() %> (ID: <%= occ.getId() %>)</div>
                                        </td>
                                        <td class="prod-td" style="font-weight: 700;">
                                            € <%= String.format("%.2f", v.getPrezzo()) %>
                                        </td>
                                        <td class="prod-td">
                                            <div style="font-weight: 600;"><%= occ.getTipo() != null ? occ.getTipo().name().replace("_", " ") : "N/D" %></div>
                                            <div style="font-size: 0.75rem; color: var(--text-secondary); text-transform: uppercase;"><%= v.getGenere() %></div>
                                        </td>
                                        <td class="prod-td" style="text-align: center;">
                                            <span class="status-badge <%= attivo ? "active" : "inactive" %>">
                                                <%= attivo ? "Attivo" : "Disattivato" %>
                                            </span>
                                        </td>
                                        <td class="prod-td">
                                            <div class="actions-group">
                                                <a href="GestioneProdotti?editId=<%= occ.getId() %>&editCodice=<%= v.getCodice() %>" class="btn-action edit" title="Modifica caratteristiche">✏️ Modifica</a>
                                                <a href="GestioneProdotti?manageColorsId=<%= occ.getId() %>" class="btn-action color" title="Gestisci quantità colori">🎨 Colori</a>
                                                <% if (attivo) { %>
                                                    <a href="GestioneProdotti?action=delete&id=<%= occ.getId() %>" class="btn-action delete" onclick="return confirm('Sicuro di voler disattivare questo prodotto dal catalogo pubblico?');" title="Disattiva prodotto">❌</a>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="6" class="prod-td" style="text-align: center; color: var(--text-secondary); padding: 30px;">
                                    Nessun prodotto presente nel database.
                                </td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- AREA OPERAZIONI -->
        <div class="card" id="form-container">
            
            <% if (versioneInModifica != null) { %>
                <!-- SEZIONE 3: Modifica Caratteristiche -->
                <div class="card-title">
                    <span>✏️</span> Modifica Caratteristiche
                </div>
                
                <form action="<%= request.getContextPath() %>/admin/GestioneProdotti?action=updatecaratteristiche" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="idOcchiale" value="<%= versioneInModifica.getOcchiale().getId() %>" />
                    <input type="hidden" name="codiceVersione" value="<%= versioneInModifica.getCodice() %>" />
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="edit_marca">Marca</label>
                            <input type="text" id="edit_marca" name="marca" required value="<%= versioneInModifica.getMarca() %>" />
                        </div>
                        <div class="form-group">
                            <label for="edit_modello">Modello</label>
                            <input type="text" id="edit_modello" name="modello" required value="<%= versioneInModifica.getModello() %>" />
                        </div>
                        <div class="form-group">
                            <label for="edit_prezzo">Prezzo (€)</label>
                            <input type="number" id="edit_prezzo" name="prezzo" step="0.01" required value="<%= versioneInModifica.getPrezzo() %>" />
                        </div>
                        <div class="form-group">
                            <label for="edit_tipologia">Tipologia</label>
                            <select id="edit_tipologia" name="tipologia">
                                <% for (Tipologia t : Tipologia.values()) { %>
                                    <option value="<%= t.name() %>" <%= versioneInModifica.getOcchiale().getTipo() == t ? "selected" : "" %>><%= t.name().replace("_", " ") %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="edit_genere">Genere</label>
                            <select id="edit_genere" name="genere">
                                <% for (Genere g : Genere.values()) { %>
                                    <option value="<%= g.name() %>" <%= versioneInModifica.getGenere() == g ? "selected" : "" %>><%= g.name() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="edit_montatura">Montatura</label>
                            <select id="edit_montatura" name="montatura">
                                <% for (Montatura m : Montatura.values()) { %>
                                    <option value="<%= m.name() %>" <%= versioneInModifica.getMontatura() == m ? "selected" : "" %>><%= m.name() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="edit_forma">Forma Lenti</label>
                            <input type="text" id="edit_forma" name="forma" required value="<%= versioneInModifica.getForma() %>" />
                        </div>
                        <div class="form-group">
                            <label for="edit_taglia">Taglia</label>
                            <input type="text" id="edit_taglia" name="taglia" required value="<%= versioneInModifica.getTaglia() %>" />
                        </div>
                        <div class="form-group">
                            <label for="edit_materiale">Materiale</label>
                            <input type="text" id="edit_materiale" name="materiale" required value="<%= versioneInModifica.getMateriale() %>" />
                        </div>
                        <% if (!versioneInModifica.getOcchiale().isAttivo()) { %>
                            <div class="form-group">
                                <label for="edit_attivo">Stato Prodotto</label>
                                <select id="edit_attivo" name="attivo">
                                    <option value="false" selected>Disattivato</option>
                                    <option value="true">Attiva Prodotto (Rendi visibile)</option>
                                </select>
                            </div>
                        <% } %>
                        <div class="form-group full-width">
                            <label for="edit_immagine">Nuova Immagine (Lascia vuoto per non cambiare)</label>
                            <input type="file" id="edit_immagine" name="immagine" accept="image/*" />
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-submit">Salva Modifiche</button>
                    <a href="<%= request.getContextPath() %>/admin/GestioneProdotti" class="btn-cancel">Annulla Modifica</a>
                </form>

            <% } else if (occhialeColori != null) { %>
                
                <div class="card-title">
                    <span>🎨</span> Gestione Colori & Scorte
                </div>
                
                <div style="margin-bottom: 20px; font-size: 0.95rem; color: var(--text-secondary);">
                    Stai gestendo le varianti di colore del prodotto: <strong style="color: #ffffff;">ID <%= occhialeColori.getId() %></strong>
                </div>

                
                <div class="color-manager-list">
                    <%
                        if (coloriAssociati != null && !coloriAssociati.isEmpty()) {
                            for (Disponibile disp : coloriAssociati) {
                                
                                Colore cDettaglio = coloreDAO.doRetrieveByKey(disp.getColore().getCodice());
                                String nomeC = cDettaglio != null ? cDettaglio.getNome() : disp.getColore().getCodice();
                    %>
                                <div class="color-manager-item">
                                    <div class="color-manager-name">
                                        🎨 <%= nomeC %> <span style="font-size: 0.8rem; color: var(--text-secondary);">(<%= disp.getColore().getCodice() %>)</span>
                                    </div>
                                    
                                    <div class="color-update-form">
                                        
                                        <form action="<%= request.getContextPath() %>/admin/GestioneProdotti?action=updatecolori&subAction=updatequantity" method="POST" style="display: flex; gap: 6px;">
                                            <input type="hidden" name="idOcchiale" value="<%= occhialeColori.getId() %>" />
                                            <input type="hidden" name="codiceColore" value="<%= disp.getColore().getCodice() %>" />
                                            <input type="number" name="quantita" value="<%= disp.getQuantita() %>" min="0" required />
                                            <button type="submit" class="btn-mini save">Aggiorna</button>
                                        </form>

                                        
                                        <a href="<%= request.getContextPath() %>/admin/GestioneProdotti?action=updatecolori&subAction=removecolor&idOcchiale=<%= occhialeColori.getId() %>&codiceColore=<%= disp.getColore().getCodice() %>" 
                                           class="btn-mini delete" 
                                           onclick="return confirm('Sicuro di voler rimuovere questa variante colore? Verrà azzerato il magazzino per questa opzione.');">
                                            Rimuovi
                                        </a>
                                    </div>
                                </div>
                    <%
                            }
                        } else {
                    %>
                        <div style="text-align: center; color: var(--text-secondary); padding: 15px;">
                            Nessuna variante colore associata a questo modello.
                        </div>
                    <%
                        }
                    %>
                </div>

               
                <div style="border-top: 1px solid var(--glass-border); padding-top: 20px; margin-top: 20px;">
                    <div style="font-weight: 700; font-size: 1rem; margin-bottom: 15px; color: #ffffff;">Associa Nuova Variante Colore</div>
                    
                    <form action="<%= request.getContextPath() %>/admin/GestioneProdotti?action=updatecolori&subAction=addcolor" method="POST">
                        <input type="hidden" name="idOcchiale" value="<%= occhialeColori.getId() %>" />
                        
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="nuovo_colore">Colore</label>
                                <select id="nuovo_colore" name="codiceColore" required>
                                    <option value="">Seleziona Colore...</option>
                                    <%
                                        if (tuttiColori != null) {
                                            for (Colore col : tuttiColori) {
                                    %>
                                                <option value="<%= col.getCodice() %>"><%= col.getNome() %> (<%= col.getCodice() %>)</option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="nuova_quantita">Quantità Iniziale</label>
                                <input type="number" id="nuova_quantita" name="quantita" min="0" required value="10" />
                            </div>
                        </div>
                        
                        <button type="submit" class="btn-submit">Associa Colore</button>
                        <a href="<%= request.getContextPath() %>/admin/GestioneProdotti" class="btn-cancel">Chiudi Pannello Colori</a>
                    </form>
                </div>

            <% } else { %>
               
                <div class="card-title">
                    <span>➕</span> Aggiungi Nuovo Occhiale
                </div>
                
                <form action="<%= request.getContextPath() %>/admin/GestioneProdotti?action=add" method="POST" enctype="multipart/form-data">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="marca">Marca</label>
                            <input type="text" id="marca" name="marca" required placeholder="Es. Ray-Ban" />
                        </div>
                        <div class="form-group">
                            <label for="modello">Modello</label>
                            <input type="text" id="modello" name="modello" required placeholder="Es. Aviator Classic" />
                        </div>
                        <div class="form-group">
                            <label for="prezzo">Prezzo (€)</label>
                            <input type="number" id="prezzo" name="prezzo" step="0.01" required placeholder="Es. 129.90" />
                        </div>
                        <div class="form-group">
                            <label for="tipologia">Tipologia</label>
                            <select id="tipologia" name="tipologia">
                                <% for (Tipologia t : Tipologia.values()) { %>
                                    <option value="<%= t.name() %>"><%= t.name().replace("_", " ") %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="genere">Genere</label>
                            <select id="genere" name="genere">
                                <% for (Genere g : Genere.values()) { %>
                                    <option value="<%= g.name() %>"><%= g.name() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="montatura">Montatura</label>
                            <select id="montatura" name="montatura">
                                <% for (Montatura m : Montatura.values()) { %>
                                    <option value="<%= m.name() %>"><%= m.name() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="forma">Forma Lenti</label>
                            <input type="text" id="forma" name="forma" required placeholder="Es. Goccia / Tonda" />
                        </div>
                        <div class="form-group">
                            <label for="taglia">Taglia</label>
                            <input type="text" id="taglia" name="taglia" required placeholder="Es. L / 58-14" />
                        </div>
                        <div class="form-group">
                            <label for="materiale">Materiale</label>
                            <input type="text" id="materiale" name="materiale" required placeholder="Es. Metallo dorato" />
                        </div>
                        <div class="form-group full-width">
                            <label for="immagine">Immagine Prodotto</label>
                            <input type="file" id="immagine" name="immagine" accept="image/*" required />
                        </div>
                    </div>

                    
                    <div class="color-variants-container">
                        <label>Inserisci Fino a 3 Varianti Colore Iniziali</label>
                        
                        <div class="color-row">
                            <select name="codiceColore">
                                <option value="">Scegli primo colore...</option>
                                <% if (tuttiColori != null) { for (Colore col : tuttiColori) { %>
                                    <option value="<%= col.getCodice() %>"><%= col.getNome() %></option>
                                <% } } %>
                            </select>
                            <input type="number" name="quantitaColore" min="0" placeholder="Qta scorta" />
                        </div>

                        <div class="color-row">
                            <select name="codiceColore">
                                <option value="">Scegli secondo colore...</option>
                                <% if (tuttiColori != null) { for (Colore col : tuttiColori) { %>
                                    <option value="<%= col.getCodice() %>"><%= col.getNome() %></option>
                                <% } } %>
                            </select>
                            <input type="number" name="quantitaColore" min="0" placeholder="Qta scorta" />
                        </div>

                        <div class="color-row">
                            <select name="codiceColore">
                                <option value="">Scegli terzo colore...</option>
                                <% if (tuttiColori != null) { for (Colore col : tuttiColori) { %>
                                    <option value="<%= col.getCodice() %>"><%= col.getNome() %></option>
                                <% } } %>
                            </select>
                            <input type="number" name="quantitaColore" min="0" placeholder="Qta scorta" />
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-submit">Aggiungi Occhiale</button>
                </form>
            <% } %>

        </div>

    </div>
</div>

<%
    } else {
%>
    <div class="container" style="text-align: center; padding: 50px;">
        <h2>Errore di Configurazione Database</h2>
        <p style="color: var(--text-secondary); margin-top: 15px;">Impossibile recuperare il DataSource JNDI.</p>
    </div>
<%
    }
%>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
