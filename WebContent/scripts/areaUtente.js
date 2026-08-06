//DOMContentLoaded: Aspetta che tutta la pagina HTML sia caricata prima di eseguire il codice.
//novalidate: Disabilita i messaggi di errore automatici del browser, lasciando il controllo totale al nostro script.

document.addEventListener("DOMContentLoaded", function() {
    const form = document.querySelector("form.edit-profile-form");
    if (!form) return;

    form.setAttribute("novalidate", "true");

    const nomeInput = document.getElementById("edit_nome");
    const cognomeInput = document.getElementById("edit_cognome");
    const emailInput = document.getElementById("edit_email");
    const telefonoInput = document.getElementById("edit_telefono");
    const dataNascitaInput = document.getElementById("edit_data_nascita");
    const indirizzoInput = document.getElementById("edit_indirizzo");
    
    const oldPasswordInput = document.getElementById("old_password");
    const newPasswordInput = document.getElementById("edit_password");
    const confermaPasswordInput = document.getElementById("conferma_password");

    const regexNomeCognome = /^[A-Za-zÀ-ÿ\s']{2,50}$/;
    const regexEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const regexTelefono = /^(\+39)?\s?\d{3}\s?\d{3}\s?\d{3,4}$/;
    const regexPassword = /^(?=\S+$)(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,}$/;
	

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

    function validateIndirizzo() {
        const val = indirizzoInput.value.trim();
        if (!val) {
            showFieldError(indirizzoInput, "L'indirizzo è obbligatorio.");
            return false;
        } else if (val.length < 10) {
            showFieldError(indirizzoInput, "Inserisci almeno 10 caratteri.");
            return false;
        }
        showFieldError(indirizzoInput, null);
        return true;
    }

    // --- GESTIONE PASSWORD OPZIONALI ---
    function validatePasswords() {
        const oldPass = oldPasswordInput ? oldPasswordInput.value : "";
        const newPass = newPasswordInput ? newPasswordInput.value : "";
        const confPass = confermaPasswordInput ? confermaPasswordInput.value : "";

        let isValid = true;

        // Se l'utente digita una nuova password, la vecchia password e la conferma diventano obbligatorie!
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

    // Listener eventi
    [nomeInput, cognomeInput, emailInput, telefonoInput, dataNascitaInput, indirizzoInput].forEach(input => {
        if (input) {
            input.addEventListener("change", () => {
                if(input === nomeInput) validateNome();
                if(input === cognomeInput) validateCognome();
                if(input === emailInput) validateEmail();
                if(input === telefonoInput) validateTelefono();
                if(input === dataNascitaInput) validateDataNascita();
                if(input === indirizzoInput) validateIndirizzo();
            });
            input.addEventListener("blur", () => {
                if(input === nomeInput) validateNome();
                if(input === cognomeInput) validateCognome();
                if(input === emailInput) validateEmail();
                if(input === telefonoInput) validateTelefono();
                if(input === dataNascitaInput) validateDataNascita();
                if(input === indirizzoInput) validateIndirizzo();
            });
        }
    });

    [oldPasswordInput, newPasswordInput, confermaPasswordInput].forEach(input => {
        if (input) {
            input.addEventListener("input", validatePasswords);
            input.addEventListener("blur", validatePasswords);
        }
    });

    // Controllo al Submit
    form.addEventListener("submit", function(event) {
		
        const v1 = validateNome();
        const v2 = validateCognome();
        const v3 = validateEmail();
        const v4 = validateTelefono();
        const v5 = validateDataNascita();
        const v6 = validateIndirizzo();
        const v7 = validatePasswords();

        if (!(v1 && v2 && v3 && v4 && v5 && v6 && v7)) {
            event.preventDefault();
        }
    });
});