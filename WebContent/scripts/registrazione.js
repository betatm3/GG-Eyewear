document.addEventListener("DOMContentLoaded", function() {
    const form = document.querySelector("form[action='registrazione']");
    if (!form) return;

    const nomeInput = document.getElementById("nome");
    const cognomeInput = document.getElementById("cognome");
    const emailInput = document.getElementById("email");
    const passwordInput = document.getElementById("password");
    const confermaPasswordInput = document.getElementById("confermaPassword");
    const telefonoInput = document.getElementById("telefono");
    const dataNascitaInput = document.getElementById("dataNascita");
	const viaInput = document.getElementById('via');
	const civicoInput = document.getElementById('civico');
	const cittaInput = document.getElementById('citta');
	const capInput = document.getElementById('cap')

    
    const regexNomeCognome = /^[A-Za-zÀ-ÿ\s']{2,50}$/;
    const regexEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	const regexTelefono = /^(\+39)?\s?\d{3}\s?\d{3}\s?\d{3,4}$/;
	const regexPassword = /^(?=\S+$)(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,}$/;
	// password con almeno 8 caratteri, una maiuscola, un numero, un carattere speciale e nessun spazio
	const regexCivico = /^[0-9]{1,4}([a-zA-Z]|\s*-\s*[a-zA-Z0-9]+)?$/;
	// 1 a 4 cifre  + spazio o trattino + almeno un carattere o cifra (opzionali)
	const regexCitta = /^[A-Za-zÀ-ÿ\s'-]{2,50}$/;
	const regexCap = /^\d{5}$/;
    
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
	
	function showBannerError(message) {
	    const banner = document.getElementById("js-error-banner");
	    const bannerText = document.getElementById("js-error-text");
	    
	    if (banner && bannerText) {
	        if (message) {
	            bannerText.textContent = message;
	            banner.style.display = "flex"; // Mostra il banner
	        } else {
	            banner.style.display = "none";  // Nasconde il banner se non ci sono errori
	        }
	    }
	}
   
    function validateNome() {
        const val = nomeInput.value.trim();
        if (!val) {
            showFieldError(nomeInput, "Il nome è obbligatorio.");
            return false;
        } else if (!regexNomeCognome.test(val)) {
            showFieldError(nomeInput, "Il nome può contenere solo lettere (minimo 2 caratteri).");
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
            showFieldError(cognomeInput, "Il cognome può contenere solo lettere (minimo 2 caratteri).");
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
            showFieldError(emailInput, "Inserisci un indirizzo email valido (es. mario.rossi@email.it).");
            return false;
        }
        showFieldError(emailInput, null);
        return true;
    }

    function validatePassword() {
	    const val = passwordInput.value;
	    if (!val) {
	        showFieldError(passwordInput, "La password è obbligatoria.");
	        return false;
	    } else if (!regexPassword.test(val)) {
	        showFieldError(passwordInput, "La password deve contenere almeno 8 caratteri, una maiuscola, un numero, un carattere speciale e nessun spazio.");
	        return false;
	    }
	    showFieldError(passwordInput, null);
	    return true;
	}

    function validateConfermaPassword() {
        const pass = passwordInput.value;
        const conf = confermaPasswordInput.value;
        if (!conf) {
            showFieldError(confermaPasswordInput, "La conferma della password è obbligatoria.");
            return false;
		} else if (!regexPassword.test(conf)) {
	        showFieldError(confermaPasswordInput, "La password deve contenere almeno 8 caratteri, una maiuscola, un numero, un carattere speciale e nessun spazio.");
	        return false;
        } else if (pass !== conf) {
            showFieldError(confermaPasswordInput, "Le password non coincidono.");
            return false;
        }
        showFieldError(confermaPasswordInput, null);
        return true;
    }

   	function validateTelefono() {
	    let val = telefonoInput.value.trim();
	    
	    if (!val) {
	        showFieldError(telefonoInput, "Il numero di telefono è obbligatorio.");
	        return false;
	    } 

	    // Formattazione automatica in gruppi (es. 333 123 4567)
	    let haPrefisso = val.startsWith('+39');
	    let cifre = val.replace(/\D/g, '');

	    if (haPrefisso && cifre.startsWith('39')) {
	        cifre = cifre.substring(2);
	    }
	    if (cifre.length > 10) {
	        cifre = cifre.substring(0, 10);
	    }

	    let formattato = '';
	    if (haPrefisso) formattato += '+39 ';
	    if (cifre.length > 0) formattato += cifre.substring(0, 3);
	    if (cifre.length > 3) formattato += ' ' + cifre.substring(3, 6);
	    if (cifre.length > 6) formattato += ' ' + cifre.substring(6, 10);

	    // Aggiorna il valore visivo nell'input
	    telefonoInput.value = formattato;

	    if (!regexTelefono.test(telefonoInput.value.trim())) {
	        showFieldError(telefonoInput, "Inserisci un numero di cellulare valido (es. +39 333 123 4567 o 333 123 4567).");
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
        const dataNascita = new Date(val);
        const oggi = new Date();
        if (dataNascita >= oggi) {
            showFieldError(dataNascitaInput, "La data di nascita non può essere nel futuro.");
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
			showFieldError(civicoInput, "Numero civico non valido. (es. 12, 3B, 27 A)");
			return false;
		}
		showFieldError(civicoInput, null);
		return true;    
	}
	
	function validateCAP(){
		const capVal = capInput.value.trim();
		if (!capVal) {
			showFieldError(capInput, "Il CAP è obbligatorio.");
			return false;
		} else if (!regexCap.test(capVal)) {
			showFieldError(capInput, "Il CAP deve contenere esattamente 5 cifre.");
			return false;
		}
		showFieldError(capInput, null);
		return true;    
	}
	
	function validateCitta(){
		const cittaVal = cittaInput.value.trim();
		if (!cittaVal) {
			showFieldError(cittaInput, "La città è obbligatoria.");
			return false;
		} else if (!regexCitta.test(cittaVal)) {
			showFieldError(cittaInput, "Inserisci una città valida.");
			return false;
		}
		showFieldError(cittaInput, null);
		return true;
	}
 
    if (nomeInput) {
        nomeInput.addEventListener("change", validateNome);
        nomeInput.addEventListener("blur", validateNome);
    }
    if (cognomeInput) {
        cognomeInput.addEventListener("change", validateCognome);
        cognomeInput.addEventListener("blur", validateCognome);
    }
    if (emailInput) {
        emailInput.addEventListener("change", validateEmail);
        emailInput.addEventListener("blur", validateEmail);
    }
    if (passwordInput) {
        passwordInput.addEventListener("change", validatePassword);
        passwordInput.addEventListener("blur", validatePassword);
    }
    if (confermaPasswordInput) {
        confermaPasswordInput.addEventListener("change", validateConfermaPassword);
        confermaPasswordInput.addEventListener("blur", validateConfermaPassword);
    }
    if (telefonoInput) {
        telefonoInput.addEventListener("change", validateTelefono);
        telefonoInput.addEventListener("blur", validateTelefono);
    }
    if (dataNascitaInput) {
        dataNascitaInput.addEventListener("change", validateDataNascita);
        dataNascitaInput.addEventListener("blur", validateDataNascita);
    }
    if (viaInput) {
        viaInput.addEventListener("change", validateVia);
        viaInput.addEventListener("blur", validateVia);
    }
	if (civicoInput) {
		civicoInput.addEventListener("change", validateCivico);
	    civicoInput.addEventListener("blur", validateCivico);
	}
	if (capInput) {
		capInput.addEventListener("change", validateCAP);
		capInput.addEventListener("blur", validateCAP);
	}
	if (cittaInput) {
		cittaInput.addEventListener("change", validateCitta);
		cittaInput.addEventListener("blur", validateCitta);
	}

    
    form.addEventListener("submit", function(event) {
		try{
	        const v1 = validateNome();
	        const v2 = validateCognome();
	        const v3 = validateEmail();
	        const v4 = validatePassword();
	        const v5 = validateConfermaPassword();
	        const v6 = validateTelefono();
	        const v7 = validateDataNascita();
	        const v8 = validateVia();
			const v9 = validateCivico();
			const v10 = validateCAP();
			const v11 = validateCitta();
	
	        if (!(v1 && v2 && v3 && v4 && v5 && v6 && v7 && v8 && v9 && v10 && v11)) {
	            event.preventDefault();  //blocca invio form e mostra messaggi di errore
				showBannerError("Tutti i campi contrassegnati sono obbligatori o contengono errori.");
			} else {
				showBannerError(null); // Rimuove il banner se tutti i dati sono corretti
			}
		} catch (e) {
		    // in caso di errori imprevisti, blocchiamo l'invio per sicurezza
		    console.error("Errore durante la validazione:", e);
		    event.preventDefault();
		}
    });
});