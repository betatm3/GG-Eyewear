<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Map" %>
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
    
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Fraunces:ital,opsz,wght@0,9..144,300;0,9..144,500;0,9..144,600;1,9..144,500&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/comune.css?v=2">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/catalogo.css?v=2">
</head>
<body>
<%@ include file="../partials/header.jsp" %>

    <% 
        Boolean isOutlet = (Boolean) request.getAttribute("isOutlet");
        if (isOutlet == null) isOutlet = "true".equalsIgnoreCase(request.getParameter("outlet"));
        
        String paramMarca = request.getParameter("marca") != null ? request.getParameter("marca") : "";
        String paramGenere = request.getParameter("genere") != null ? request.getParameter("genere") : "";
        String paramMontatura = request.getParameter("montatura") != null ? request.getParameter("montatura") : "";
        String paramTaglia = request.getParameter("taglia") != null ? request.getParameter("taglia") : "";
        String paramMateriale = request.getParameter("materiale") != null ? request.getParameter("materiale") : "";
        String paramForma = request.getParameter("forma") != null ? request.getParameter("forma") : "";
        String paramColore = request.getParameter("colore") != null ? request.getParameter("colore") : "";
        String paramPrezzoMin = request.getParameter("prezzoMin") != null ? request.getParameter("prezzoMin") : "";
        String paramPrezzoMax = request.getParameter("prezzoMax") != null ? request.getParameter("prezzoMax") : "";
    %>

    <h1><%= isOutlet ? "Outlet Occhiali — Sconti Esclusivi" : "Il nostro Catalogo Occhiali" %></h1>

    
    <div class="filters-section">
        <div class="filters-title">
            <img src="${pageContext.request.contextPath}/images/icons8-filter-24.png" alt="Filtra" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;" />
            Filtra Catalogo
        </div>
        <form id = "filtriCatalogo">
            <% if (isOutlet) { %>
                <input type="hidden" name="outlet" value="true" />
            <% } %>
            <% 
                String currentTipo = request.getParameter("tipo"); 
                if (currentTipo != null && !currentTipo.trim().isEmpty()) { 
            %>
                <input type="hidden" name="tipo" value="<%= currentTipo %>" />
            <% 
                } 
            %>
        
            <div class="filters-grid">
                <div class="filter-field">
                    <label class="filter-label" for="filterMarca">Marca</label>
                    <input type="text" id="filterMarca" name="marca" class="filter-input" placeholder="Es. Ray-Ban..." value="<%= paramMarca%>" />
                </div>
                
                <div class="filter-field">
                    <label class="filter-label" for="filterGenere">Genere</label>
                    <select id="filterGenere" name="genere" class="filter-input">
                        <option value="">Tutti</option>
                        <option value="Uomo" <%= "Uomo".equalsIgnoreCase(paramGenere) ? "selected" : "" %>>Uomo</option>
                        <option value="Donna" <%= "Donna".equalsIgnoreCase(paramGenere) ? "selected" : "" %>>Donna</option>
                        <option value="Unisex" <%= "Unisex".equalsIgnoreCase(paramGenere) ? "selected" : "" %>>Unisex</option>
                    </select>
                </div>
                
                <div class="filter-field">
                    <label class="filter-label" for="filterMontatura">Montatura</label>
                    <select id="filterMontatura" name="montatura" class="filter-input">
                        <option value="">Tutti</option>
                        <option value="Spessa" <%= "Spessa".equalsIgnoreCase(paramMontatura) ? "selected" : "" %>>Spessa</option>
                        <option value="Mezza" <%= "Mezza".equalsIgnoreCase(paramMontatura) ? "selected" : "" %>>Mezza</option>
                        <option value="Senza" <%= "Senza".equalsIgnoreCase(paramMontatura) ? "selected" : "" %>>Senza</option>
                    </select>
                </div>

				<div class="filter-field">
                    <label class="filter-label" for="filterTaglia">Taglia</label>
					<select id="filterTaglia" name="taglia" class="filter-input">
                        <option value="">Tutti</option>
                        <option value="L" <%= "L".equalsIgnoreCase(paramTaglia) ? "selected" : "" %>>L ( > 55 mm)</option>
                        <option value="M" <%= "M".equalsIgnoreCase(paramTaglia) ? "selected" : "" %>>M ( 51 - 54 mm)</option>
                        <option value="S" <%= "S".equalsIgnoreCase(paramTaglia) ? "selected" : "" %>>S ( < 50 mm)</option>
                    </select>                
                </div>

                <div class="filter-field">
                    <label class="filter-label" for="filterMateriale">Materiale</label>
                    <input type="text" id="filterMateriale" name="materiale" class="filter-input" placeholder="Es. Acetato, Metallo..." value="<%= paramMateriale%>" />
                </div>

                <div class="filter-field">
                    <label class="filter-label" for="filterForma">Forma</label>
                    <input type="text" id="filterForma" name="forma" class="filter-input" placeholder="Es. Rotonda, Aviator..." value="<%= paramForma%>" />
                </div>

                <div class="filter-field">
                    <label class="filter-label" for="filterColore">Colore</label>
                    <input type="text" id="filterColore" name="colore" class="filter-input" placeholder="Es. Nero, Oro..." value="<%= paramColore%>" />
                </div>
                
                <div class="filter-field">
                    <label class="filter-label" for="filterPrezzoMin">Prezzo Minimo (€)</label>
                    <input type="number" id="filterPrezzoMin" name="prezzoMin" class="filter-input" placeholder="Es. 50" min="0" step="10" value="<%= paramPrezzoMin%>" />
                </div>

                <div class="filter-field">
                    <label class="filter-label" for="filterPrezzoMax">Prezzo Massimo (€)</label>
                    <input type="number" id="filterPrezzoMax" name="prezzoMax" class="filter-input" placeholder="Es. 150" min="0" step="10" value="<%= paramPrezzoMax%>" />
                </div>
                
				<div class="filters-actions">
		            <button type="button" id="btnResetFiltri" class="btn-reset" style="width: 100%; cursor: pointer;">
				        Azzera Filtri
				    </button>
		        </div>
                
            </div>
            
        </form>
    </div>
    <div id="catalogoContainer">
		<jsp:include page="/WEB-INF/view/guest/grigliaProdotti.jsp" />
	</div>


<%@ include file="../partials/footer.jsp" %>

<script>
    const contextPath = "<%= request.getContextPath() %>";
</script>
<script src="<%= request.getContextPath() %>/scripts/catalogo.js"></script>
</body>
</html>