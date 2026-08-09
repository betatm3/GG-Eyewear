document.addEventListener("DOMContentLoaded", () => {
    // Recupero degli elementi principali del DOM necessari per il filtraggio
    const filterForm = document.getElementById("filtriOrdine");
    const ordiniContainer = document.getElementById("ordiniContainer"); // Div contenente la tabella degli ordini
    const btnReset = document.getElementById("btnResetFiltriOrdini");  

    if (!filterForm || !ordiniContainer) {
        console.error("Form 'formFiltriOrdini' o contenitore 'ordiniContainer' non trovati nel DOM.");
        return;
    }

    // Seleziona tutti i campi di input, select, date ed email 
    const filterInputs = filterForm.querySelectorAll("input, select");

	const regexEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	// Permette lettere (anche accentate), numeri, spazi, trattini, e-commerciale, punti e apostrofi
	const regexMarca = /^[a-zA-Z0-9À-ÿ\s'&\.-]{2,}$/;
	
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
		
        if (valMin !== null && valMin < 0) {
	        showFieldError(minInput, "Il prezzo min non può essere negativo.");
	        isValid = false;
	    }
        if (valMax !== null && valMax < 0) {
			showFieldError(maxInput, "Il prezzo max non può essere negativo.");
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
		
    // Invia la richiesta AJAX se i dati nel form sono validi
    function applyFilters() {
		
		if (!validateForm()) {	return; }
				
        // Serializza tutti i campi visibili e nascosti del form in un oggetto FormData
        const formData = new FormData(filterForm);
        // Converte i dati del form nel formato query string per la richiesta GET (es. ?genere=DA_SOLE&stato=SPEDITO)
        const searchParams = new URLSearchParams(formData).toString();

        // Esegue la chiamata HTTP asincrona verso l'endpoint degli ordini dell'Admin
        fetch(contextPath + "/admin/GestioneOrdini?" + searchParams, {
            headers: {
                // Header custom fondamentale per permettere alla Servlet di distinguere 
                // una richiesta AJAX da una ricarica completa della pagina
                "X-Requested-With": "XMLHttpRequest"
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("Errore nella risposta della Servlet Ordini: " + response.status);
            }
            return response.text(); // Legge la risposta HTML restituita dalla Servlet
        })
        .then(html => {
            // Aggiorna  solo la porzione di pagina contenente la tabella degli ordini
            ordiniContainer.innerHTML = html;
        })
        .catch(error => console.error("Errore durante il filtraggio degli ordini:", error));
    }

    // Associazione degli Event Listener ai campi di input
    filterInputs.forEach(input => {
		// 'change' fa partire i filtri solo dopo aver finito di scrivere (o quando si cambia una select)
		    input.addEventListener("change", applyFilters);
		    
		// 'blur' esegue solo la validazione grafica dell'errore quando si esce dal campo
		input.addEventListener("blur", () => validateForm());
    });

    // reset dei Filtri
    if (btnReset) {
        btnReset.addEventListener("click", () => {
            filterForm.reset();

            // Svuota esplicitamente tutti i campi (testo, date, numeri, select)
            filterInputs.forEach(input => {
                // Preserva eventuali input hidden di configurazione o sicurezza
                if (input.type !== "hidden") {
                    if (input.tagName === "SELECT") {
                        input.selectedIndex = 0; 
                    } else {
                        input.value = ""; 
                    }
                }
				// Rimuove messaggi d'errore residui
				showFieldError(input, null);
            });
            applyFilters();
        });
    }
});