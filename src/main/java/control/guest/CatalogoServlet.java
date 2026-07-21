package control.guest;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import dao.VersioneOcchialeDAOImpl;
import dao.DisponibileDAOImpl;
import dao.RecensioneDAOImpl;

import model.Disponibile;
import model.Occhiale;
import model.VersioneOcchiale;
import model.Tipologia;
import model.Genere;
import model.Recensione;

// URL della servlet
@WebServlet("/catalogo")
public class CatalogoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;
    
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);
        DisponibileDAOImpl disponibileDAO = new DisponibileDAOImpl(ds);
        
        // Recupero dei parametri stringa inviati dal form di ricerca
        String genereStr = request.getParameter("genere");
        String materiale = request.getParameter("materiale");
        String forma = request.getParameter("forma");
        String marca = request.getParameter("marca");
        String colore = request.getParameter("colore");
        String taglia = request.getParameter("taglia");
        
        String prezzoMinStr = request.getParameter("prezzoMin");
        String prezzoMaxStr = request.getParameter("prezzoMax");

        // Sanificazione delle stringhe: se vuote o composte solo da spazi, diventano null
        if (materiale != null && materiale.trim().isEmpty()) materiale = null;
        if (forma != null && forma.trim().isEmpty()) forma = null;
        if (marca != null && marca.trim().isEmpty()) marca = null;
        if (colore != null && colore.trim().isEmpty()) colore = null;
        if (taglia != null && taglia.trim().isEmpty()) taglia = null;

        Genere genere = null;
        if (genereStr != null && !genereStr.trim().isEmpty()) {
            try {
                genere = Genere.valueOf(genereStr.toUpperCase().trim());
            } catch (IllegalArgumentException e) {
                genere = null;
            }
        }

        // 5. Parsing sicuro dei prezzi Double
        Double prezzoMin = null;
        if (prezzoMinStr != null && !prezzoMinStr.trim().isEmpty()) {
            try {
                prezzoMin = Double.parseDouble(prezzoMinStr);
            } catch (NumberFormatException e) {
                prezzoMin = null;
            }
        }

        Double prezzoMax = null;
        if (prezzoMaxStr != null && !prezzoMaxStr.trim().isEmpty()) {
            try {
                prezzoMax = Double.parseDouble(prezzoMaxStr);
            } catch (NumberFormatException e) {
                prezzoMax = null;
            }
        }

        try {
            Collection<VersioneOcchiale> versioniFiltrate = versioneDAO.doRetrieveByFiltri(
                genere, materiale, forma, marca, colore, taglia, prezzoMin, prezzoMax);
            
            // Costruiamo la lista di Occhiale da passare alla JSP ed il calcolo delle medie voti
            Collection<Occhiale> listaOcchiali = new ArrayList<>();
            Map<Integer, Double> medieVoti = new HashMap<>();
            RecensioneDAOImpl recensioneDAO = new RecensioneDAOImpl(ds);

            for (VersioneOcchiale versione : versioniFiltrate) {
                Occhiale occhiale = versione.getOcchiale();
                if (occhiale != null) {
                    occhiale.setVersioneCorrente(versione);
                    
                    // Cerca tutte le disponibilità di colore/quantità
                    Collection<Disponibile> listaDisponibilita = disponibileDAO.doRetrieveByOcchiale(occhiale.getId());
                    occhiale.setDisponibilita(listaDisponibilita);
                    
                    // Calcolo della media recensioni del prodotto
                    try {
                        Collection<Recensione> recensioni = recensioneDAO.doRetrieveByOcchiale(occhiale.getId());
                        if (recensioni != null && !recensioni.isEmpty()) {
                            double media = recensioni.stream().mapToInt(Recensione::getVoto).average().orElse(0.0);
                            medieVoti.put(occhiale.getId(), media);
                        } else {
                            medieVoti.put(occhiale.getId(), 0.0);
                        }
                    } catch (Exception e) {
                        medieVoti.put(occhiale.getId(), 0.0);
                    }
                    
                    listaOcchiali.add(occhiale);
                }
            }

            String tipo = request.getParameter("tipo");
            if (tipo != null && !tipo.trim().isEmpty()) {
                Tipologia targetTipo = null;
                String cleanedTipo = tipo.toUpperCase().trim();
                if (cleanedTipo.equals("SOLE") || cleanedTipo.equals("DA_SOLE")) {
                    targetTipo = Tipologia.DA_SOLE;
                } else if (cleanedTipo.equals("VISTA") || cleanedTipo.equals("DA_VISTA")) {
                    targetTipo = Tipologia.DA_VISTA;
                } else if (cleanedTipo.equals("LETTURA") || cleanedTipo.equals("DA_LETTURA")) {
                    targetTipo = Tipologia.DA_LETTURA;
                } else {
                    try {
                        targetTipo = Tipologia.valueOf(cleanedTipo);
                    } catch (IllegalArgumentException e) {
                        targetTipo = null;
                    }
                }
                
                if (targetTipo != null) {
                    final Tipologia finalTarget = targetTipo;
                    listaOcchiali.removeIf(occhiale -> occhiale.getTipo() != finalTarget);
                }
            }
            
            // Gestione sezione Outlet con occhiali casuali e sconti
            String isOutletStr = request.getParameter("outlet");
            boolean isOutlet = "true".equalsIgnoreCase(isOutletStr) || (tipo == null && (isOutletStr == null || "true".equalsIgnoreCase(isOutletStr)));
            
            if (isOutlet && listaOcchiali instanceof java.util.List) {
                java.util.Collections.shuffle((java.util.List<Occhiale>) listaOcchiali);
            }
            
            request.setAttribute("prodotti", listaOcchiali);
            request.setAttribute("medieVoti", medieVoti);
            request.setAttribute("isOutlet", isOutlet);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/guest/catalogo.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}