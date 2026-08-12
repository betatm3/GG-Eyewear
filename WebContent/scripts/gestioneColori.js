document.addEventListener("DOMContentLoaded", function () {
	
	const regexNewNomeColore = /^[a-zA-Z0-9À-ÿ\s&\.-]{2,}$/;
	const regexHexColor = /^#[0-9A-Fa-f]{6}$/;

	function showFieldError(input, message) {
	    if (!input) return;

	    // Individua il contenitore isolato per l'input
	    const parent = input.closest(".input-group-wrapper") || 
	                   input.closest(".field-wrapper") || 
	                   input.closest(".form-group") || 
	                   input.parentElement;

	    if (!parent) return;

	    // Cerca un messaggio d'errore preesistente dentro il genitore
	    let errorSpan = parent.querySelector(".error-msg");

	    if (message) {
	        if (!errorSpan) {
	            errorSpan = document.createElement("small");
	            errorSpan.className = "error-msg";
	            errorSpan.style.color = "#C86A55";
	            errorSpan.style.fontSize = "11px";
	            errorSpan.style.marginTop = "4px";
	            errorSpan.style.display = "block";
	            errorSpan.style.fontWeight = "500";
	            
	            // Inserisce l'errore sotto l'input
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

	function showContainerError(container, message) {
        if (!container) return;
        let errorSpan = container.querySelector(".container-error-msg");

        if (message) {
	        if (!errorSpan) {
                errorSpan = document.createElement("small");
                errorSpan.className = "container-error-msg";
                errorSpan.style.color = "#C86A55";
                errorSpan.style.fontSize = "12px";
                errorSpan.style.marginTop = "8px";
                errorSpan.style.display = "block";
                errorSpan.style.fontWeight = "500";
                container.appendChild(errorSpan);
            }
            errorSpan.textContent = message;
            container.style.borderColor = "#C86A55";
        } else {
            if (errorSpan) {
                errorSpan.remove();
            }
            container.style.borderColor = "#E2DDD5";
        }
    }
	
	// VALIDAZIONE PER LA MODIFICA QUANTITÀ ESISTENTI	
    function validateQuantitaSingola(input) {
        if (!input) return true;

        const val = input.value.trim();
        if (val === "") {
            showFieldError(input, "Inserisci la quantità.");
            return false;
        }
		
        const num = Number(val);
        if (isNaN(num) || num <= 0) {
            showFieldError(input, "Inserisci un valore positivo.");
            return false;
        }

        showFieldError(input, null);
        return true;
    }
	
	// AGGIORNAMENTO QUANTITÀ ESISTENTI (Card in alto)
	const updateQuantityForms = document.querySelectorAll("input[name='subAction'][value='updatequantity']");

    updateQuantityForms.forEach(	function (hiddenInput) {
	    const form = hiddenInput.closest("form");
	    if (!form) return;
        const inputQuantita = form.querySelector("input[name='quantita']");

        if (inputQuantita) {
            inputQuantita.addEventListener("change", function () {
                validateQuantitaSingola(inputQuantita);
            });
            inputQuantita.addEventListener("blur", function () {
                validateQuantitaSingola(inputQuantita);
            });
        }

        form.addEventListener("submit", function (event) {
            try {
                const isValid = validateQuantitaSingola(inputQuantita);
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
   
    // ASSOCIAZIONE NUOVO COLORE
    const addColorForm = document.getElementById("formAddColor");

    if (addColorForm) {
		const selectColore = addColorForm.querySelector("#nuovo_colore");
	    const inputNuovaQuantita = addColorForm.querySelector("#nuova_quantita");
        const newNomeColore = addColorForm.querySelector("#newNomeColore");
        const nuovoHexColore = addColorForm.querySelector("#nuovoHexColore");
        const newQtaColore = addColorForm.querySelector("#newQtaColore");
        const colorVariantsContainer = addColorForm.closest(".color-variants-container");
		
		function validateFormAddColor() {
	        let almenoUnOpzioneCompilata = false;
	        let isCoerente = true;
	
	        // --- A) COLORE DA CATALOGO ---
	        if (selectColore && inputNuovaQuantita) {
		        const codColore = selectColore.value.trim();
	            const qtaStr = inputNuovaQuantita.value.trim();
	            const qtaNum = parseInt(qtaStr, 10);
	
	            if (codColore !== "" && qtaStr !== "") {
		            if (isNaN(qtaNum) || qtaNum <= 0) {
	                    showFieldError(inputNuovaQuantita, "Inserisci un valore positivo.");
						showFieldError(selectColore, null);
	                    isCoerente = false;
	                } else {
	                    showFieldError(inputNuovaQuantita, null);
	                    showFieldError(selectColore, null);
	                    almenoUnOpzioneCompilata = true;
	                }
	            } else if (codColore !== "" && qtaStr === "") {
	                showFieldError(inputNuovaQuantita, "Inserisci la quantità per il colore selezionato.");
	                showFieldError(selectColore, null);
	                isCoerente = false;
	            } else if (codColore === "" && qtaStr !== "") {
	                showFieldError(selectColore, "Seleziona il colore dal catalogo.");
	                showFieldError(inputNuovaQuantita, null);
	                isCoerente = false;
	            } else {
	                showFieldError(selectColore, null);
	                showFieldError(inputNuovaQuantita, null);
	            }
	        }
	
	        // --- B) NUOVO COLORE AL CATALOGO ---
	        if (newNomeColore && newQtaColore) {
	            const nomeVal = newNomeColore.value.trim();
	            const qtaNuovoStr = newQtaColore.value.trim();
	            const qtaNuovoNum = parseInt(qtaNuovoStr, 10);
	            const hexVal = nuovoHexColore ? nuovoHexColore.value.trim() : "";
	
	            if (nomeVal !== "" || qtaNuovoStr !== "") {
	                let nuovoValido = true;
					// Validazione Nome
			        if (nomeVal === "") {
		                showFieldError(newNomeColore, "Inserisci il nome del nuovo colore.");
	                    nuovoValido = false;
	                    isCoerente = false;
	                } else if (nomeVal.length < 2) {
	                    showFieldError(newNomeColore, "Il nome deve contenere almeno 2 caratteri.");
	                    nuovoValido = false;
	                    isCoerente = false;
	                } else if (!regexNewNomeColore.test(nomeVal)) {
	                    showFieldError(newNomeColore, "Caratteri non validi (ammessi: lettere, numeri, -, &, .)");
	                    nuovoValido = false;
	                    isCoerente = false;
	                } else {
	                	showFieldError(newNomeColore, null);
	                }
	
	                // Validazione HEX
	                if (nuovoHexColore) {
	                    if (!regexHexColor.test(hexVal)) {
	                        showFieldError(nuovoHexColore, "Formato colore HEX non valido (es. #FF0000).");
	                        nuovoValido = false;
	                        isCoerente = false;
	                    } else {
	                        showFieldError(nuovoHexColore, null);
	                    }
	                }
	                // Validazione Quantità
	                if (qtaNuovoStr === "") {
	                    showFieldError(newQtaColore, "Inserisci la quantità per il nuovo colore.");
	                    nuovoValido = false;
	                    isCoerente = false;
	                } else if (isNaN(qtaNuovoNum) || qtaNuovoNum <= 0) {
	                    showFieldError(newQtaColore, "Inserisci un valore positivo.");
	                    nuovoValido = false;
	                    isCoerente = false;
	                } else {
	                    showFieldError(newQtaColore, null);
	                }
	                if (nuovoValido) {
	                    almenoUnOpzioneCompilata = true;
	                }
	            } else {
	                // Nessun campo compilato per il nuovo colore
	                showFieldError(newNomeColore, null);
	                if (nuovoHexColore) showFieldError(nuovoHexColore, null);
	                showFieldError(newQtaColore, null);
	            }
	        }
	
	        // --- C) VERIFICA ALMENO UN'OPZIONE SELEZIONATA ---
	        if (!almenoUnOpzioneCompilata && isCoerente) {
		        showContainerError(colorVariantsContainer, "Seleziona un colore dal catalogo oppure creane uno nuovo inserendo la quantità.");
	            return false;
	        } else {
	            showContainerError(colorVariantsContainer, null);
	        }
	
	        return isCoerente && almenoUnOpzioneCompilata;
	    }

    	// Collegamento eventi agli input
		const addColorFields = [
            selectColore,
            inputNuovaQuantita,
            newNomeColore,
            nuovoHexColore,
            newQtaColore
        ];

        addColorFields.forEach(el => {
            if (el) {
                el.addEventListener("change", validateFormAddColor);
                el.addEventListener("blur", validateFormAddColor);
            }
        });

        // Submit Nuovo Colore
        addColorForm.addEventListener("submit", function (event) {
            try {
                const isValid = validateFormAddColor();
                if (!isValid) {
                    event.preventDefault();
                }
            } catch (e) {
                console.error("Errore durante la validazione dell'associazione colore:", e);
                event.preventDefault();
            }
        });
    }
});