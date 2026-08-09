document.addEventListener("DOMContentLoaded", function () {
    // Seleziona il form di gestione prodotti attivo nella pagina
   const form = document.querySelector("form.product-form");
    if (!form) return;

    // Disabilita i popup nativi dell'HTML5 se presenti
    form.setAttribute("novalidate", "true");

    // Riferimenti ai campi input comuni
    const marcaInput = document.getElementById("marca");
    const modelloInput = document.getElementById("modello");
    const prezzoInput = document.getElementById("prezzo");
    const materialeInput = document.getElementById("materiale");

    // Immagini distinte per form di aggiunta e form di modifica
    const immagineNuovaInput = document.getElementById("immagine");         // Form Aggiungi (Obbligatoria)
    const immagineModificaInput = document.getElementById("edit_immagine"); // Form Modifica (Opzionale)

    // Varianti Colore (Presenti solo nel form di Aggiunta)
    const coloreSelects = document.querySelectorAll("select[name='codiceColore']");
    const quantitaInputs = document.querySelectorAll("input[name='quantitaColore']");

    // Funzione helper per mostrare/rimuovere i messaggi d'errore
    function showFieldError(input, message) {
        if (!input) return;
        let parent = input.parentElement;
        let errorSpan = parent.querySelector(".error-msg");

        if (message) {
            if (!errorSpan) {
                errorSpan = document.createElement("small");
                errorSpan.className = "error-msg";
                errorSpan.style.color = "#C86A55";
                errorSpan.style.fontSize = "12px";
                errorSpan.style.marginTop = "4px";
                errorSpan.style.display = "block";
                errorSpan.style.fontWeight = "500";
                parent.appendChild(errorSpan);
            }
            errorSpan.textContent = message;
            input.style.borderColor = "#C86A55";
        } else {
            if (errorSpan) {
                errorSpan.remove();
            }
            input.style.borderColor = "#E2DDD5";
        }
    }

    // --- FUNZIONI DI VALIDAZIONE ---

    function validateMarca() {
        if (!marcaInput) return true;
        if (!marcaInput.value.trim()) {
            showFieldError(marcaInput, "La marca è obbligatoria.");
            return false;
        }
        showFieldError(marcaInput, null);
        return true;
    }

    function validateModello() {
        if (!modelloInput) return true;
        if (!modelloInput.value.trim()) {
            showFieldError(modelloInput, "Il modello è obbligatorio.");
            return false;
        }
        showFieldError(modelloInput, null);
        return true;
    }

    function validatePrezzo() {
        if (!prezzoInput) return true;
        const val = parseFloat(prezzoInput.value);
        if (!prezzoInput.value.trim() || isNaN(val) || val <= 0) {
            showFieldError(prezzoInput, "Inserisci un prezzo valido maggiore di 0.");
            return false;
        }
        showFieldError(prezzoInput, null);
        return true;
    }

   function validateMateriale() {
        if (!materialeInput) return true;
        if (!materialeInput.value.trim()) {
            showFieldError(materialeInput, "Il materiale è obbligatorio.");
            return false;
        }
        showFieldError(materialeInput, null);
        return true;
    }

    // Immagine OBBLIGATORIA (Form Nuovo Prodotto)
    function validateImmagineNuova() {
        if (!immagineNuovaInput) return true;
        if (immagineNuovaInput.files.length === 0) {
            showFieldError(immagineNuovaInput, "L'immagine del prodotto è obbligatoria.");
            return false;
        }
        showFieldError(immagineNuovaInput, null);
        return true;
    }

    // Immagine OPZIONALE (Form Modifica Prodotto)
    function validateImmagineModifica() {
        if (!immagineModificaInput) return true;
        // Non essendo obbligatoria in modifica, rimuoviamo sempre eventuali errori
        showFieldError(immagineModificaInput, null);
        return true;
    }

    // Validazione Colori (Primo colore e quantità obbligatori, i successivi opzionali)
    function validateColori() {
        if (coloreSelects.length === 0) return true; // Non siamo nel form di aggiunta

        let isValid = true;

        // 1° Colore (Obbligatorio)
        const primoColore = coloreSelects[0];
        const primaQta = quantitaInputs[0];

        if (!primoColore.value) {
            showFieldError(primoColore, "Devi selezionare almeno il primo colore.");
            isValid = false;
        } else {
            showFieldError(primoColore, null);
        }

        if (!primaQta.value.trim() || parseInt(primaQta.value) < 0) {
            showFieldError(primaQta, "Inserisci la quantità per il primo colore.");
            isValid = false;
        } else {
            showFieldError(primaQta, null);
        }

        // 2° e 3° Colore (Opzionali, ma se selezioni il colore la quantità diventa obbligatoria)
        for (let i = 1; i < coloreSelects.length; i++) {
            const select = coloreSelects[i];
            const qta = quantitaInputs[i];

            if (select.value && (!qta.value.trim() || parseInt(qta.value) < 0)) {
                showFieldError(qta, "Inserisci la quantità per questo colore.");
                isValid = false;
            } else {
                showFieldError(qta, null);
            }
        }

        return isValid;
    }

    // --- AGGANCIO EVENTI INPUT & BLUR ---

    const fields = [
        { el: marcaInput, fn: validateMarca },
        { el: modelloInput, fn: validateModello },
        { el: prezzoInput, fn: validatePrezzo },
        { el: materialeInput, fn: validateMateriale },
        { el: immagineNuovaInput, fn: validateImmagineNuova },
        { el: immagineModificaInput, fn: validateImmagineModifica }
    ];

    fields.forEach(item => {
        if (item.el) {
            item.el.addEventListener("input", item.fn);
            item.el.addEventListener("blur", item.fn);
            item.el.addEventListener("change", item.fn);
        }
    });

    coloreSelects.forEach(select => select.addEventListener("change", validateColori));
    quantitaInputs.forEach(input => {
        input.addEventListener("input", validateColori);
        input.addEventListener("blur", validateColori);
    });

    // --- CONTROLLO FINALE ALL'INVIO (SUBMIT) ---

    form.addEventListener("submit", function (event) {
        const vMarca = validateMarca();
        const vModello = validateModello();
        const vPrezzo = validatePrezzo();
        const vMateriale = validateMateriale();
        const vImgNuova = validateImmagineNuova();
        const vImgModifica = validateImmagineModifica();
        const vColori = validateColori();

        // Se anche una sola validazione fallisce, blocchiamo il submit
        if (!(vMarca && vModello && vPrezzo && vMateriale && vImgNuova && vImgModifica && vColori)) {
            event.preventDefault();
            event.stopPropagation();
        }
    });
});