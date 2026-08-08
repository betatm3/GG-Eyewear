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

    /**
     * Funzione principale che raccoglie i dati del form, costruisce la Query String
     * ed esegue la richiesta AJAX (fetch) verso la Servlet di Gestione Ordini.
     */
    function applyFilters() {
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
		// 'input' per i campi di testo, 'change' per i select/dropdown
        input.addEventListener("input", applyFilters);
        input.addEventListener("change", applyFilters);
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
            });
            applyFilters();
        });
    }
});