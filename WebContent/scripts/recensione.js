document.addEventListener("DOMContentLoaded", function() {
    const form = document.querySelector("form.review-form");
    if (!form) return;

    const votoSelect = document.getElementById("votoSelect");
    const descrizioneInput = document.getElementById("descrizioneInput");

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

    function validateVoto() {
        const val = votoSelect.value.trim();
        const voto = parseInt(val, 10);

        if (!val) {
            showFieldError(votoSelect, "La valutazione è obbligatoria.");
            return false;
        } else if (isNaN(voto) || voto < 1 || voto > 5 || !Number.isInteger(voto)) {
            showFieldError(votoSelect, "Seleziona una valutazione valida (da 1 a 5 stelle).");
            return false;
        }

        showFieldError(votoSelect, null);
        return true;
    }

    function validateDescrizione() {
        const val = descrizioneInput.value.trim();
        
        // Regex per vietare il carattere '='
        const regexSicura = /^[^=<>]+$/;

        if (!val) {
            showFieldError(descrizioneInput, "Il commento è obbligatorio.");
            return false;
        } else if (val.length < 5) {
            showFieldError(descrizioneInput, "Inserisci una descrizione di almeno 5 caratteri.");
            return false;
        } else if (!regexSicura.test(val)) {
            showFieldError(descrizioneInput, "Il testo non può contenere =, <, >.");
            return false;
        }

        showFieldError(descrizioneInput, null);
        return true;
    }

	if (votoSelect) {
	    votoSelect.addEventListener("change", validateVoto);
	    votoSelect.addEventListener("blur", validateVoto);
	}

	if (descrizioneInput) {
	    descrizioneInput.addEventListener("change", validateDescrizione);
	    descrizioneInput.addEventListener("blur", validateDescrizione);
	}

    form.addEventListener("submit", function(event) {
        try {
            const v1 = validateVoto();
            const v2 = validateDescrizione();

            if (!(v1 && v2)) {
                event.preventDefault();
            }
        } catch (e) {
            console.error("Errore durante la validazione della recensione:", e);
            event.preventDefault();
        }
    });
});