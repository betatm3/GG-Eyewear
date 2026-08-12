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
        
        <%-- Controllo presenza parametri di errore o successo --%>
		<%
		    String errore = (String) request.getAttribute("errore");
		    String msgSuccesso = (String) request.getAttribute("msgSuccesso");
		%>
		
		<%-- BANNER DI ERRORE --%>
		<% if (errore != null && !errore.trim().isEmpty()) { %>
		    <div class="error-banner" style=" justify-content: space-between;">
		        <div></div>
		        <div class="banner-content">
		            <span>⚠️</span>
		            <span><%= errore %></span>
		        </div>
		        <button type="button" class="close-banner-btn" title="Chiudi banner" aria-label="Chiudi banner" onclick="this.parentElement.style.display='none';">✕</button>
		    </div>
		<% } %>
		
		<%-- BANNER DI SUCCESSO --%>
		<% if (msgSuccesso != null && !msgSuccesso.trim().isEmpty()) { %>
		    <div class="success-banner">
		        <div></div>
		        <div class="banner-content">
		            <span>✓</span>
		            <span><%= msgSuccesso %></span>
		        </div>
		        <button type="button" class="close-banner-btn" title="Chiudi banner" aria-label="Chiudi banner" onclick="this.parentElement.style.display='none';" style=" color: rgb(16, 185, 129);">✕</button>
		    </div>
		<% } %>
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
                                                    String primaImg = (occ != null) ? occ.getImmagine(0) : null;
                                                    String imgSrc = null, altText=null;
                                                    
                                                    if (primaImg != null && !primaImg.trim().isEmpty()) {
                                                        imgSrc = request.getContextPath() + "/" + primaImg.trim();
                                                        altText = (v != null) ? v.getModello() : "Occhiale";
                                                    } else {
                                                        imgSrc = "https://via.placeholder.com/60x45?text=No+Img";
                                                        altText = "No Image";
                                                    }
                                                %>
                                                <img class="prod-img" src="<%= imgSrc %>" alt="<%= altText %>" />
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
                                                <%-- Operazione di scrittura/modifica: trasformata in form POST --%>
											    <% if (attivo) { %>
											        <form action="<%= request.getContextPath() %>/admin/GestioneProdotti" method="POST" style="display:inline;">
											            <input type="hidden" name="action" value="delete" />
											            <input type="hidden" name="id" value="<%= occ.getId() %>" />
											            
											            <button type="submit" class="btn-action delete" onclick="return confirm('Sicuro di voler disattivare questo prodotto dal catalogo pubblico?');" title="Disattiva prodotto">
											                ❌
											            </button>
											        </form>
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
                
                <form action="<%= request.getContextPath() %>/admin/GestioneProdotti" method="POST" enctype="multipart/form-data" class="product-form">
    				<input type="hidden" name="action" value="updatecaratteristiche" />
                    <input type="hidden" name="idOcchiale" value="<%= versioneInModifica.getOcchiale().getId() %>" />
                    <input type="hidden" name="codiceVersione" value="<%= versioneInModifica.getCodice() %>" />
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="marca">Marca</label>
                            <input type="text" id="marca" name="marca" value="<%= versioneInModifica.getMarca() %>" />
                        </div>
                        <div class="form-group">
                            <label for="modello">Modello</label>
                            <input type="text" id="modello" name="modello" value="<%= versioneInModifica.getModello() %>" />
                        </div>
                        <div class="form-group">
                            <label for="prezzo">Prezzo (€)</label>
                            <input type="number" id="prezzo" name="prezzo" step="0.1" value="<%= versioneInModifica.getPrezzo() %>" />
                        </div>
                        <div class="form-group">
                            <label for="tipologia">Tipologia</label>
                            <select id="tipologia" name="tipologia">
                                <% for (Tipologia t : Tipologia.values()) { %>
                                    <option value="<%= t.name() %>" <%= versioneInModifica.getOcchiale().getTipo() == t ? "selected" : "" %>><%= t.name().replace("_", " ") %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="genere">Genere</label>
                            <select id="genere" name="genere">
                                <% for (Genere g : Genere.values()) { %>
                                    <option value="<%= g.name() %>" <%= versioneInModifica.getGenere() == g ? "selected" : "" %>><%= g.name() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="montatura">Montatura</label>
                            <select id="montatura" name="montatura">
                                <% for (Montatura m : Montatura.values()) { %>
                                    <option value="<%= m.name() %>" <%= versioneInModifica.getMontatura() == m ? "selected" : "" %>><%= m.name() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="forma">Forma Lenti</label>
                            <select id="forma" name="forma">
                                <% for (Forma f : Forma.values()) { %>
                                    <option value="<%= f.name() %>" <%= versioneInModifica.getForma() == f ? "selected" : "" %>><%= f.getDisplayName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="taglia">Taglia</label>
                            <select id="taglia" name="taglia">
                                <% for (Taglia t : Taglia.values()) { %>
                                    <option value="<%= t.name() %>" <%= versioneInModifica.getTaglia() == t ? "selected" : "" %>><%= t.getDescrizione()%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="materiale">Materiale</label>
                            <input type="text" id="materiale" name="materiale" value="<%= versioneInModifica.getMateriale() %>" />
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
                            <label for="edit_immagine1">Nuove Immagini (Lascia vuoto per non cambiare)</label>
                            <div class="file-input-wrapper">
						        <input type="file" id="edit_immagine1" name="immagine1" accept="image/*" />
						        <button type="button" class="btn-remove-simple" title="Rimuovi file" style="display: none;">✕</button>
						    </div>
						    <div class="file-input-wrapper">
						        <input type="file" id="edit_immagine2" name="immagine2" accept="image/*" />
						        <button type="button" class="btn-remove-simple" title="Rimuovi file" style="display: none;">✕</button>
						    </div>
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
                    Stai gestendo le varianti di colore del prodotto: <strong>ID <%= occhialeColori.getId() %></strong>
                </div>

                
                <div class="color-manager-list">
                    <%
                        if (coloriAssociati != null && !coloriAssociati.isEmpty()) {
                            for (Disponibile disp : coloriAssociati) {
                                
                                Colore cDettaglio = coloreDAO.doRetrieveByCodice(disp.getColore().getCodice());
                                String nomeC = cDettaglio != null ? cDettaglio.getNome() : disp.getColore().getCodice();
                    %>
                                <div class="color-manager-item">
                                    <div class="color-manager-name">
                                        🎨 <%= nomeC %> <span style="font-size: 0.8rem; color: var(--text-secondary);">(<%= disp.getColore().getCodice() %>)</span>
                                    </div>
                                    
                                    <div class="color-update-form">
                                        
                                        <form action="<%= request.getContextPath() %>/admin/GestioneProdotti" method="POST" style="display: flex; gap: 6px; align-items: flex-start;">
										    <input type="hidden" name="action" value="updatecolori" />
										    <input type="hidden" name="subAction" value="updatequantity" />
										    <input type="hidden" name="idOcchiale" value="<%= occhialeColori.getId() %>" />
										    <input type="hidden" name="codiceColore" value="<%= disp.getColore().getCodice() %>" />
										    
										    <div class="input-group-wrapper">
										        <input type="number" name="quantita" value="<%= disp.getQuantita() %>" />
										    </div>
										    <button type="submit" class="btn-mini save">Aggiorna</button>
										</form>

                                        
                                        <form action="<%= request.getContextPath() %>/admin/GestioneProdotti" method="POST" style="display:inline;">
										    <input type="hidden" name="action" value="updatecolori">
										    <input type="hidden" name="subAction" value="removecolor">
										    <input type="hidden" name="idOcchiale" value="<%= occhialeColori.getId() %>">
										    <input type="hidden" name="codiceColore" value="<%= disp.getColore().getCodice() %>">
										    
										    <button type="submit" class="btn-mini delete" 
										            onclick="return confirm('Sicuro di voler rimuovere questa variante colore? Verrà azzerato il magazzino per questa opzione.');">
										        Rimuovi
										    </button>
										</form>
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
                    <div style="font-weight: 700; font-size: 1rem; margin-bottom: 15px;">Associa Nuova Variante Colore</div>
                    <div class="color-variants-container">
	                    <form id="formAddColor" action="<%= request.getContextPath() %>/admin/GestioneProdotti" method="POST">
						    <input type="hidden" name="action" value="updatecolori" />
						    <input type="hidden" name="subAction" value="addcolor" />
						    <input type="hidden" name="idOcchiale" value="<%= occhialeColori.getId() %>" />
	                        
	                        <div class="form-grid">
	                            <div class="form-group">
	                                <label for="nuovo_colore">Colore</label>
	                                <select id="nuovo_colore" name="codiceColore">
	                                    <option value="">Seleziona Colore...</option>
	                                    <%
	                                        if (tuttiColori != null) {
	                                            for (Colore col : tuttiColori) {
	                                    %>
	                                                <option value="<%= col.getCodice() %>"><%= col.getNome() %></option>
	                                    <%
	                                            }
	                                        }
	                                    %>
	                                </select>
	                            </div>
	                            
	                            <div class="form-group">
	                                <label for="nuova_quantita">Quantità Iniziale</label>
	                                <input type="number" id="nuova_quantita" name="quantita" placeholder="10" />
	                            </div>
	                        </div>
	                        <label for="newNomeColore" style="margin-top: 14px;">(Aggiungi una nuova variante al catalogo)</label>
	                        <div class="color-row">
		                        <div class="field-wrapper">
			                        <input type="text" id="newNomeColore" name="newNomeColore" placeholder="Es. Tartarugato classico" />
		                        </div>
	                        	<div class="field-wrapper">
	                        		<input type="color" id="nuovoHexColore" name="newHexColore" value="#000000" style="width: 80px; height: 40px;"/> 
								</div>
								<div class="field-wrapper">
	                            	<input type="number" id= "newQtaColore" name="newQtaColore" placeholder="10" style="width: 80px; height: 40px;"/>
	                        	</div>
	                        </div>
	                        	                        
	                        <button type="submit" class="btn-submit">Associa Colore</button>
	                        <a href="<%= request.getContextPath() %>/admin/GestioneProdotti" class="btn-cancel">Chiudi Pannello Colori</a>
	                    </form>
                    </div>
                </div>

            <% } else { %>
               
                <div class="card-title">
                    <span>➕</span> Aggiungi Nuovo Occhiale
                </div>
                
                <form action="<%= request.getContextPath() %>/admin/GestioneProdotti" method="POST" enctype="multipart/form-data" class="product-form">
    				<input type="hidden" name="action" value="add" />
    				
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="marca">Marca</label>
                            <input type="text" id="marca" name="marca" placeholder="Es. Ray-Ban" />
                        </div>
                        <div class="form-group">
                            <label for="modello">Modello</label>
                            <input type="text" id="modello" name="modello" placeholder="Es. Aviator Classic" />
                        </div>
                        <div class="form-group">
                            <label for="prezzo">Prezzo (€)</label>
                            <input type="number" id="prezzo" name="prezzo" step="0.1" placeholder="Es. 129.90" />
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
                            <select id="forma" name="forma">
                                <% for (Forma f : Forma.values()) { %>
                                    <option value="<%= f.name() %>"><%= f.getDisplayName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="taglia">Taglia</label>
                            <select id="taglia" name="taglia">
                                <% for (Taglia t : Taglia.values()) { %>
                                    <option value="<%= t.name() %>"><%= t.getDescrizione()%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="materiale">Materiale</label>
                            <input type="text" id="materiale" name="materiale" placeholder="Es. Metallo dorato" />
                        </div>
                        <div class="form-group full-width">
                            <label for="immagine1">Immagini Prodotto</label>
                            <div class="file-input-wrapper">
						        <input type="file" id="immagine1" name="immagine1" accept="image/*" />
						        <button type="button" class="btn-remove-simple" title="Rimuovi file" style="display: none;">✕</button>
						    </div>
						    <div class="file-input-wrapper">
						        <input type="file" id="immagine2" name="immagine2" accept="image/*" />
						        <button type="button" class="btn-remove-simple" title="Rimuovi file" style="display: none;">✕</button>
						    </div>
                        </div>
                    </div>

                    
                    <div class="color-variants-container" id ="colorVariantsContainer">
                        <label style="font-size: 14px;">Inserisci Fino a 3 Varianti Colore Iniziali</label>
                        <label style="margin-top: 14px;">(Seleziona 2 varianti colori dal catalogo)</label>
                        <div class="color-row">
                        	<div class="field-wrapper">
	                            <select name="codiceColore">
	                                <option value="">Scegli primo colore...</option>
	                                <% if (tuttiColori != null) { for (Colore col : tuttiColori) { %>
	                                    <option value="<%= col.getCodice() %>"><%= col.getNome() %></option>
	                                <% } } %>
	                            </select>
                            </div>
                            <div class="field-wrapper">
                            	<input type="number" name="quantitaColore" placeholder="10" />
                            </div>
                        </div>

                        <div class="color-row">
	                        <div class="field-wrapper">
	                            <select name="codiceColore">
	                                <option value="">Scegli secondo colore...</option>
	                                <% if (tuttiColori != null) { for (Colore col : tuttiColori) { %>
	                                    <option value="<%= col.getCodice() %>"><%= col.getNome() %></option>
	                                <% } } %>
	                            </select>
                            </div>
                            <div class="field-wrapper">
                            	<input type="number" name="quantitaColore" placeholder="10" />
                            </div>
                        </div>
						
						<label for="nuovoNomeColore" style="margin-top: 14px;">(Aggiungi un nuovo colore al catalogo)</label>
                        <div class="color-row">
	                        <div class="field-wrapper">
		                        <input type="text" id="nuovoNomeColore" name="nuovoNomeColore" placeholder="Es. Tartarugato classico" />
	                        </div>
                        	<div class="field-wrapper">
                        		<input type="color" id="nuovoHexColore" name="nuovoHexColore" value="#000000" style="width: 80px; height: 40px;"/> 
							</div>
							<div class="field-wrapper">
                            	<input type="number" id= "nuovaQtaColore" name="nuovaQtaColore" placeholder="10" style="width: 80px; height: 40px;"/>
                        	</div>
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
<script src="${pageContext.request.contextPath}/scripts/gestioneProdotti.js"></script>
<script src="${pageContext.request.contextPath}/scripts/gestioneColori.js"></script>
</body>
</html>
