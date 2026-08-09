document.addEventListener("DOMContentLoaded", () => {
    const filterForm = document.getElementById("filtriCatalogo");
    const catalogContainer = document.getElementById("catalogoContainer");
    const btnReset = document.getElementById("btnResetFiltri");

    if (!filterForm || !catalogContainer) {
        console.error("Form 'filtriCatalogo' o 'catalogoContainer' non trovati nel DOM.");
        return;
    }

    // Selezioniamo tutti gli input e select visibili
    const filterInputs = filterForm.querySelectorAll("input, select");
	// Applicazione di Tom Select ai 4 campi del form
    const selectSelectors = ["#filterForma", "#filterTaglia", "#filterMontatura", "#filterGenere"];
	
    const tomSelectConfig = {
        create: false,
        maxOptions: null,
        dropdownParent: "body",
        onChange: function() {
            applyFilters(); // Esegue la ricerca AJAX al cambio valore
        }
    };
 
    selectSelectors.forEach(selector => {
        const el = document.querySelector(selector);
        if (el) {
            new TomSelect(el, tomSelectConfig);
        }
    });
	
	// --- REGEX E LOGICA DI VALIDAZIONE ---
	// Permette lettere, numeri, spazi, trattini, . e ' (NO slash /)
	const regexTestoFiltri = /^[a-zA-Z0-9À-ÿ\s&\.-]{2,}$/;
	
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
        const input = filterForm.querySelector("#filterMarca");
        if (!input) return true;
        const val = input.value.trim();
        if (val) {
            if (val.length < 2) {
                showFieldError(input, "La marca deve contenere almeno 2 caratteri.");
                return false;
            }
            if (!regexTestoFiltri.test(val)) {
                showFieldError(input, "Caratteri non validi (ammessi: lettere, numeri, -, &, .)");
                return false;
            }
        }
        showFieldError(input, null);
        return true;
    }

    function validateMateriale() {
        const input = filterForm.querySelector("#filterMateriale");
        if (!input) return true;
        const val = input.value.trim();
        if (val) {
            if (val.length < 2) {
                showFieldError(input, "Il materiale deve contenere almeno 2 caratteri.");
                return false;
            }
            if (!regexTestoFiltri.test(val)) {
                showFieldError(input, "Caratteri non validi (ammessi: lettere, numeri, -, &, .)");
                return false;
            }
        }
        showFieldError(input, null);
        return true;
    }

    function validateColore() {
        const input = filterForm.querySelector("#filterColore");
        if (!input) return true;
        const val = input.value.trim();
        if (val) {
            if (val.length < 2) {
                showFieldError(input, "Il colore deve contenere almeno 2 caratteri.");
                return false;
            }
            if (!regexTestoFiltri.test(val)) {
                showFieldError(input, "Caratteri non validi (ammessi: lettere, numeri, -, &, .)");
                return false;
            }
        }
        showFieldError(input, null);
        return true;
    }

    function validatePrezzi() {
        const minInput = filterForm.querySelector("#filterPrezzoMin");
        const maxInput = filterForm.querySelector("#filterPrezzoMax");
        let isValid = true;
        
        const valMin = minInput && minInput.value !== "" ? parseFloat(minInput.value) : null;
        const valMax = maxInput && maxInput.value !== "" ? parseFloat(maxInput.value) : null;
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

    function validateForm() {
        const v1 = validateMarca();
        const v2 = validateMateriale();
        const v3 = validateColore();
        const v4 = validatePrezzi();

		return v1 && v2 && v3 && v4;
    }

    // Funzione per inviare i filtri via AJAX
    function applyFilters() {
		if (!validateForm()) {
			return;
		}
				
        const formData = new FormData(filterForm);
        const searchParams = new URLSearchParams(formData).toString();

        fetch(contextPath + "/catalogo?" + searchParams, {
            headers: {
                "X-Requested-With": "XMLHttpRequest"
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("Errore nella risposta della Servlet: " + response.status);
            }
            return response.text();
        })
        .then(html => {
            catalogContainer.innerHTML = html;
        })
        .catch(error => console.error("Errore durante il filtraggio:", error));
    }

    // Event listener per gli input di testo / numero
    filterInputs.forEach(input => {
        if (input.tagName !== "SELECT") {
            input.addEventListener("input", applyFilters);
            input.addEventListener("change", applyFilters);
        }
    });

    if (btnReset) {
        btnReset.addEventListener("click", () => {
            filterForm.reset();

            filterInputs.forEach(input => {
                if (input.type !== "hidden") {
                    if (input.tagName === "SELECT") {
                        // Se il select ha l'istanza di Tom Select, azzera la selezione grafica
                        if (input.tomselect) {
                            input.tomselect.clear();
                        }
                    } else {
                        input.value = "";
                    }
                }
            });

            applyFilters();
        });
    }
});

