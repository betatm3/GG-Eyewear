<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="model.Utente" %>
<%@ page import="model.Ruolo" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestione Utenti (Admin) - GG Eyewear</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/gestioneUtenti.css">
</head>
<body>
<%@ include file="../partials/header.jsp" %>

<div class="container">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-back">
        <img src="${pageContext.request.contextPath}/images/icons8-home-24.png" alt="Torna" style="width: 16px; height: 16px; margin-right: 6px; vertical-align: middle;" />
        Torna alla Dashboard Admin
    </a>

    <h1>GG Eyewear — Gestione Utenti</h1>
    <div class="subtitle">Visualizza e gestisci le autorizzazioni e l'attivazione degli utenti iscritti</div>

    <%
        String msgSuccesso = (String) request.getAttribute("msgSuccesso");
        String msgErrore = (String) request.getAttribute("msgErrore");
        
        Utente adminCorrente = (Utente) session.getAttribute("utenteLoggato");

    %>

    <% if (msgSuccesso != null && !msgSuccesso.trim().isEmpty()) { %>
        <div class="banner success-banner">
            <span class="banner-icon">✓</span>
            <span><%= msgSuccesso %></span>
            <button type="button" class="close-banner-btn" onclick="this.parentElement.style.display='none';">✕</button>
        </div>
    <% } %>
    <% if (msgErrore != null && !msgErrore.trim().isEmpty()) { %>
        <div class="banner error-banner">
            <span class="banner-icon">⚠️</span>
            <span><%= msgErrore %></span>
            <button type="button" class="close-banner-btn" onclick="this.parentElement.style.display='none';">✕</button>
        </div>
    <% } %>

    <div class="table-container">
        <table class="users-table">
            <thead>
                <tr>
                    <th>Dati Utente</th>
                    <th>Ruolo</th>
                    <th>Stato</th>
                    <th style="text-align: center;">Azioni</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Collection<Utente> utenti = (Collection<Utente>) request.getAttribute("listaUtenti");
                    if (utenti != null && !utenti.isEmpty()) {
                        for (Utente u : utenti) {
                            boolean isSelf = (adminCorrente != null && adminCorrente.getEmail().equalsIgnoreCase(u.getEmail()));
                            String ruoloClass = (u.getRuolo() == Ruolo.ADMIN) ? "role-admin" : "role-user";
                            String statoClass = u.isAttivo() ? "status-active" : "status-inactive";
                            String statoText = u.isAttivo() ? "Attivo" : "Disattivato";
                %>
                            <tr>
                                <td>
                                    <div class="user-name">
                                        <%= u.getNome() %> <%= u.getCognome() %>
                                        <% if (isSelf) { %>
                                            <span class="self-tag">(Tu)</span>
                                        <% } %>
                                    </div>
                                    <div class="user-meta-sub">
                                        <span><strong>Email:</strong> <%= u.getEmail() %></span>
                                        <span><strong>Telefono:</strong> <%= (u.getTelefono() != null && !u.getTelefono().trim().isEmpty()) ? u.getTelefono() : "N/D" %></span>
                                        <span><strong>Data di Nascita:</strong> <%= u.getDataNascita() != null ? u.getDataNascita() : "N/D" %></span>
                                        <span><strong>Indirizzo di Spedizione:</strong> <%= (u.getIndirizzo() != null && !u.getIndirizzo().trim().isEmpty()) ? u.getIndirizzo() : "N/D" %></span>
                                    </div>
                                </td>
                                <td>
                                    <span class="role-badge <%= ruoloClass %>">
                                        <%= u.getRuolo().name() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="status-badge <%= statoClass %>">
                                        <%= statoText %>
                                    </span>
                                </td>
                                <td>
                                    <div class="actions-group">
                                        <% if (!isSelf) { %>
                                            <!-- Attiva/Disattiva Account -->
                                            <form action="${pageContext.request.contextPath}/admin/GestioneUtenti" method="POST" style="display:inline;" onsubmit="return confirm('Sei sicuro di voler <%= u.isAttivo() ? "disattivare" : "attivare" %> l\'account di <%= u.getNome() %> <%= u.getCognome() %>?');">
                                                <input type="hidden" name="email" value="<%= u.getEmail() %>" />
                                                <input type="hidden" name="action" value="toggleAttivo" />
                                                <% if (u.isAttivo()) { %>
                                                    <button type="submit" class="btn-action btn-deactivate" title="Disattiva Account">Disattiva</button>
                                                <% } else { %>
                                                    <button type="submit" class="btn-action btn-activate" title="Attiva Account">Attiva</button>
                                                <% } %>
                                            </form>

                                            <!-- Promuovi / Retrocedi Ruolo -->
                                            <form action="${pageContext.request.contextPath}/admin/GestioneUtenti" method="POST" style="display:inline;" onsubmit="return confirm('Sei sicuro di voler <%= u.getRuolo() == Ruolo.USER ? "promuovere ad Amministratore" : "rimuovere dal ruolo di Amministratore" %> l\'utente <%= u.getNome() %> <%= u.getCognome() %>?');">
                                                <input type="hidden" name="email" value="<%= u.getEmail() %>" />
                                                <input type="hidden" name="action" value="promuovi" />
                                                <% if (u.getRuolo() == Ruolo.USER) { %>
                                                    <button type="submit" class="btn-action btn-promote" title="Promuovi ad Amministratore">Rendi Admin</button>
                                                <% } else { %>
                                                    <button type="submit" class="btn-action btn-demote" title="Retrocedi a Utente Standard">Rendi User</button>
                                                <% } %>
                                            </form>
                                        <% } else { %>
                                            <span class="no-actions">Nessuna azione consentita</span>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                <%
                        }
                    } else {
                %>
                        <tr>
                            <td colspan="4" class="empty-table-msg">Nessun utente registrato presente nel sistema.</td>
                        </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>