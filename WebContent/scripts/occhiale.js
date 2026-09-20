//Cambia l'immagine principale
function changeMainImage(src, element) { //src è l'url dell'img da mettere, element è l'immagine in miniatura
    const mainImg = document.getElementById('mainProductImg');
    if (mainImg) {
        mainImg.src = src;
    }
    
    // tolgo 'active' da tutte le miniature e lo metto all'img corrente
    document.querySelectorAll('.thumb-box').forEach(el => el.classList.remove('active'));
    
    if (element) {
        element.classList.add('active');
    }
}

// Aggiorna nome del colore selezionato
function updateSelectedColorName(colorName) {
    const colorLabel = document.getElementById('selectedColorName');
    if (colorLabel) {
        colorLabel.innerText = colorName;
    }
}