document.addEventListener("DOMContentLoaded", function() {
    const form = document.querySelector("form[action='checkout']");
    if (!form) return;

    const indirizzoInput = document.getElementById("indirizzo");
    const cittaInput = document.getElementById("citta");
    const capInput = document.getElementById("cap");
    const telefonoInput = document.getElementById("telefono");
    const metodoPagamentoSelect = document.getElementById("metodoPagamento");

    
    const regexCitta = /^[a-zA-ZàèéìòùÀÈÉÌÒÙ\s']{2,50}$/;
    const regexCap = /^\d{5}$/;
    const regexTelefono = /^(\+39)?\s?\d{3}\s?\d{3}\s?\d{3,4}$/;

    function showFieldError(input, message) {
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

    function validateIndirizzo() {
        const val = indirizzoInput.value.trim();
        if (!val) {
            showFieldError(indirizzoInput, "L'indirizzo di spedizione è obbligatorio.");
            return false;
        } else if (val.length < 5) {
            showFieldError(indirizzoInput, "Inserisci un indirizzo valido (minimo 5 caratteri).");
            return false;
        }
        showFieldError(indirizzoInput, null);
        return true;
    }

    function validateCitta() {
        const val = cittaInput.value.trim();
        if (!val) {
            showFieldError(cittaInput, "La città è obbligatoria.");
            return false;
        } else if (!regexCitta.test(val)) {
            showFieldError(cittaInput, "Inserisci un nome di città valido.");
            return false;
        }
        showFieldError(cittaInput, null);
        return true;
    }

    function validateCap() {
        const val = capInput.value.trim();
        if (!val) {
            showFieldError(capInput, "Il CAP è obbligatorio.");
            return false;
        } else if (!regexCap.test(val)) {
            showFieldError(capInput, "Il CAP deve contenere esattamente 5 cifre numeriche (es. 80100).");
            return false;
        }
        showFieldError(capInput, null);
        return true;
    }

    function validateTelefono() {
        const val = telefonoInput.value.trim();
        if (!val) {
            showFieldError(telefonoInput, "Il recapito telefonico è obbligatorio.");
            return false;
        } else if (!regexTelefono.test(val)) {
            showFieldError(telefonoInput, "Inserisci un numero di cellulare valido (es. 3331234567).");
            return false;
        }
        showFieldError(telefonoInput, null);
        return true;
    }

    function validateMetodoPagamento() {
        const val = metodoPagamentoSelect.value;
        if (!val) {
            showFieldError(metodoPagamentoSelect, "Seleziona un metodo di pagamento.");
            return false;
        }
        showFieldError(metodoPagamentoSelect, null);
        return true;
    }

    if (indirizzoInput) {
        indirizzoInput.addEventListener("change", validateIndirizzo);
        indirizzoInput.addEventListener("blur", validateIndirizzo);
    }
    if (cittaInput) {
        cittaInput.addEventListener("change", validateCitta);
        cittaInput.addEventListener("blur", validateCitta);
    }
    if (capInput) {
        capInput.addEventListener("change", validateCap);
        capInput.addEventListener("blur", validateCap);
    }
    if (telefonoInput) {
        telefonoInput.addEventListener("change", validateTelefono);
        telefonoInput.addEventListener("blur", validateTelefono);
    }
    if (metodoPagamentoSelect) {
        metodoPagamentoSelect.addEventListener("change", validateMetodoPagamento);
        metodoPagamentoSelect.addEventListener("blur", validateMetodoPagamento);
    }

    form.addEventListener("submit", function(event) {
        const v1 = validateIndirizzo();
        const v2 = validateCitta();
        const v3 = validateCap();
        const v4 = validateTelefono();
        const v5 = validateMetodoPagamento();

        if (!(v1 && v2 && v3 && v4 && v5)) {
            event.preventDefault();
        }
    });
});
