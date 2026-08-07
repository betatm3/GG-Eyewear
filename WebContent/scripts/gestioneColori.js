document.addEventListener("DOMContentLoaded", function () {

    // 1. HELPER ERROR
    function showFieldError(input, message) {
        if (!input) return;

        // Identifica se l'input è dentro una card beige o dentro un normale form-group (#formAddColor)
        const cardContainer = input.closest(".color-update-form");
        const isCard = !!cardContainer;

        const parent = isCard ? cardContainer : (input.closest(".form-group") || input.parentElement);
        if (!parent) return;

        // Cerca l'elemento errore esistente
		        let errorSpan = null;
		        if (isCard) {
		            const nextEl = cardContainer.nextElementSibling;
		            if (nextEl && nextEl.classList && nextEl.classList.contains("error-msg-external")) {
		                errorSpan = nextEl;
		            }
		        } else {
		            errorSpan = parent.querySelector(".error-msg");
		        }

        if (message) {
            if (!errorSpan) {
                errorSpan = document.createElement("small");
                errorSpan.className = isCard ? "error-msg error-msg-external" : "error-msg";
                errorSpan.style.color = "#C86A55";
                errorSpan.style.fontSize = "12px";
                errorSpan.style.marginTop = isCard ? "6px" : "4px";
                errorSpan.style.display = "block";
                errorSpan.style.fontWeight = "500";

                if (isCard) {
                    cardContainer.after(errorSpan);
                } else {
                    parent.appendChild(errorSpan);
                }
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

    // 2. FUNZIONI DI VALIDAZIONE
    function validateQuantitaInput(input) {
        if (!input) return true;

        const val = input.value.trim();
        if (val === "") {
            showFieldError(input, "Inserisci la quantità.");
            return false;
        }
		
        const num = Number(val);
        if (isNaN(num) || num <= 0) {
            showFieldError(input, "La quantità deve essere positiva.");
            return false;
        }

        showFieldError(input, null);
        return true;
    }

    function validateSelectColore(select) {
        if (!select) return true;

        const val = select.value.trim();
        if (!val) {
            showFieldError(select, "Seleziona un colore obbligatorio.");
            return false;
        }

        showFieldError(select, null);
        return true;
    }

    // 3. AGGIORNAMENTO QUANTITÀ ESISTENTI
    const updateQuantityForms = document.querySelectorAll("form[action*='subAction=updatequantity']");

    updateQuantityForms.forEach(function (form) {
        const inputQuantita = form.querySelector("input[name='quantita']");

        if (inputQuantita) {
            inputQuantita.addEventListener("change", function () {
                validateQuantitaInput(inputQuantita);
            });
            inputQuantita.addEventListener("blur", function () {
                validateQuantitaInput(inputQuantita);
            });
        }

        form.addEventListener("submit", function (event) {
            try {
                const isValid = validateQuantitaInput(inputQuantita);
                if (!isValid) {
                    event.preventDefault();
                    if (inputQuantita) inputQuantita.focus();
                }
            } catch (e) {
                console.error("Errore durante la validazione quantità:", e);
                event.preventDefault();
            }
        });
    });

    // 4. ASSOCIAZIONE NUOVO COLORE
    const addColorForm = document.getElementById("formAddColor");

    if (addColorForm) {
        const selectColore = addColorForm.querySelector("#nuovo_colore");
        const inputNuovaQuantita = addColorForm.querySelector("#nuova_quantita");

        // Eventi Selezione Colore
        if (selectColore) {
            selectColore.addEventListener("change", function () {
                validateSelectColore(selectColore);
            });
            selectColore.addEventListener("blur", function () {
                validateSelectColore(selectColore);
            });
        }

        // Eventi Quantità Iniziale
        if (inputNuovaQuantita) {
            inputNuovaQuantita.addEventListener("change", function () {
                validateQuantitaInput(inputNuovaQuantita);
            });
            inputNuovaQuantita.addEventListener("blur", function () {
                validateQuantitaInput(inputNuovaQuantita);
            });
        }

        // Submit Form Nuovo Colore
        addColorForm.addEventListener("submit", function (event) {
            try {
                const v1 = validateSelectColore(selectColore);
                const v2 = validateQuantitaInput(inputNuovaQuantita);

                if (!(v1 && v2)) {
                    event.preventDefault();
                    if (!v1 && selectColore) {
                        selectColore.focus();
                    } else if (!v2 && inputNuovaQuantita) {
                        inputNuovaQuantita.focus();
                    }
                }
            } catch (e) {
                console.error("Errore durante la validazione associazione colore:", e);
                event.preventDefault();
            }
        });
    }

});