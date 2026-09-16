//DOMContentLoaded: Aspetta che tutta la pagina HTML sia caricata prima di eseguire il codice.
document.addEventListener("DOMContentLoaded", function() {
	const form = document.querySelector("form[action*='area-utente']");
    if (!form) return;

    form.setAttribute("novalidate", "true");

    const nomeInput = document.getElementById("edit_nome");
    const cognomeInput = document.getElementById("edit_cognome");
    const emailInput = document.getElementById("edit_email");
    const telefonoInput = document.getElementById("edit_telefono");
    const dataNascitaInput = document.getElementById("edit_data_nascita");
	const viaInput = document.getElementById('edit_via');
	const civicoInput = document.getElementById('edit_civico');
	const cittaInput = document.getElementById('edit_citta');
	const capInput = document.getElementById('edit_cap');    
    
	const oldPasswordInput = document.getElementById("old_password");
    const newPasswordInput = document.getElementById("edit_password");
    const confermaPasswordInput = document.getElementById("conferma_password");

    const regexNomeCognome = /^[A-Za-zÀ-ÿ\s']{2,50}$/;
    const regexEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const regexTelefono = /^(\+39)?\s?\d{3}\s?\d{3}\s?\d{3,4}$/;
    const regexPassword = /^(?=\S+$)(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,}$/;
	const regexCivico = /^[a-zA-Z0-9\s/\\-]{1,10}$/;
	const regexCitta = /^[A-Za-zÀ-ÿ\s'-]{2,50}$/;
	const regexCap = /^\d{5}$/;
	
	const closeBtn = document.querySelector("#js-error-banner .close-banner-btn");
	if (closeBtn) {
	    closeBtn.addEventListener("click", function() {
	        showBannerError(null); // nasconde banner
	    });
	}

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
	
	function showBannerError(message) {
	    const banner = document.getElementById("js-error-banner");
	    const bannerText = document.getElementById("js-error-text");
	    
	    if (banner && bannerText) {
	        if (message) {
	            bannerText.textContent = message;
	            banner.style.display = "flex"; // Mostra banner
	        } else {
	            banner.style.display = "none";  // Nasconde banner se non ci sono errori
	        }
	    }
	}

    function validateNome() {
        const val = nomeInput.value.trim();
        if (!val) {
            showFieldError(nomeInput, "Il nome è obbligatorio.");
            return false;
        } else if (!regexNomeCognome.test(val)) {
            showFieldError(nomeInput, "Il nome può contenere solo lettere (minimo 2).");
            return false;
        }
        showFieldError(nomeInput, null);
        return true;
    }

    function validateCognome() {
        const val = cognomeInput.value.trim();
        if (!val) {
            showFieldError(cognomeInput, "Il cognome è obbligatorio.");
            return false;
        } else if (!regexNomeCognome.test(val)) {
            showFieldError(cognomeInput, "Il cognome può contenere solo lettere (minimo 2).");
            return false;
        }
        showFieldError(cognomeInput, null);
        return true;
    }

    function validateEmail() {
        const val = emailInput.value.trim();
        if (!val) {
            showFieldError(emailInput, "L'email è obbligatoria.");
            return false;
        } else if (!regexEmail.test(val)) {
            showFieldError(emailInput, "Inserisci un'email valida (es. mario.rossi@email.it).");
            return false;
        }
        showFieldError(emailInput, null);
        return true;
    }

    function validateTelefono() {
        let val = telefonoInput.value.trim();
        if (!val) {
            showFieldError(telefonoInput, "Il numero di telefono è obbligatorio.");
            return false;
        }

        let haPrefisso = val.startsWith('+39');
        let cifre = val.replace(/\D/g, '');

        if (haPrefisso && cifre.startsWith('39')) cifre = cifre.substring(2);
        if (cifre.length > 10) cifre = cifre.substring(0, 10);

        let formattato = '';
        if (haPrefisso) formattato += '+39 ';
        if (cifre.length > 0) formattato += cifre.substring(0, 3);
        if (cifre.length > 3) formattato += ' ' + cifre.substring(3, 6);
        if (cifre.length > 6) formattato += ' ' + cifre.substring(6, 10);

        telefonoInput.value = formattato;

        if (!regexTelefono.test(telefonoInput.value.trim())) {
            showFieldError(telefonoInput, "Numero di telefono non valido (es. +39 333 123 4567 o 333 123 4567).");
            return false;
        }

        showFieldError(telefonoInput, null);
        return true;
    }

    function validateDataNascita() {
        const val = dataNascitaInput.value;
        if (!val) {
            showFieldError(dataNascitaInput, "La data di nascita è obbligatoria.");
            return false;
        }
        if (new Date(val) >= new Date()) {
            showFieldError(dataNascitaInput, "La data non può essere nel futuro.");
            return false;
        }
        showFieldError(dataNascitaInput, null);
        return true;
    }

	function validateVia(){
		const viaVal = viaInput.value.trim();
		if (!viaVal) {
			showFieldError(viaInput, "La via è obbligatoria.");
			return false;
		} else if (viaVal.length < 4) {
			showFieldError(viaInput, "Inserisci una via valida (almeno 4 caratteri).");
			return false;
		}
		showFieldError(viaInput, null);
		return true;	    
	}
		
	function validateCivico(){
		const civicoVal = civicoInput.value.trim();
		if (!civicoVal) {
			showFieldError(civicoInput, "Il civico è obbligatorio.");
			return false;
		} else if (!regexCivico.test(civicoVal)) {
			showFieldError(civicoInput, "Numero civico non valido.");
			return false;
		}
		showFieldError(civicoInput, null);
		return true;    
	}

	function validateCitta() {
		const val = cittaInput.value.trim();
	    if (!val) {
	    	showFieldError(cittaInput, "La città è obbligatoria.");
	        return false;
	    } else if (!regexCitta.test(val)) {
	    	showFieldError(cittaInput, "Il campo può contenere solo lettere (minimo 2)");
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
			showFieldError(capInput, "Il CAP deve contenere esattamente 5 cifre.");
			return false;
		}
		showFieldError(capInput, null);
		return true;
	}

    // --- GESTIONE PASSWORD OPZIONALI ---
    function validatePasswords() {
        const oldPass = oldPasswordInput ? oldPasswordInput.value : "";
        const newPass = newPasswordInput ? newPasswordInput.value : "";
        const confPass = confermaPasswordInput ? confermaPasswordInput.value : "";

        let isValid = true;

        // Se l'utente digita una nuova password, la vecchia password e la conferma diventano obbligatorie
        if (newPass.length > 0) {
            if (!oldPass) {
                showFieldError(oldPasswordInput, "Inserisci la vecchia password per autorizzare il cambio.");
                isValid = false;
            } else {
                showFieldError(oldPasswordInput, null);
            }

            if (!regexPassword.test(newPass)) {
                showFieldError(newPasswordInput, "La nuova password deve contenere 8 caratteri, una maiuscola, un numero, un carattere speciale e nessun spazio.");
                isValid = false;
            } else {
                showFieldError(newPasswordInput, null);
            }

            if (!confPass) {
                showFieldError(confermaPasswordInput, "Conferma la nuova password.");
                isValid = false;
			} else if (!regexPassword.test(confPass)) {
				showFieldError(confermaPasswordInput, "La password deve contenere almeno 8 caratteri, una maiuscola, un numero, un carattere speciale e nessun spazio.");
			    isValid = false;
            } else if (newPass !== confPass) {
                showFieldError(confermaPasswordInput, "Le password non coincidono.");
                isValid = false;
            } else {
                showFieldError(confermaPasswordInput, null);
            }
        } else {
            // Se non vuole cambiare la password, rimuoviamo ogni errore
            showFieldError(oldPasswordInput, null);
            showFieldError(newPasswordInput, null);
            showFieldError(confermaPasswordInput, null);
        }

        return isValid;
    }

	const fieldMap = [
		{ el: nomeInput, fn: validateNome },
	    { el: cognomeInput, fn: validateCognome },
	    { el: emailInput, fn: validateEmail },
	    { el: telefonoInput, fn: validateTelefono },
	    { el: dataNascitaInput, fn: validateDataNascita },
	    { el: viaInput, fn: validateVia },
	    { el: civicoInput, fn: validateCivico },
	    { el: capInput, fn: validateCap },
	    { el: cittaInput, fn: validateCitta }
	];

	fieldMap.forEach(({ el, fn }) => {
		if (el) {
	    	el.addEventListener("change", fn);
	        el.addEventListener("blur", fn);
		}
	});

	[oldPasswordInput, newPasswordInput, confermaPasswordInput].forEach(input => {
		if (input) {
			input.addEventListener("change", validatePasswords);
			input.addEventListener("blur", validatePasswords);
		}
	});

    form.addEventListener("submit", function(event) {
		try{
        const v1 = validateNome();
	        const v2 = validateCognome();
	        const v3 = validateEmail();
	        const v4 = validateTelefono();
	        const v5 = validateDataNascita();
	        const v6 = validatePasswords();
			const v7 = validateVia();
			const v8 = validateCivico();
			const v9 = validateCap();
			const v10 = validateCitta();
	
	        if (!(v1 && v2 && v3 && v4 && v5 && v6 && v7 && v8 && v9 && v10)) {
	            event.preventDefault();
	  			showBannerError("Tutti i campi contrassegnati sono obbligatori o contengono errori.");
			} else {
			    showBannerError(null); // Rimuove banner se i dati sono corretti
			}
		} catch (e) {
			// In caso di errore imprevisto nel codice JS, blocchiamo l'invio per sicurezza
			console.error("Errore durante la validazione:", e);
			event.preventDefault();
		}
    });
});