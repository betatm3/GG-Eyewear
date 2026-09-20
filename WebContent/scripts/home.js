document.addEventListener("DOMContentLoaded", function() {
    const slides = document.querySelectorAll(".hero-slide");
    const dots = document.querySelectorAll(".slider-dot");
    const discoverBtn = document.getElementById("heroDiscoverBtn");
    
    if (!slides.length || !dots.length) return;

    let currentSlide = 0;
    const brands = ["Ray-Ban", "Gucci", "Tom Ford"];

    // Recupero base dell'URL (context path) partendo da href iniziale del pulsante
    let basePath = "";
    if (discoverBtn && discoverBtn.getAttribute("href")) {
        const fullHref = discoverBtn.getAttribute("href");
        basePath = fullHref.substring(0, fullHref.indexOf("/catalogo"));
    }

    function showSlide(index) {
        slides[currentSlide].classList.remove("active");
        dots[currentSlide].classList.remove("active");
        
        currentSlide = (index + slides.length) % slides.length;
        
        slides[currentSlide].classList.add("active");
        dots[currentSlide].classList.add("active");
        
        // Aggiorna href in base al brand corrente
        if (discoverBtn) {
            const selectedBrand = encodeURIComponent(brands[currentSlide]);
            discoverBtn.href = `${basePath}/catalogo?marca=${selectedBrand}`;
        }
    }

    dots.forEach((dot, index) => {
        dot.addEventListener("click", () => {
            showSlide(index);
        });
    });
});