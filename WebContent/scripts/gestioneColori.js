document.addEventListener("DOMContentLoaded", function () {

    // =========================================================
    // 1. VALIDAZIONE FORM: AGGIORNAMENTO QUANTITÀ ESISTENTI
    // =========================================================
	const updateQuantityForms = document.getElementById("formUpdateeQuantity");
    
    updateQuantityForms.forEach(function (form) {
        form.addEventListener("submit", function (event) {
            const inputQuantita = form.querySelector("input[name='quantita']");
            const valQuantita = inputQuantita ? inputQuantita.value.trim() : "";

            // Controlla se il campo è vuoto
            if (valQuantita === "") {
                event.preventDefault();
                alert("Attenzione: Inserire un valore per la quantità.");
                inputQuantita.focus();
                return;
            }

            const quantitaNum = Number(valQuantita);

            // Controlla se è un numero valido e non negativo
            if (isNaN(quantitaNum) || quantitaNum < 0) {
                event.preventDefault();
                alert("Attenzione: La quantità non può essere negativa.");
                inputQuantita.focus();
                return;
            }
        });
    });

    // =========================================================
    // 2. VALIDAZIONE FORM: ASSOCIAZIONE NUOVO COLORE
    // =========================================================
    const addColorForm = document.getElementById("formAddColor");

    if (addColorForm) {
        addColorForm.addEventListener("submit", function (event) {
            const selectColore = addColorForm.querySelector("#nuovo_colore");
            const inputNuovaQuantita = addColorForm.querySelector("#nuova_quantita");

            const valColore = selectColore ? selectColore.value.trim() : "";
            const valQuantita = inputNuovaQuantita ? inputNuovaQuantita.value.trim() : "";

            // 1. Validazione Selezione Colore (obbligatorio)
            if (valColore === "") {
                event.preventDefault();
                alert("Attenzione: È obbligatorio selezionare un colore prima di procedere.");
                selectColore.focus();
                return;
            }

            // 2. Validazione Quantità Iniziale (obbligatorio)
            if (valQuantita === "") {
                event.preventDefault();
                alert("Attenzione: Il campo Quantità Iniziale è obbligatorio.");
                inputNuovaQuantita.focus();
                return;
            }

            const quantitaNum = Number(valQuantita);

            // 3. Validazione valore numerico non negativo
            if (isNaN(quantitaNum) || quantitaNum < 0) {
                event.preventDefault();
                alert("Attenzione: La quantità iniziale non può essere un valore negativo.");
                inputNuovaQuantita.focus();
                return;
            }
        });
    }

});