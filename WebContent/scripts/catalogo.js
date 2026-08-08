document.addEventListener("DOMContentLoaded", () => {
    const filterForm = document.getElementById("filtri");
    const catalogContainer = document.getElementById("catalogoContainer"); // Il div che contiene i prodotti
	const btnReset = document.getElementById("btnResetFiltri"); // pulsante di reset
	
    if (!filterForm || !catalogoContainer) {
        console.error("Form 'filtri' o 'catalogoContainer' non trovati nel DOM.");
        return;
    }

    // Selezioniamo tutti gli input e select dentro il form 'catalogo'
    const filterInputs = filterForm.querySelectorAll("input, select");

    function applyFilters() {  //per applicare filtri
        const formData = new FormData(filterForm);
        const searchParams = new URLSearchParams(formData).toString();

        fetch(contextPath+ "/catalogo?" + searchParams, {
            headers: {
                "X-Requested-With": "XMLHttpRequest" // Per far capire alla Servlet che è una richiesta AJAX
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("Errore nella risposta della Servlet: " + response.status);
            }
            return response.text();
        })
        .then(html => {
            // Aggiorna solo la sezione dei prodotti!
            catalogContainer.innerHTML = html;
        })
        .catch(error => console.error("Errore durante il filtraggio:", error));
    }

    // Aggiungiamo l'evento a ogni campo del form
    filterInputs.forEach(input => {
        // 'input' per i campi di testo, 'change' per i select/dropdown
        input.addEventListener("input", applyFilters);
        input.addEventListener("change", applyFilters);
    });
	
	if (btnReset) {
	    btnReset.addEventListener("click", () => {

	        filterForm.reset();

	        // Svuota esplicitamente tutti i campi input text/number e resetta i select
	        filterInputs.forEach(input => {
	            // Mantiene eventuali campi hidden fondamentali (outlet o tipo) se presenti
	            if (input.type !== "hidden") {
	               if (input.tagName === "SELECT") {
	                    input.selectedIndex = 0;
	                } else {
	                    input.value = "";
	                }
	            }
	        });
        	applyFilters();
	    });
	}
	
});

