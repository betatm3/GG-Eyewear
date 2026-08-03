package control.admin;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import model.Colore;
import model.Disponibile;
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
        
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
        response.setHeader("Pragma", "no-cache"); 
        response.setDateHeader("Expires", 0); 

        String action = request.getParameter("action");

        try {
            if (action != null && action.equalsIgnoreCase("delete")) {
                rimuoviOcchialeLogico(request, response);
                return;
            }
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/admin/gestioneProdotti.jsp");
            dispatcher.forward(request, response);
            
        } catch (SQLException e) {
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
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Azione non riconosciuta.");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore durante l'operazione sul database: " + e.getMessage());
        }
    }

    // --- METODI PRIVATI DI SUPPORTO ---

    private void rimuoviOcchialeLogico(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int idOcchiale = Integer.parseInt(request.getParameter("id"));
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
        
        if (occhialeDAO.doDeleteLogica(idOcchiale)) {
            response.sendRedirect(request.getContextPath() + "/admin/GestioneProdotti?msg=ProdottoDisattivato");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Impossibile disattivare il prodotto: ID non trovato.");
        }
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
        nuovoOcchiale.setId(generatedId);

        // Salvataggio dell'immagine caricata
        try {
            String pathImg = salvaImmagine(request, generatedId);
            if (pathImg != null) {
                nuovoOcchiale.addImmagine(pathImg);
                occhialeDAO.doUpdate(nuovoOcchiale);
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
        primaVersione.setForma(request.getParameter("forma"));
        
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
        
        response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=ProdottoInserito");
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
                String pathImg = salvaImmagine(request, idOcchiale);
                if (pathImg != null) {
                    // Eliminazione vecchio file immagine se presente fisicamente in images/occhiali
                    String oldPath = (occhialeModificato.getImmagini() != null && !occhialeModificato.getImmagini().isEmpty())
                                     ? occhialeModificato.getImmagini().get(0) : null;
                    if (oldPath != null && !oldPath.startsWith("http") && !oldPath.startsWith("data:")) {
                        String uploadDir = getServletContext().getRealPath(java.io.File.separator + "images" + java.io.File.separator + "occhiali");
                        String oldFileName = java.nio.file.Paths.get(oldPath).getFileName().toString();
                        java.io.File oldFile = new java.io.File(uploadDir, oldFileName);
                        if (oldFile.exists()) {
                            oldFile.delete();  //rimuove fisicamente
                        }
                    }
                    // 2. Imposta il nuovo percorso calcolato nell'oggetto Java
                    java.util.ArrayList<String> nuoveImmagini = new java.util.ArrayList<>();
                    nuoveImmagini.add(pathImg);
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
            versioneModificata.setForma(request.getParameter("forma"));

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

            int nuovoCodice = versioneDAO.doSave(versioneModificata);
            versioneModificata.setCodice(nuovoCodice);
            versioneDAO.disattivaVersione(versioneVecchia);
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=ProdottoModificato");
    }

    private void gestisciVariantiColore(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
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
                    break;
                    
                case "removecolor":
                	disponibileDAO.doDelete(idOcchiale, codiceColore);
                    break;
                    
                case "updatequantity":
                    int nuovaQuantita = Integer.parseInt(request.getParameter("quantita"));
                    d.setQuantita(nuovaQuantita);
                    disponibileDAO.doUpdate(d);
                    break;
                    
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Sotto-azione colore non riconosciuta.");
                    return;
            }
        }
         response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=ColoriAggiornati");
    }

    private String salvaImmagine(HttpServletRequest request, int idOcchiale) throws Exception {
        String uploadDir = getServletContext().getRealPath(java.io.File.separator + "images" + java.io.File.separator + "occhiali");
        java.io.File folder = new java.io.File(uploadDir);
        if (!folder.exists()) {
            folder.mkdirs();
        }

        jakarta.servlet.http.Part part = request.getPart("immagine");
        if (part != null && part.getSize() > 0 
                && part.getSubmittedFileName() != null 
                && !part.getSubmittedFileName().isBlank()) {

            String nomeOriginale = java.nio.file.Paths.get(part.getSubmittedFileName()).getFileName().toString();

            String estensione = "";
            int dotIndex = nomeOriginale.lastIndexOf('.');
            if (dotIndex > 0) {
                estensione = nomeOriginale.substring(dotIndex);
            }

            String nomeFile = "immagine" + System.currentTimeMillis() + "_" + idOcchiale + estensione;
            part.write(uploadDir + java.io.File.separator + nomeFile);  //modifica fisica su disco del nome

            return "images/occhiali/" + nomeFile;
        }
        return null;
    }
    
    
}
