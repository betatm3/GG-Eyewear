package control.admin;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import javax.sql.DataSource;

import model.Colore;
import model.Disponibile;
import model.Forma;
import model.Genere;
import model.Montatura;
import model.Occhiale;
import model.Taglia;
import model.Tipologia;
import model.VersioneOcchiale;
import dao.OcchialeDAOImpl;
import dao.VersioneOcchialeDAOImpl;
import dao.ColoreDAOImpl;
import dao.DisponibileDAOImpl;

@WebServlet("/admin/GestioneProdotti")
@jakarta.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,	// 2MB
    maxFileSize = 1024 * 1024 * 10,      	// 10 MB
    maxRequestSize = 1024 * 1024 * 50    	// 50 MB
)

public class GestioneProdottiAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	
    	HttpSession session = request.getSession(false);
        if (session != null) {
            if (session.getAttribute("msgSuccesso") != null) {
                request.setAttribute("msgSuccesso", session.getAttribute("msgSuccesso"));
                session.removeAttribute("msgSuccesso");
            }
            if (session.getAttribute("errore") != null) {
                request.setAttribute("errore", session.getAttribute("errore"));
                session.removeAttribute("errore");
            }
        }

        try {           
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/admin/gestioneProdotti.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel caricamento dei dati.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Azione mancante.");
            return;
        }

        try {
            switch (action.toLowerCase()) {
                case "add":
                    aggiungiNuovoProdotto(request, response);
                    break;
                case "updatecaratteristiche":
                    modificaCaratteristiche(request, response);
                    break;
                case "updatecolori":
                    gestisciVariantiColore(request, response);
                    break;
                case "delete":
                    rimuoviOcchialeLogico(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Azione non riconosciuta.");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errore", "Errore durante l'operazione sul database: " + e.getMessage());
            doGet(request, response);
        }
    }

    // --- METODI PRIVATI DI SUPPORTO ---

    private void rimuoviOcchialeLogico(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
    	try {
	    	int idOcchiale = Integer.parseInt(request.getParameter("id"));
	        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
	        
	        if (occhialeDAO.doDeleteLogica(idOcchiale)) {
	            request.getSession().setAttribute("msgSuccesso", "Prodotto disattivato con successo.");
	        } else {
	            request.getSession().setAttribute("errore", "Impossibile disattivare il prodotto: ID non trovato.");
	        }
    	} catch (NumberFormatException e) {
            request.getSession().setAttribute("errore", "ID prodotto non valido.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
    }

    private void aggiungiNuovoProdotto(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);
        DisponibileDAOImpl disponibileDAO = new DisponibileDAOImpl(ds); // Inizializziamo il DAO per la tabella ponte
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
        
        // Creazione e popolamento dell'oggetto OCCHIALE
        Occhiale nuovoOcchiale = new Occhiale();
        nuovoOcchiale.setAttivo(true);
        
        String tipologiaStr = request.getParameter("tipologia");
        if (tipologiaStr != null && !tipologiaStr.trim().isEmpty()) {
        	try {
                nuovoOcchiale.setTipo(Tipologia.valueOf(tipologiaStr.toUpperCase().trim()));
            } catch (IllegalArgumentException e) {
	            request.getSession().setAttribute("errore", "Errore! Tipologia occhiale vuota o non valida.");
	            response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
	            return;
            }
        } else {
        	request.getSession().setAttribute("errore", "Errore! Tipologia occhiale vuota o non valida.");
            response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
            return;
        }
        
        int generatedId = occhialeDAO.doSave(nuovoOcchiale);
        if (generatedId <= 0) {
        	request.getSession().setAttribute("errore", "Errore durante la creazione dell'occhiale nel database.");
            response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
            return; 
        }
        // Salvataggio delle immagini caricate
        try {
            ArrayList<String> pathImg = salvaImmagine(request, generatedId); //salva su pc
            if (pathImg != null && !pathImg.isEmpty()) {
                nuovoOcchiale.setImmagini(pathImg);
                occhialeDAO.doUpdate(nuovoOcchiale);  // salva nel db
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 2. Creazione e popolamento dell'oggetto VERSIONEOCCHIALE
        VersioneOcchiale primaVersione = new VersioneOcchiale();
        primaVersione.setCodice(1);
        primaVersione.setCorrente(true);
        primaVersione.setMarca(request.getParameter("marca"));
        primaVersione.setModello(request.getParameter("modello"));
        primaVersione.setMateriale(request.getParameter("materiale"));
        
        String prezzoStr = request.getParameter("prezzo");
        if (prezzoStr != null && !prezzoStr.trim().isEmpty()) {
        	try {
                primaVersione.setPrezzo(Double.parseDouble(prezzoStr.trim().replace(",", ".")));
            } catch (NumberFormatException ignored) {
            	request.getSession().setAttribute("errore", "Prezzo inserito non valido.");
                response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
                return;
            }
        }
        
        try {
            String genereStr = request.getParameter("genere");
            if (genereStr != null && !genereStr.trim().isEmpty()) primaVersione.setGenere(Genere.valueOf(genereStr.toUpperCase().trim()));
            
            String montaturaStr = request.getParameter("montatura");
            if (montaturaStr != null && !montaturaStr.trim().isEmpty()) primaVersione.setMontatura(Montatura.valueOf(montaturaStr.toUpperCase().trim()));
            
            String tagliaStr = request.getParameter("taglia");
            if (tagliaStr != null && !tagliaStr.trim().isEmpty()) primaVersione.setTaglia(Taglia.valueOf(tagliaStr.toUpperCase().trim()));
            
            String formaStr = request.getParameter("forma");
            if (formaStr != null && !formaStr.trim().isEmpty()) primaVersione.setForma(Forma.valueOf(formaStr.toUpperCase().trim()));
        } catch (IllegalArgumentException ignored) {
        	request.getSession().setAttribute("errore", "Campi forma, taglia, genere o montantura non validi.");
            response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
            return;
        }
        
        primaVersione.setOcchiale(nuovoOcchiale); 
        versioneDAO.doSave(primaVersione);

        //AGGIUNTA DEI COLORI E QUANTITÀ 

        String[] codiciColori = request.getParameterValues("codiceColore");
        String[] quantitaColori = request.getParameterValues("quantitaColore");

        
        if (codiciColori != null && quantitaColori != null && codiciColori.length == quantitaColori.length) {
            for (int i = 0; i < codiciColori.length; i++) {
                String codiceColore = codiciColori[i];
                String qtaStr = quantitaColori[i];

                if (codiceColore != null && !codiceColore.trim().isEmpty() && qtaStr != null && !qtaStr.trim().isEmpty()) {
                    
                    try {
                    	int quantita = Integer.parseInt(qtaStr);
	                    Colore c = new Colore();
	                    c.setCodice(codiceColore);
	                    
	                    Disponibile d = new Disponibile ();
	                    d.setColore(c);
	                    d.setOcchiale(nuovoOcchiale);
	                    d.setQuantita(quantita);
	                    disponibileDAO.doSave(d);
                    } catch (NumberFormatException ignored) {
                    	request.getSession().setAttribute("errore", "Errore! Quantità inserita non valida.");
                        response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
                        return;
                    }
                }
            }
        }
        
        request.getSession().setAttribute("msgSuccesso", "Nuovo prodotto inserito con successo!");
        response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
    }

    private void modificaCaratteristiche(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);

        // Recupero chiavi passate 
        int idOcchiale;
        int codiceVersione; 

        try {
            idOcchiale = Integer.parseInt(request.getParameter("idOcchiale"));
            codiceVersione = Integer.parseInt(request.getParameter("codiceVersione"));
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errore", "Identificativi prodotto non validi.");
            response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
            return;
        }
        
        // Recupero record correnti dal db
        Occhiale occhialeModificato = occhialeDAO.doRetrieveByKey(idOcchiale);
        VersioneOcchiale versioneVecchia = versioneDAO.doRetrieveByKey(codiceVersione, idOcchiale);
        
        
        // --- AGGIORNAMENTO ATTRIBUTI OCCHIALE ---
        if (occhialeModificato != null && versioneVecchia != null) {         
        	VersioneOcchiale versioneModificata = versioneVecchia.clone();
        	
            String tipologiaStr = request.getParameter("tipologia");
            if (tipologiaStr != null && !tipologiaStr.trim().isEmpty()) {
                try{
	            	occhialeModificato.setTipo(Tipologia.valueOf(tipologiaStr.toUpperCase().trim()));
	            } catch (IllegalArgumentException ignored) {
	            	request.getSession().setAttribute("errore", "Errore! Tipologia non valida.");
	                response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
	                return;
	            }
            }

            String attivoStr = request.getParameter("attivo");
            if (attivoStr != null && !attivoStr.trim().isEmpty()) {
                occhialeModificato.setAttivo(Boolean.parseBoolean(attivoStr));
            }

            try {
            	ArrayList<String> nuoveImmagini = salvaImmagine(request, idOcchiale);
            	if (nuoveImmagini != null && !nuoveImmagini.isEmpty()) {	
            		// Eliminazione vecchio file immagine se presente fisicamente in uploads/occhiali
	                ArrayList<String> vecchieImmagini = occhialeModificato.getImmagini();
	                
	                if (vecchieImmagini != null && !vecchieImmagini.isEmpty()) {
		                for(String oldPath : vecchieImmagini) {            
		                    if (oldPath != null && !oldPath.startsWith("http") && !oldPath.startsWith("data:")) {
		                        String oldFileName = Paths.get(oldPath).getFileName().toString();
		                    	
		                        // 1. Percorso temporaneo di Tomcat
		                        String uploadDir1 = getServletContext().getRealPath(File.separator + "uploads" + File.separator + "occhiali");
		                        File oldFileTomcat = new File(uploadDir1, oldFileName);
		                        if (oldFileTomcat.exists()) {
		                            oldFileTomcat.delete();
		                        }
		
		                        // 2. Percorso sorgente locale del progetto
		                        String uploadDir2 = "C:\\Users\\percorso_privato\\uploads\\occhiali";
		                        File oldFileLocale = new File(uploadDir2, oldFileName);
		                        if (oldFileLocale.exists()) {
		                            oldFileLocale.delete();
		                        }
		                    }                    
		                }
	                }
	                occhialeModificato.setImmagini(nuoveImmagini); 
            	}
            } catch (Exception e) {
                e.printStackTrace();
            }

            occhialeDAO.doUpdate(occhialeModificato);

            // --- AGGIORNAMENTO ATTRIBUTI VERSIONEOCCHIALE ---
            
            versioneModificata.setMarca(request.getParameter("marca"));
            versioneModificata.setModello(request.getParameter("modello"));
            versioneModificata.setMateriale(request.getParameter("materiale"));

            String prezzoStr = request.getParameter("prezzo");
            if (prezzoStr != null && !prezzoStr.trim().isEmpty()) {
                try {
                    double prezzoParsed = Double.parseDouble(prezzoStr.trim().replace(",", "."));
                    versioneModificata.setPrezzo(prezzoParsed);
                } catch (NumberFormatException e) {
                	request.getSession().setAttribute("errore", "Formato prezzo non valido. Usa valori numerici es. 120.50");
                    response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
                    return;
                }
            }

            try {
	            String genereStr = request.getParameter("genere");
	            if (genereStr != null && !genereStr.trim().isEmpty()) {
	                versioneModificata.setGenere(Genere.valueOf(genereStr.toUpperCase().trim()));
	            }
	
	            String montaturaStr = request.getParameter("montatura");
	            if (montaturaStr != null && !montaturaStr.trim().isEmpty()) {
	                versioneModificata.setMontatura(Montatura.valueOf(montaturaStr.toUpperCase().trim()));
	            }
	            
	            String tagliaStr = request.getParameter("taglia");
	            if (tagliaStr != null && !tagliaStr.trim().isEmpty()) {
	                versioneModificata.setTaglia(Taglia.valueOf(tagliaStr.toUpperCase().trim()));
	            }
	            
	            String formaStr = request.getParameter("forma");
	            if (formaStr != null && !formaStr.trim().isEmpty()) {
	            	versioneModificata.setForma(Forma.valueOf(formaStr.toUpperCase().trim()));
	            }
            } catch (IllegalArgumentException ignored) {
            	request.getSession().setAttribute("errore", "Campi forma, taglia, genere o montantura non validi.");
                response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
                return;
            }
            int nuovoCodice = versioneDAO.doSave(versioneModificata);
            versioneModificata.setCodice(nuovoCodice);
            versioneDAO.disattivaVersione(versioneVecchia);
            
            request.getSession().setAttribute("msgSuccesso", "Caratteristiche del prodotto modificate con successo!");

        }else {
            request.getSession().setAttribute("errore", "Prodotto o versione non trovata.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
    }

    private void gestisciVariantiColore(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        DisponibileDAOImpl disponibileDAO = new DisponibileDAOImpl(ds);
        ColoreDAOImpl coloreDAO = new ColoreDAOImpl(ds);
        
        String idStr = request.getParameter("idOcchiale");
        if (idStr == null || idStr.trim().isEmpty()) {
        	request.getSession().setAttribute("errore", "ID Occhiale non fornito.");
            response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
            return;
        }
        int idOcchiale;
        try {
            idOcchiale = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errore", "ID Occhiale non valido.");
            response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
            return;
        }
        
        String subAction = request.getParameter("subAction"); 
        
        if (subAction != null) {
            switch (subAction.toLowerCase().trim()) {
                
	            case "addcolor":
	            	String codiceColore = request.getParameter("codiceColore");
	                String qtaCatalogStr = request.getParameter("quantita");

	                String newNomeColore = request.getParameter("newNomeColore");
	                String newHexColore = request.getParameter("newHexColore");
	                String newQtaStr = request.getParameter("newQtaColore");
	            	
	                // --- Colore da Catalogo ---
	                if (codiceColore != null && !codiceColore.trim().isEmpty() && qtaCatalogStr != null && !qtaCatalogStr.trim().isEmpty()) {
	                	try {
		                	int qta = Integer.parseInt(qtaCatalogStr.trim());
		                    
		                    Occhiale o = new Occhiale();
		                    o.setId(idOcchiale);
		                    Colore c = new Colore();
		                    c.setCodice(codiceColore);
	
		                    Disponibile d = new Disponibile();
		                    d.setOcchiale(o);
		                    d.setColore(c);
		                    d.setQuantita(qta);
	
		                    disponibileDAO.doSave(d);
		                    request.getSession().setAttribute("msgSuccesso", "Variante dal catalogo associata con successo!");
	                	}catch (NumberFormatException e) {
                            request.getSession().setAttribute("errore", "Quantità non valida.");
                        }
	                } 
	                // --- Creazione Nuovo Colore ---
	                else if (newNomeColore != null && !newNomeColore.trim().isEmpty() && newQtaStr != null && !newQtaStr.trim().isEmpty()) {
	                	try {
		                	int newQta = Integer.parseInt(newQtaStr.trim());
		                    
		                    String codiceGenerato = generaCodiceColore(newNomeColore.trim());
		                    Colore nuovoColore = new Colore();
		                    nuovoColore.setNome(newNomeColore.trim());
		                    nuovoColore.setHex(newHexColore != null ? newHexColore.trim() : "#000000");
		                    nuovoColore.setCodice(codiceGenerato);
		                    coloreDAO.doSave(nuovoColore);
	
		                    Occhiale o = new Occhiale();
		                    o.setId(idOcchiale);
	
		                    Disponibile d = new Disponibile();
		                    d.setOcchiale(o);
		                    d.setColore(nuovoColore);
		                    d.setQuantita(newQta);
	
		                    if (disponibileDAO.doSave(d)) {
			                    request.getSession().setAttribute("msgSuccesso", "Nuovo colore inserito a catalogo ed associato con successo!");
		                    } else {
		                        request.getSession().setAttribute("errore", "Impossibile associare la variante dal catalogo.");
		                    }
	                	} catch (NumberFormatException e) {
                            request.getSession().setAttribute("errore", "Quantità per il nuovo colore non valida.");
                        }
	                }else {
	                    request.getSession().setAttribute("errore", "Compilare un'opzione valida per aggiungere la variante colore.");
	                }
	                break;
	                
	            case "removecolor":
	            	String codColoreRemove = request.getParameter("codiceColore");
	                if (disponibileDAO.doDelete(idOcchiale, codColoreRemove)) {
	                    request.getSession().setAttribute("msgSuccesso", "Variante colore rimossa con successo!");
	                } else {
	                    request.getSession().setAttribute("errore", "Impossibile rimuovere la variante colore: elemento non trovato.");
	                }
	                break;
	                
	            case "updatequantity":
	            	String codColoreUpdate = request.getParameter("codiceColore");
	            	String qtaUpdateStr = request.getParameter("quantita");
	            	
	            	try {
		                int nuovaQuantita = Integer.parseInt(qtaUpdateStr.trim());
		                Occhiale o = new Occhiale();
		                o.setId(idOcchiale);
		                Colore c = new Colore();
		                c.setCodice(codColoreUpdate);
	
		                Disponibile d = new Disponibile();
		                d.setOcchiale(o);
		                d.setColore(c);
		                d.setQuantita(nuovaQuantita);
		                
		                boolean aggiornato = disponibileDAO.doUpdate(d);
		                if (aggiornato) {
		                    request.setAttribute("msgSuccesso", "Quantità aggiornata con successo!");
		                } else {
		                    request.setAttribute("errore", "Impossibile aggiornare la quantità: variante non trovata.");
		                }
	            	}catch (NumberFormatException e) {
                        request.getSession().setAttribute("errore", "Quantità specificata non valida.");
                    }
	                break;
                    
                default:
                	request.getSession().setAttribute("errore", "Azione variante colore non riconosciuta.");
                    break;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti");
    }

    private ArrayList<String> salvaImmagine(HttpServletRequest request, int idOcchiale) throws Exception {
    	// realPath è il percorso assoluto dove Tomcat sta eseguendo l'applicazione web; punta a una cartella di build temporanea (es. .metadata/.plugins/.../wtpwebapps/TuoProgetto/images/occhiali).        
    	String uploadDir1 = getServletContext().getRealPath(File.separator + "uploads" + File.separator + "occhiali");
    	//per memorizzarla in locale
    	String uploadDir2 = "C:\\Users\\percorso_privato\\uploads\\occhiali";
    	
    	File folder1 = new File(uploadDir1);
        if (!folder1.exists()) folder1.mkdirs();
        
        File folder2 = new File(uploadDir2);
        if (!folder2.exists()) folder2.mkdirs();

        ArrayList<String> listaImg = new ArrayList<>();
        String[] nomiParametri = {"immagine1", "immagine2"};
        
        for (int i = 0; i < nomiParametri.length; i++) {
        	Part part = request.getPart(nomiParametri[i]);
        
        	if (part != null && part.getSize() > 0 
                && part.getSubmittedFileName() != null 
                && !part.getSubmittedFileName().isBlank()) {

	            String nomeOriginale = Paths.get(part.getSubmittedFileName()).getFileName().toString();
	
	            String estensione = "";
	            int dotIndex = nomeOriginale.lastIndexOf('.');
	            if (dotIndex > 0) {
	                estensione = nomeOriginale.substring(dotIndex);
	            }
	            
	            String nomeFile = "immagine_" + idOcchiale + "_" + (i + 1) + "_" + System.currentTimeMillis() + estensione;
	            
	            // Uso pulito delle classi Path, Paths e Files senza il prefisso del pacchetto
	            Path pathLocale = Paths.get(uploadDir2, nomeFile);
	            Path pathTomcat = Paths.get(uploadDir1, nomeFile);
	
	            // Scrittura del file nella cartella di lavoro
	            part.write(pathLocale.toString());
	
	            // Copia nella cartella di esecuzione Tomcat
	            Files.copy(pathLocale, pathTomcat, StandardCopyOption.REPLACE_EXISTING);
	            
	            listaImg.add("uploads/occhiali/" + nomeFile);
        	}
        }
        return !listaImg.isEmpty() ? listaImg : null;
    }
    
    private String generaCodiceColore(String nomeColore) {
        if (nomeColore == null || nomeColore.trim().isEmpty()) {
            nomeColore = "COLORE";
        }

        String pulito = nomeColore.trim().toUpperCase()
                .replaceAll("[ÀÁÂÃÄÅ]", "A")
                .replaceAll("[ÈÉÊË]", "E")
                .replaceAll("[ÌÍÎÏ]", "I")
                .replaceAll("[ÒÓÔÕÖ]", "O")
                .replaceAll("[ÙÚÛÜ]", "U")
                .replaceAll("[^A-Z0-9]", "_")  // sostituisce spazi e caratteri non alfanumerici con '_'
                .replaceAll("_+", "_")         // rimuove underscore doppi/multipli
        		.replaceAll("^_+|_+$", "");// per eventuali underscore a inizio/fine stringa

        // Tronca il nome se troppo lungo
        if (pulito.length() > 12) {
            pulito = pulito.substring(0, 12);
        }

        // Genera suffisso di 3 caratteri alfanumerici univoci
        String caratteri = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder suffisso = new StringBuilder(3);
        java.util.Random rnd = new java.util.Random();
        for (int i = 0; i < 3; i++) {
            suffisso.append(caratteri.charAt(rnd.nextInt(caratteri.length())));
        }

        return "C_" + pulito + "_" + suffisso.toString();
    }
    
}
