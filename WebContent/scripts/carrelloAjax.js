document.addEventListener("DOMContentLoaded", () => {
    console.log("GG Eyewear - Script AJAX Carrello Caricato.");

    const activeCart = document.getElementById("activeCartContent");
    const emptyCart = document.getElementById("emptyCartContent");
    const cartTotal = document.getElementById("cartTotal");

    // Delegazione degli eventi all'interno del contenitore del carrello
    if (activeCart) {
        activeCart.addEventListener("click", (event) => {
            const target = event.target;

            // 1. Clic su Incremento (+) o Decremento (-) della Quantità
            if (target.classList.contains("btn-qty")) {
                event.preventDefault();
                gestisciModificaQuantita(target);
            }

            // 2. Clic su Rimuovi (Cestino 🗑️)
            if (target.classList.contains("btn-remove")) {
                event.preventDefault();
                gestisciRimozione(target);
            }

            // 3. Clic su Svuota Carrello
            if (target.classList.contains("btn-clear-cart")) {
                event.preventDefault();
                gestisciSvuota(target);
            }
        });
    }

    // Gestione asincrona modifica quantità (+ / -)
    function gestisciModificaQuantita(link) {
        const urlObj = new URL(link.href, window.location.origin);
        urlObj.searchParams.set("ajax", "true");

        const id = urlObj.searchParams.get("idOcchiale");
        const cod = urlObj.searchParams.get("codiceVersioneOcchiale");
        const col = urlObj.searchParams.get("coloreScelto");
        const nuovaQty = parseInt(urlObj.searchParams.get("quantita"), 10);

        // Se la quantità scende sotto 1, chiediamo rimozione (o la servlet eliminerà l'articolo)
        const row = document.querySelector(`tr[data-id="${id}"][data-codice="${cod}"][data-colore="${col}"]`);

        fetch(urlObj.pathname + urlObj.search)
            .then(response => {
                if (!response.ok) throw new Error("Errore di rete");
                return response.json();
            })
            .then(data => {
                if (data.status === "success") {
                    if (data.carrelloVuoto) {
                        mostraCarrelloVuoto();
                    } else if (nuovaQty <= 0) {
                        // Se la quantità impostata era 0, la riga va eliminata
                        rimuoviRigaConAnimazione(row, data.totaleCarrello);
                    } else {
                        // Aggiorna quantità e subtotale nella riga
                        const qtySpan = row.querySelector(".qty-val");
                        const subtotalTd = row.querySelector(".item-subtotal");
                        
                        if (qtySpan) qtySpan.textContent = data.quantita;
                        if (subtotalTd) subtotalTd.textContent = "€ " + data.subtotale.toFixed(2);

                        // Aggiorna gli href dei pulsanti + e -
                        const btnMinus = row.querySelector(".btn-minus");
                        const btnPlus = row.querySelector(".btn-plus");

                        if (btnMinus) {
                            const minusUrl = new URL(btnMinus.href, window.location.origin);
                            minusUrl.searchParams.set("quantita", data.quantita - 1);
                            btnMinus.href = minusUrl.pathname + minusUrl.search;
                        }
                        if (btnPlus) {
                            const plusUrl = new URL(btnPlus.href, window.location.origin);
                            plusUrl.searchParams.set("quantita", data.quantita + 1);
                            btnPlus.href = plusUrl.pathname + plusUrl.search;
                        }

                        // Aggiorna il totale del carrello
                        aggiornaTotaleCarrello(data.totaleCarrello);
                    }
                }
            })
            .catch(err => {
                console.error("Errore AJAX quantità:", err);
                // Fallback: ricarica la pagina in caso di errore di connessione
                window.location.reload();
            });
    }

    // Gestione asincrona rimozione singola riga
    function gestisciRimozione(link) {
        const urlObj = new URL(link.href, window.location.origin);
        urlObj.searchParams.set("ajax", "true");

        const id = urlObj.searchParams.get("idOcchiale");
        const cod = urlObj.searchParams.get("codiceVersioneOcchiale");
        const col = urlObj.searchParams.get("coloreScelto");
        const row = document.querySelector(`tr[data-id="${id}"][data-codice="${cod}"][data-colore="${col}"]`);

        fetch(urlObj.pathname + urlObj.search)
            .then(response => {
                if (!response.ok) throw new Error("Errore di rete");
                return response.json();
            })
            .then(data => {
                if (data.status === "success") {
                    if (data.carrelloVuoto) {
                        mostraCarrelloVuoto();
                    } else {
                        rimuoviRigaConAnimazione(row, data.totaleCarrello);
                    }
                }
            })
            .catch(err => {
                console.error("Errore AJAX rimozione:", err);
                window.location.reload();
            });
    }

    // Gestione asincrona svuotamento totale del carrello
    function gestisciSvuota(link) {
        const urlObj = new URL(link.href, window.location.origin);
        urlObj.searchParams.set("ajax", "true");

        fetch(urlObj.pathname + urlObj.search)
            .then(response => {
                if (!response.ok) throw new Error("Errore di rete");
                return response.json();
            })
            .then(data => {
                if (data.status === "success" && data.carrelloVuoto) {
                    mostraCarrelloVuoto();
                }
            })
            .catch(err => {
                console.error("Errore AJAX svuotamento:", err);
                window.location.reload();
            });
    }

    // Helper per aggiornare il totale visivo del carrello
    function aggiornaTotaleCarrello(nuovoTotale) {
        if (cartTotal) {
            cartTotal.textContent = "€ " + nuovoTotale.toFixed(2);
        }
    }

    // Helper per rimuovere una riga con un effetto di dissolvenza (fadeout)
    function rimuoviRigaConAnimazione(row, nuovoTotale) {
        if (!row) return;
        row.style.transition = "opacity 0.4s ease, transform 0.4s ease";
        row.style.opacity = "0";
        row.style.transform = "translateX(20px)";
        
        setTimeout(() => {
            row.remove();
            aggiornaTotaleCarrello(nuovoTotale);
        }, 400);
    }

    // Helper per commutare la vista su carrello vuoto
    function mostraCarrelloVuoto() {
        if (activeCart) activeCart.style.display = "none";
        if (emptyCart) {
            emptyCart.style.opacity = "0";
            emptyCart.style.display = "block";
            emptyCart.style.transition = "opacity 0.5s ease";
            setTimeout(() => {
                emptyCart.style.opacity = "1";
            }, 50);
        }
    }
});
