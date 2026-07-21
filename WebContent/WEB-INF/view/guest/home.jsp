<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Base64" %>
<%@ page import="model.Occhiale" %>
<%@ page import="model.Disponibile" %>
<%@ page import="model.VersioneOcchiale" %>
<%@ page import="model.Colore" %>
<!DOCTYPE html>
<html lang="it">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>GG Eyewear — Occhiali</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Fraunces:ital,opsz,wght@0,9..144,300;0,9..144,500;0,9..144,600;1,9..144,500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/comune.css?v=2">
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/home.css?v=2">
</head>
<body>

<%
  int cartCount = 0;
  HttpSession sess = request.getSession(false);
  if (sess != null) {
      Collection<?> carrello = (Collection<?>) sess.getAttribute("carrello");
      if (carrello != null) {
          cartCount = carrello.size();
      }
  }
  
  Collection<Occhiale> soleList = (Collection<Occhiale>) request.getAttribute("sole");
  Collection<Occhiale> vistaList = (Collection<Occhiale>) request.getAttribute("vista");
  Map<Integer, Double> medieVoti = (Map<Integer, Double>) request.getAttribute("medieVoti");
  int totalModels = (soleList != null ? soleList.size() : 0) + (vistaList != null ? vistaList.size() : 0);
%>

<%@ include file="../partials/header.jsp" %>

<section class="hero">
  <div class="hero-inner" style="display: block; max-width: 1180px; margin: 0 auto; padding: 40px 32px; min-height: auto;">
    <div class="hero-visual" style="display: block; position: relative; height: 580px; overflow: hidden; border-radius: 24px; border: 1px solid var(--line); background: var(--paper-soft); width: 100%;">
      <div class="hero-slides" style="width: 100%; height: 100%; position: relative;">
        
        <div class="hero-slide active" style="background: linear-gradient(rgba(0,0,0,0.35), rgba(0,0,0,0.45)), url('https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=1600&auto=format&fit=crop&q=80') center/cover no-repeat;">
          <div style="text-align: center; color: #FFFFFF; padding: 20px; text-shadow: 0 2px 10px rgba(0,0,0,0.5);">
            <h4 style="font-family: 'Fraunces', serif; font-size: 32px; font-weight: 500; margin-bottom: 8px; font-style: italic; color: #FFFFFF;">Nuova Collezione Sole</h4>
            <p style="font-size: 15px; color: #F0EAE1; margin-bottom: 80px; letter-spacing: 0.04em;">Stile iconico e massima protezione per le tue giornate al sole</p>
          </div>
        </div>
        
        <div class="hero-slide" style="background: linear-gradient(rgba(0,0,0,0.35), rgba(0,0,0,0.45)), url('https://images.unsplash.com/photo-1574258495973-f010dfbb5371?w=1600&auto=format&fit=crop&q=80') center/cover no-repeat;">
          <div style="text-align: center; color: #FFFFFF; padding: 20px; text-shadow: 0 2px 10px rgba(0,0,0,0.5);">
            <h4 style="font-family: 'Fraunces', serif; font-size: 32px; font-weight: 500; margin-bottom: 8px; font-style: italic; color: #FFFFFF;">Montature da Vista Premium</h4>
            <p style="font-size: 15px; color: #F0EAE1; margin-bottom: 80px; letter-spacing: 0.04em;">Design contemporaneo e comfort per ogni momento della tua giornata</p>
          </div>
        </div>
        
        <div class="hero-slide" style="background: linear-gradient(rgba(0,0,0,0.35), rgba(0,0,0,0.45)), url('https://images.unsplash.com/photo-1508296695146-257a814070b4?w=1600&auto=format&fit=crop&q=80') center/cover no-repeat;">
          <div style="text-align: center; color: #FFFFFF; padding: 20px; text-shadow: 0 2px 10px rgba(0,0,0,0.5);">
            <h4 style="font-family: 'Fraunces', serif; font-size: 32px; font-weight: 500; margin-bottom: 8px; font-style: italic; color: #FFFFFF;">Artigianato GG Eyewear</h4>
            <p style="font-size: 15px; color: #F0EAE1; margin-bottom: 80px; letter-spacing: 0.04em;">Materiali nobili lavorati con cura ed attenzione sartoriale</p>
          </div>
        </div>
      </div>

      
      <div style="position: absolute; inset: 0; display: flex; align-items: flex-end; justify-content: center; padding-bottom: 70px; z-index: 12; pointer-events: none;">
        <a href="${pageContext.request.contextPath}/catalogo" class="btn-primary" style="pointer-events: auto; box-shadow: 0 8px 30px rgba(0,0,0,0.18);">
          Scopri la collezione
          <img src="${pageContext.request.contextPath}/images/icons8-right-arrow-24 (1).png" alt="->" style="width: 14px; height: 14px; margin-left: 8px; vertical-align: middle;" />
        </a>
      </div>

      
      <div class="slider-dots" style="position: absolute; bottom: 24px; left: 50%; transform: translateX(-50%); display: flex; gap: 8px; z-index: 15;">
        <span class="slider-dot active" data-index="0"></span>
        <span class="slider-dot" data-index="1"></span>
        <span class="slider-dot" data-index="2"></span>
      </div>
    </div>
  </div>
</section>

<section class="featured wrap" id="prodotti">
  <div class="section-head">
    <div>
      <span class="label">In primo piano</span>
      <h2>Selezionati per te</h2>
    </div>
    <span class="count"><%= totalModels %> modelli</span>
  </div>

  <div class="featured-groups">

   
    <div class="group" id="sole">
      <h3>Occhiali da sole</h3>
      <div class="grid-2x2">
        <% 
            if (soleList != null && !soleList.isEmpty()) {
                for (Occhiale occhiale : soleList) {
                    VersioneOcchiale versione = occhiale.getVersioneCorrente();
                    String nomeProdotto = (versione != null && versione.getMarca() != null) ? versione.getMarca() : "Brand";
                    if (versione != null && versione.getModello() != null) {
                        nomeProdotto = versione.getMarca() + " " + versione.getModello();
                    }
                    
                    double mediaVoto = (medieVoti != null && medieVoti.containsKey(occhiale.getId())) ? medieVoti.get(occhiale.getId()) : 0.0;
                    double prezzoDouble = (versione != null) ? versione.getPrezzo() : 0.0;
                    String prezzoStr = "";
                    if (prezzoDouble > 0) {
                        if (prezzoDouble == (long) prezzoDouble) {
                            prezzoStr = String.format("€ %d", (long) prezzoDouble);
                        } else {
                            prezzoStr = String.format("€ %.2f", prezzoDouble);
                        }
                    } else {
                        prezzoStr = "Prezzo N/D";
                    }
        %>
                    <a href="${pageContext.request.contextPath}/occhiale?id=<%= occhiale.getId() %>" class="product-card">
                      <div class="product-frame">
                        <% 
                            String primaImgSole = (occhiale != null) ? occhiale.getImmagine(0) : null;
                            String imgSrcSole = null;
                            if (primaImgSole != null && !primaImgSole.trim().isEmpty()) {
                                String trimmed = primaImgSole.trim();
                                if (trimmed.startsWith("data:") || trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
                                    imgSrcSole = trimmed;
                                } else if (trimmed.startsWith("/") || trimmed.startsWith("images/")) {
                                    imgSrcSole = request.getContextPath() + (trimmed.startsWith("/") ? "" : "/") + trimmed;
                                } else {
                                    imgSrcSole = "data:image/jpeg;base64," + trimmed;
                                }
                            }
                            if (imgSrcSole != null) {
                        %>
                                <img src="<%= imgSrcSole %>" alt="Foto <%= nomeProdotto %>" />
                        <% 
                            } else { 
                        %>
                                <span style="font-size: 11px; color: #888; text-align: center; padding: 10px; font-weight: 500;">Immagine non disponibile</span>
                        <% 
                            } 
                        %>
                      </div>
                      <div class="product-info">
                        <div class="product-name"><%= nomeProdotto %></div>
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-top: 6px;">
                          <div class="product-price"><%= prezzoStr %></div>
                          <div class="rating-stars" style="font-size: 12px; color: #f59e0b;" title="<%= mediaVoto > 0 ? String.format("%.1f su 5 stelle", mediaVoto) : "Nessuna recensione" %>">
                            <% 
                                int interoVoto = (int) Math.round(mediaVoto);
                                for (int s = 1; s <= 5; s++) {
                                    if (s <= interoVoto && interoVoto > 0) {
                            %>
                                        <span style="color: #f59e0b;">★</span>
                            <% 
                                    } else { 
                            %>
                                        <span style="color: #d1d5db;">☆</span>
                            <% 
                                    }
                                } 
                            %>
                          </div>
                        </div>
                      </div>
                    </a>
        <% 
                }
            } else {
        %>
                <p style="grid-column: span 2; color: #888; font-style: italic;">Nessun occhiale da sole in primo piano al momento.</p>
        <% 
            }
        %>
      </div>
    </div>

    
    <div class="group" id="vista">
      <h3>Occhiali da vista</h3>
      <div class="grid-2x2">
        <% 
            if (vistaList != null && !vistaList.isEmpty()) {
                for (Occhiale occhiale : vistaList) {
                    VersioneOcchiale versione = occhiale.getVersioneCorrente();
                    String nomeProdotto = (versione != null && versione.getMarca() != null) ? versione.getMarca() : "Brand";
                    if (versione != null && versione.getModello() != null) {
                        nomeProdotto = versione.getMarca() + " " + versione.getModello();
                    }
                    
                    double mediaVoto = (medieVoti != null && medieVoti.containsKey(occhiale.getId())) ? medieVoti.get(occhiale.getId()) : 0.0;
                    double prezzoDouble = (versione != null) ? versione.getPrezzo() : 0.0;
                    String prezzoStr = "";
                    if (prezzoDouble > 0) {
                        if (prezzoDouble == (long) prezzoDouble) {
                            prezzoStr = String.format("€ %d", (long) prezzoDouble);
                        } else {
                            prezzoStr = String.format("€ %.2f", prezzoDouble);
                        }
                    } else {
                        prezzoStr = "Prezzo N/D";
                    }
        %>
                    <a href="${pageContext.request.contextPath}/occhiale?id=<%= occhiale.getId() %>" class="product-card">
                      <div class="product-frame">
                        <% 
                            String primaImgVista = (occhiale != null) ? occhiale.getImmagine(0) : null;
                            String imgSrcVista = null;
                            if (primaImgVista != null && !primaImgVista.trim().isEmpty()) {
                                String trimmed = primaImgVista.trim();
                                if (trimmed.startsWith("data:") || trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
                                    imgSrcVista = trimmed;
                                } else if (trimmed.startsWith("/") || trimmed.startsWith("images/")) {
                                    imgSrcVista = request.getContextPath() + (trimmed.startsWith("/") ? "" : "/") + trimmed;
                                } else {
                                    imgSrcVista = "data:image/jpeg;base64," + trimmed;
                                }
                            }
                            if (imgSrcVista != null) {
                        %>
                                <img src="<%= imgSrcVista %>" alt="Foto <%= nomeProdotto %>" />
                        <% 
                            } else { 
                        %>
                                <span style="font-size: 11px; color: #888; text-align: center; padding: 10px; font-weight: 500;">Immagine non disponibile</span>
                        <% 
                            } 
                        %>
                      </div>
                      <div class="product-info">
                        <div class="product-name"><%= nomeProdotto %></div>
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-top: 6px;">
                          <div class="product-price"><%= prezzoStr %></div>
                          <div class="rating-stars" style="font-size: 12px; color: #f59e0b;" title="<%= mediaVoto > 0 ? String.format("%.1f su 5 stelle", mediaVoto) : "Nessuna recensione" %>">
                            <% 
                                int interoVoto = (int) Math.round(mediaVoto);
                                for (int s = 1; s <= 5; s++) {
                                    if (s <= interoVoto && interoVoto > 0) {
                            %>
                                        <span style="color: #f59e0b;">★</span>
                            <% 
                                    } else { 
                            %>
                                        <span style="color: #d1d5db;">☆</span>
                            <% 
                                    }
                                } 
                            %>
                          </div>
                        </div>
                      </div>
                    </a>
        <% 
                }
            } else {
        %>
                <p style="grid-column: span 2; color: #888; font-style: italic;">Nessun occhiale da vista in primo piano al momento.</p>
        <% 
            }
        %>
      </div>
    </div>

  </div>
</section>

<%@ include file="../partials/footer.jsp" %>

<script>
  document.addEventListener("DOMContentLoaded", function() {
    const slides = document.querySelectorAll(".hero-slide");
    const dots = document.querySelectorAll(".slider-dot");
    let currentSlide = 0;

    function showSlide(index) {
      slides[currentSlide].classList.remove("active");
      dots[currentSlide].classList.remove("active");
      currentSlide = (index + slides.length) % slides.length;
      slides[currentSlide].classList.add("active");
      dots[currentSlide].classList.add("active");
    }

    dots.forEach((dot, index) => {
      dot.addEventListener("click", () => {
        showSlide(index);
      });
    });
  });
</script>

</body>
</html>
