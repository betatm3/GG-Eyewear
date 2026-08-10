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
import dao.DisponibileDAOImpl;

@WebServlet("/admin/GestioneProdotti")
@jakarta.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, 
    maxFileSize = 1024 * 1024 * 10,      
    maxRequestSize = 1024 * 1024 * 50    
)

public class GestioneProdottiAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

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
        int idOcchiale = Integer.parseInt(request.getParameter("id"));
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
        
        if (occhialeDAO.doDeleteLogica(idOcchiale)) {
        	request.setAttribute("msgSuccesso", "Prodotto disattivato con successo.");
        } else {
        	request.setAttribute("errore", "Impossibile disattivare il prodotto: ID non trovato.");
        }
        doGet(request, response);
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
            nuovoOcchiale.setTipo(Tipologia.valueOf(tipologiaStr.toUpperCase().trim()));
        } else {
            nuovoOcchiale.setTipo(Tipologia.DA_SOLE);
        }
        
        int generatedId = occhialeDAO.doSave(nuovoOcchiale);
        if (generatedId <= 0) {
        	request.setAttribute("errore", "Errore durante la creazione dell'occhiale nel database.");
            doGet(request, response);
            return; 
        }
        // Salvataggio delle immagini caricate
        try {
            ArrayList<String> pathImg = salvaImmagine(request, generatedId); //salva su pc
            if (pathImg != null) {
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
            primaVersione.setPrezzo(Double.parseDouble(prezzoStr.trim().replace(",", ".")));
        }
        
        String genereStr = request.getParameter("genere");
        if (genereStr != null && !genereStr.trim().isEmpty()) {
            primaVersione.setGenere(Genere.valueOf(genereStr.toUpperCase().trim()));
        }
        
        String montaturaStr = request.getParameter("montatura");
        if (montaturaStr != null && !montaturaStr.trim().isEmpty()) {
            primaVersione.setMontatura(Montatura.valueOf(montaturaStr.toUpperCase().trim()));
        }
        
        String tagliaStr = request.getParameter("taglia");
        if (tagliaStr != null && !tagliaStr.trim().isEmpty()) {
            primaVersione.setTaglia(Taglia.valueOf(tagliaStr.toUpperCase().trim()));
        }
        
        String formaStr = request.getParameter("forma");
        if (formaStr != null && !formaStr.trim().isEmpty()) {
            primaVersione.setForma(Forma.valueOf(formaStr.toUpperCase().trim()));
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
                    int quantita = Integer.parseInt(qtaStr);
                    
                    Colore c = new Colore();
                    c.setCodice(codiceColore);
                    
                    Disponibile d = new Disponibile ();
                    d.setColore(c);
                    d.setOcchiale(nuovoOcchiale);
                    d.setQuantita(quantita);
                    disponibileDAO.doSave(d);
                }
            }
        }
        
        request.setAttribute("msgSuccesso", "Nuovo prodotto inserito con successo!");
        doGet(request, response);
    }

    private void modificaCaratteristiche(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);

        // Recupero chiavi passate 
        int idOcchiale = Integer.parseInt(request.getParameter("idOcchiale"));
        int codiceVersione = Integer.parseInt(request.getParameter("codiceVersione"));

        // Recupero record correnti dal db
        Occhiale occhialeModificato = occhialeDAO.doRetrieveByKey(idOcchiale);
        VersioneOcchiale versioneVecchia = versioneDAO.doRetrieveByKey(codiceVersione, idOcchiale);
        VersioneOcchiale versioneModificata = versioneVecchia.clone();
        
        // --- AGGIORNAMENTO ATTRIBUTI OCCHIALE ---
        if (occhialeModificato != null && versioneModificata != null) {         
            
            String tipologiaStr = request.getParameter("tipologia");
            if (tipologiaStr != null && !tipologiaStr.trim().isEmpty()) {
                occhialeModificato.setTipo(Tipologia.valueOf(tipologiaStr.toUpperCase().trim()));
            }

            String attivoStr = request.getParameter("attivo");
            if (attivoStr != null && !attivoStr.trim().isEmpty()) {
                occhialeModificato.setAttivo(Boolean.parseBoolean(attivoStr));
            }

            try {
            	ArrayList<String> nuoveImmagini = salvaImmagine(request, idOcchiale);
            	if (nuoveImmagini != null && !nuoveImmagini.isEmpty()) {	
            		// Eliminazione vecchio file immagine se presente fisicamente in images/occhiali
	                ArrayList<String> vecchieImmagini = occhialeModificato.getImmagini();
	                
	                if (vecchieImmagini != null && !vecchieImmagini.isEmpty()) {
		                for(String oldPath : vecchieImmagini) {            
		                    if (oldPath != null && !oldPath.startsWith("http") && !oldPath.startsWith("data:")) {
		                        String oldFileName = Paths.get(oldPath).getFileName().toString();
		                    	
		                        // 1. Percorso temporaneo di Tomcat
		                        String uploadDir1 = getServletContext().getRealPath(File.separator + "images" + File.separator + "occhiali");
		                        File oldFileTomcat = new File(uploadDir1, oldFileName);
		                        if (oldFileTomcat.exists()) {
		                            oldFileTomcat.delete();
		                        }
		
		                        // 2. Percorso sorgente locale del progetto
		                        String uploadDir2 = "C:\\Users\\famig\\OneDrive\\Documenti\\GENNARO\\UNIVERSITA' G\\II ANNO\\TECNOLOGIE SOFTWARE PER WEB\\Progetto TSW\\Progetto_tsw\\WebContent\\images\\occhiali";
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
                versioneModificata.setPrezzo(Double.parseDouble(prezzoStr));
            }

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

            int nuovoCodice = versioneDAO.doSave(versioneModificata);
            versioneModificata.setCodice(nuovoCodice);
            versioneDAO.disattivaVersione(versioneVecchia);
        }

        request.setAttribute("msgSuccesso", "Caratteristiche del prodotto modificate con successo!");
        doGet(request, response);
    }

    private void gestisciVariantiColore(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        DisponibileDAOImpl disponibileDAO = new DisponibileDAOImpl(ds);

        int idOcchiale = Integer.parseInt(request.getParameter("idOcchiale"));
        String subAction = request.getParameter("subAction"); 
        String codiceColore = request.getParameter("codiceColore");
        Colore c = new Colore();
        Occhiale o = new Occhiale(); 
        c.setCodice(codiceColore);
        o.setId(idOcchiale);
                    
        Disponibile d = new Disponibile ();
        d.setColore(c);
        d.setOcchiale(o);
        
        if (subAction != null) {
            switch (subAction.toLowerCase()) {
                
	            case "addcolor":
	                int quantita = Integer.parseInt(request.getParameter("quantita"));
	                d.setQuantita(quantita);
	                disponibileDAO.doSave(d);
	                request.setAttribute("msgSuccesso", "Nuova variante colore aggiunta con successo!");
	                break;
	                
	            case "removecolor":
	                boolean eliminato = disponibileDAO.doDelete(idOcchiale, codiceColore);
	                if (eliminato) {
	                    request.setAttribute("msgSuccesso", "Variante colore rimossa con successo!");
	                } else {
	                    request.setAttribute("errore", "Impossibile rimuovere la variante colore: elemento non trovato.");
	                }
	                break;
	                
	            case "updatequantity":
	                int nuovaQuantita = Integer.parseInt(request.getParameter("quantita"));
	                d.setQuantita(nuovaQuantita);
	                disponibileDAO.doUpdate(d);
	                request.setAttribute("msgSuccesso", "Quantità aggiornata con successo!");
	                break;
                    
                default:
                	request.setAttribute("errore", "Sub-action colore non riconosciuta.");
                    return;
            }
        }
        doGet(request, response);
    }

    private ArrayList<String> salvaImmagine(HttpServletRequest request, int idOcchiale) throws Exception {
    	// realPath è il percorso assoluto dove Tomcat sta eseguendo l'applicazione web; punta a una cartella di build temporanea (es. .metadata/.plugins/.../wtpwebapps/TuoProgetto/images/occhiali).        
    	String uploadDir1 = getServletContext().getRealPath(File.separator + "images" + File.separator + "occhiali");
    	//per memorizzarla in locale
    	String uploadDir2 = "C:\\Users\\famig\\OneDrive\\Documenti\\GENNARO\\UNIVERSITA' G\\II ANNO\\TECNOLOGIE SOFTWARE PER WEB\\Progetto TSW\\Progetto_tsw\\WebContent\\images\\occhiali";
    	
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
	            
	            listaImg.add("images/occhiali/" + nomeFile);
        	}
        }
        return !listaImg.isEmpty() ? listaImg : null;
    }
    
}
