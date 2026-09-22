document.addEventListener("DOMContentLoaded", () => {
    // Recupero elementi del DOM necessari per il filtraggio
    const filterForm = document.getElementById("filtriOrdine");
    const ordiniContainer = document.getElementById("ordiniContainer"); 
	const btnReset = document.getElementById("btnResetFiltriOrdini");  

    if (!filterForm || !ordiniContainer) {
        console.error("Form 'formFiltriOrdini' o contenitore 'ordiniContainer' non trovati nel DOM.");
        return;
    }

    // Seleziona tutti i campi di input, select, date ed email 
    const filterInputs = filterForm.querySelectorAll("input, select");

	const regexEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	// Permette lettere (anche accentate), numeri, spazi, trattini, e-commerciale, punti e apostrofi
	const regexMarca = /^[a-zA-Z0-9À-ÿ\s&\.-]{2,}$/;

		function showFieldError(input, message) {
	    let parent = input.parentElement;
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
		
    function validateMarca() {
        const input = filterForm.querySelector("input[name='marca']");
        if (!input) return true;
        const val = input.value.trim();
		if (val) {
		    if (val.length < 2) {
		        showFieldError(input, "La marca deve contenere almeno 2 caratteri.");
		        return false;
		    }
		    if (!regexMarca.test(val)) {
		        showFieldError(input, "Caratteri non validi (ammessi: lettere, numeri, -, &, .)");
		        return false;
		    }
		}
        showFieldError(input, null);
        return true;
    }

	function validateEmail() {
	    const input = filterForm.querySelector("input[name='emailUtente']");
	    if (!input) return true;
	    const val = input.value.trim();
	    if (val && !regexEmail.test(val)) {
	        showFieldError(input, "Inserisci un'email valida (es. mario@email.it)");
	        return false;
	    }
		showFieldError(input, null);
	    return true;
	}

	function validatePrezzi() {
	    const minInput = filterForm.querySelector("input[name='prezzoMin']");
	    const maxInput = filterForm.querySelector("input[name='prezzoMax']");
	    let isValid = true;
	    const valMin = minInput && minInput.value !== "" ? parseFloat(minInput.value) : null;
	    const valMax = maxInput && maxInput.value !== "" ? parseFloat(maxInput.value) : null;
        // Reset errori sui prezzi
	    if (minInput) showFieldError(minInput, null);
	    if (maxInput) showFieldError(maxInput, null);
		
        if (valMin !== null && valMin <= 0) {
	        showFieldError(minInput, "Il valore deve essere positivo.");
	        isValid = false;
	    }
        if (valMax !== null && valMax <= 0) {
			showFieldError(maxInput, "Il valore deve essere positivo.");
	        isValid = false;
	    }
		
	    if (isValid && valMin !== null && valMax !== null && valMin > valMax) {
			showFieldError(maxInput, "Il min non può superare il max.");
			showFieldError(minInput, "Il min non può superare il max.");
	        isValid = false;
	    }
		    return isValid;
	}

	function validateDate() {
        const inizioInput = filterForm.querySelector("input[name='dataInizio']");
        const fineInput = filterForm.querySelector("input[name='dataFine']");
        let isValid = true;

		const valInizio = inizioInput ? inizioInput.value : "";
		const valFine = fineInput ? fineInput.value : "";

        if (inizioInput) showFieldError(inizioInput, null);
        if (fineInput) showFieldError(fineInput, null);

        if (valInizio && valFine) {
            const dInizio = new Date(valInizio);
            const dFine = new Date(valFine);
	        if (dInizio > dFine) {
		        showFieldError(inizioInput, "Data inizio successiva a data fine.");
		        isValid = false;
		    }
	    }

	    return isValid;
	}

    function validateForm() {
        const v1 = validateMarca();
        const v2 = validateEmail();
        const v3 = validatePrezzi();
        const v4 = validateDate();

        return v1 && v2 && v3 && v4;
    }
		
    function applyFilters() {
		
		if (!validateForm()) {	return; }
				
        // Serializza tutti i campi in un oggetto FormData
        const formData = new FormData(filterForm);
        // Converte in query string
        const searchParams = new URLSearchParams(formData).toString();

        fetch(contextPath + "/admin/GestioneOrdini?" + searchParams, {
            headers: {
                "X-Requested-With": "XMLHttpRequest"
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("Errore nella risposta della Servlet Ordini: " + response.status);
            }
            return response.text(); // legge risposta HTML restituita dalla Servlet
        })
        .then(html => {
            ordiniContainer.innerHTML = html;
        })
        .catch(error => console.error("Errore durante il filtraggio degli ordini:", error));
    }

    filterInputs.forEach(input => {
		input.addEventListener("change", applyFilters);
		input.addEventListener("blur", () => validateForm());
    });

    // reset filtri
    if (btnReset) {
        btnReset.addEventListener("click", () => {
            filterForm.reset();

            filterInputs.forEach(input => {
                if (input.type !== "hidden") {
                    if (input.tagName === "SELECT") {
                        input.selectedIndex = 0; 
                    } else {
                        input.value = ""; 
                    }
                }
				// Rimuove messaggi d'errore
				showFieldError(input, null);
            });
            applyFilters();
        });
    }
	
	// Dettagli ordine
	ordiniContainer.addEventListener("click", (event) => {
		const orderRow = event.target.closest(".order-row");
	    if (!orderRow) return;

	    // Impedisce espansione/compressione se si clicca su controlli interattivi
	    if (event.target.closest(".status-form") || 
	    	event.target.tagName === "SELECT" || 
	        event.target.tagName === "BUTTON" || 
	        event.target.tagName === "INPUT") {
	        return;
	    }

	    const orderCard = orderRow.closest(".order-card");
	    if (orderCard) {
	    	orderCard.classList.toggle("expanded");
	    }
	});
});