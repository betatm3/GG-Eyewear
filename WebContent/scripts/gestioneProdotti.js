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
    const newImg1Input = document.getElementById("immagine1");         // Form Aggiungi (Obbligatoria)
	const newImg2Input = document.getElementById("immagine2");         // Form Aggiungi (Obbligatoria)
	const modifyImg1Input = document.getElementById("edit_immagine1"); 
	const modifyImg2Input = document.getElementById("edit_immagine2"); 

    // Varianti Colore (Presenti solo nel form di Aggiunta)
    const coloreSelects = document.querySelectorAll("select[name='codiceColore']");
    const quantitaInputs = document.querySelectorAll("input[name='quantitaColore']");
	
    // Permette lettere, numeri, spazi, trattini, & e punti (minimo 2 caratteri)
    const regexTestoCampi = /^[a-zA-Z0-9À-ÿ\s&\.-]{2,}$/;
		
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
	
	// --- PULSANTI DI RIMOZIONE PER TUTTI I FILE ---
	    const fileWrappers = document.querySelectorAll(".file-input-wrapper");
	    fileWrappers.forEach(wrapper => {
	        const fileInput = wrapper.querySelector("input[type='file']");
	        const removeBtn = wrapper.querySelector(".btn-remove-simple");

	        if (fileInput && removeBtn) {
	            fileInput.addEventListener("change", () => {
	                if (fileInput.files && fileInput.files.length > 0) {
	                    removeBtn.style.display = "inline-block";
	                } else {
	                    removeBtn.style.display = "none";
	                }
	            });
				
				// Cliccando sulla X svuota l'input e nasconde la X
	            removeBtn.addEventListener("click", () => {
	                fileInput.value = "";
	                removeBtn.style.display = "none";

					// Notifica eventuali validazioni
	                fileInput.dispatchEvent(new Event("change"));
	            });
	        }
	    });

    // --- FUNZIONI DI VALIDAZIONE ---

    function validateMarca() {
        if (!marcaInput) return true;
		const val = marcaInput.value.trim();

        if (!val) {
            showFieldError(marcaInput, "La marca è obbligatoria.");
            return false;
        }
        if (val.length < 2) {
            showFieldError(marcaInput, "La marca deve contenere almeno 2 caratteri.");
            return false;
        }
        if (!regexTestoCampi.test(val)) {
            showFieldError(marcaInput, "Caratteri non validi (ammessi: lettere, numeri, -, &, .)");
            return false;
        }
        showFieldError(marcaInput, null);
        return true;
    }

    function validateModello() {
        if (!modelloInput) return true;
		const val = modelloInput.value.trim();

        if (!val) {
            showFieldError(modelloInput, "Il modello è obbligatorio.");
            return false;
        }
        if (val.length < 2) {
            showFieldError(modelloInput, "Il modello deve contenere almeno 2 caratteri.");
            return false;
        }
        if (!regexTestoCampi.test(val)) {
            showFieldError(modelloInput, "Caratteri non validi (ammessi: lettere, numeri, -, &, .)");
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
		const val = materialeInput.value.trim();

        if (!val) {
            showFieldError(materialeInput, "Il materiale è obbligatorio.");
            return false;
        }
        if (val.length < 2) {
            showFieldError(materialeInput, "Il materiale deve contenere almeno 2 caratteri.");
            return false;
        }
        if (!regexTestoCampi.test(val)) {
            showFieldError(materialeInput, "Caratteri non validi (ammessi: lettere, numeri, -, &, .)");
            return false;
        }
        showFieldError(materialeInput, null);
        return true;
    }

    // Immagine OBBLIGATORIA (Form Nuovo Prodotto)
    function validateImmagineNuova() {
        if (!newImg1Input || !newImg2Input) return true;
		
		const file1 = newImg1Input.files[0];
		const file2 = newImg2Input.files[0];
		const validTypes = ["image/jpeg", "image/png", "image/webp", "image/gif"];
		let isValid = true;
		
		if (!file1) {
            showFieldError(newImg1Input, "La prima immagine è obbligatoria.");
            isValid = false;
        } else if (!validTypes.includes(file1.type)) {
            showFieldError(newImg1Input, "Formato non valido (ammessi JPG, PNG, WEBP, GIF).");
            isValid = false;
        } else {
            showFieldError(newImg1Input, null);
        }
		
		if (!file2) {
            showFieldError(newImg2Input, "La seconda immagine è obbligatoria.");
            isValid = false;
        } else if (!validTypes.includes(file2.type)) {
            showFieldError(newImg2Input, "Formato non valido (ammessi JPG, PNG, WEBP, GIF).");
            retisValid = false;
        } else {
            showFieldError(newImg2Input, null);
        }
				
        return isValid;
    }

    // Immagine OPZIONALE (Form Modifica Prodotto)
    function validateImmagineModifica() {
        if (!modifyImg1Input|| !modifyImg2Input) return true;
		
		const file1 = modifyImg1Input.files[0];
		const file2 = modifyImg2Input.files[0];
		const validTypes = ["image/jpeg", "image/png", "image/webp", "image/gif"];

		// Entrambe vuote
        if (!file1 && !file2) {
            showFieldError(modifyImg1Input, null);
            showFieldError(modifyImg2Input, null);
            return true;
        }
		
		let isValid = true;
		// Se l'utente ha iniziato a cambiare le immagini, deve fornirle entrambe
        if (!file1) {
            showFieldError(modifyImg1Input, "Seleziona anche la prima immagine.");
            isValid = false;
        } else if (!validTypes.includes(file1.type)) {
            showFieldError(modifyImg1Input, "Formato non valido (ammessi JPG, PNG, WEBP, GIF).");
            isValid = false;
        } else {
            showFieldError(modifyImg1Input, null);
        }
		
		if (!file2) {
            showFieldError(modifyImg2Input, "Seleziona anche la seconda immagine.");
            isValid = false;
        } else if (!validTypes.includes(file2.type)) {
            showFieldError(modifyImg2Input, "Formato non valido (ammessi JPG, PNG, WEBP, GIF).");
            isValid = false;
        } else {
            showFieldError(modifyImg2Input, null);
        }

		return isValid;
    }

    // Validazione Colori (Primo colore e quantità obbligatori, i successivi opzionali)
	function validateColori() {
        if (coloreSelects.length === 0) return true;
        let almenoUnColoreValido = false;
        let isCoerente = true;

        coloreSelects.forEach((select, index) => {
       		const qtyInput = quantitaInputs[index];
       		const codColore = select.value.trim();
       		const qtaStr = qtyInput ? qtyInput.value.trim() : "";
       		const qtaNum = parseInt(qtaStr, 10);

       		// Se entrambi sono compilati
	   		if (codColore !== "" && qtaStr !== "") {
	       		if (isNaN(qtaNum) || qtaNum < 0) {
		       		showFieldError(qtyInput, "La quantità non può essere negativa.");
	           		isCoerente = false;
	       		} else {
	           		showFieldError(qtyInput, null);
               		showFieldError(select, null);
               		almenoUnColoreValido = true;
           		}
       		} 
       		// Se uno è compilato e l'altro no
       		else if (codColore !== "" && qtaStr === "") {
	   			showFieldError(qtyInput, "Inserisci la quantità per questo colore.");
				showFieldError(select, null);
	        	isCoerente = false;
      		} else if (codColore === "" && qtaStr !== "") {
	            showFieldError(select, "Seleziona il colore corrispondente.");
	            showFieldError(qtyInput, null);
	            isCoerente = false;
	        } else {
	            // Entrambi vuoti
	            showFieldError(select, null);
	            if (qtyInput) showFieldError(qtyInput, null);
	        }
	    });

        // Controlla se è stato impostato almeno un colore con la sua quantità
        if (!almenoUnColoreValido && isCoerente) {
            showFieldError(coloreSelects[0], "Seleziona almeno un colore con la relativa quantità.");
            return false;
        }
        return isCoerente && almenoUnColoreValido;
    }

    // --- AGGANCIO EVENTI INPUT & BLUR ---

    const fields = [
        { el: marcaInput, fn: validateMarca },
        { el: modelloInput, fn: validateModello },
        { el: prezzoInput, fn: validatePrezzo },
        { el: materialeInput, fn: validateMateriale },
		{ el: newImg1Input, fn: validateImmagineNuova },
        { el: newImg2Input, fn: validateImmagineNuova },
        { el: modifyImg1Input, fn: validateImmagineModifica },
        { el: modifyImg2Input, fn: validateImmagineModifica }
    ];

    fields.forEach(item => {
        if (item.el) {
            item.el.addEventListener("blur", item.fn);
            item.el.addEventListener("change", item.fn);
        }
    });

    coloreSelects.forEach(select => select.addEventListener("change", validateColori));
    quantitaInputs.forEach(input => {
        input.addEventListener("change", validateColori);
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
        }
    });
});