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
    const indirizzoInput = document.getElementById("indirizzo");

    
    const regexNomeCognome = /^[A-Za-zÀ-ÿ\s']{2,50}$/;
    const regexEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	const regexTelefono = /^(\+39)?\s?\d{3}\s?\d{3}\s?\d{3,4}$/;
	const regexPassword = /^(?=\S+$)(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,}$/;
	    //msg: "La password deve contenere almeno 8 caratteri, una maiuscola, un numero, un carattere speciale e nessun spazio." 
	
    
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

	    // Controllo finale con la Regex
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

    function validateIndirizzo() {
        const val = indirizzoInput.value.trim();
        if (!val) {
            showFieldError(indirizzoInput, "L'indirizzo di spedizione è obbligatorio.");
            return false;
        } else if (val.length < 10) {
            showFieldError(indirizzoInput, "Inserisci un indirizzo valido (minimo 10 caratteri).");
            return false;
        }
        showFieldError(indirizzoInput, null);
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
    if (indirizzoInput) {
        indirizzoInput.addEventListener("change", validateIndirizzo);
        indirizzoInput.addEventListener("blur", validateIndirizzo);
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
	        const v8 = validateIndirizzo();
	
	        if (!(v1 && v2 && v3 && v4 && v5 && v6 && v7 && v8)) {
	            event.preventDefault();  //blocca l'invio del form e mostra i messaggi di errore
				showBannerError("Tutti i campi contrassegnati sono obbligatori o contengono errori.");
			} else {
				showBannerError(null); // Rimuove il banner se tutti i dati sono corretti
			}
		} catch (e) {
		    // Se c'è un errore imprevisto nel codice JS, blocchiamo comunque l'invio per sicurezza
		    console.error("Errore durante la validazione:", e);
		    event.preventDefault();
		}
    });
});