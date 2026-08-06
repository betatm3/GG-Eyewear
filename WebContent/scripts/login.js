document.addEventListener("DOMContentLoaded", function() {
    const form = document.querySelector("form[action='login']");
    if (!form) return;

    const emailInput = document.getElementById("email");
    const passwordInput = document.getElementById("password");

    
    const regexEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

	
	function showBannerError(message) {
	    const banner = document.getElementById("js-error-banner");
	    const bannerText = document.getElementById("js-error-text");
	        
	    if (banner && bannerText) {
	        if (message) {
	            bannerText.textContent = message;
	            banner.style.display = "flex"; // Mostra il banner
	        } else {
	            banner.style.display = "none";  // Nasconde il banner
	        }
	    }
	}
		
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
        }
        showFieldError(passwordInput, null);
        return true;
    }

    if (emailInput) {
        emailInput.addEventListener("change", validateEmail);
        emailInput.addEventListener("blur", validateEmail);
    }
    if (passwordInput) {
        passwordInput.addEventListener("change", validatePassword);
        passwordInput.addEventListener("blur", validatePassword);
    }

    form.addEventListener("submit", function(event) {
        const v1 = validateEmail();
        const v2 = validatePassword();

		if (!(v1 && v2)) {
		    event.preventDefault(); // Blocca l'invio del form
		    showBannerError("Inserisci i dati obbligatori correttamente.");
		 } else {
		     //Nasconde il banner prima dell'invio se tutto è OK
		     showBannerError(null);
		 }
    });
});
