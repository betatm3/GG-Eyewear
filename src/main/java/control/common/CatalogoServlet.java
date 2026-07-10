package control.common;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import dao.VersioneOcchialeDAOImpl;
import dao.OcchialeDAOImpl;
import dao.DisponibileDAOImpl;

import model.Disponibile;
import model.Occhiale;
import model.VersioneOcchiale;

// URL della servlet
@WebServlet("/common/catalogo")
public class CatalogoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;
    
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
    	// 3. Istanziamo tutti i DAO che ci servono
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);
        DisponibileDAOImpl disponibileDAO = new DisponibileDAOImpl(ds);
        
       try {
            // 4. Prendiamo i dati dal Database tramite il DAO
            Collection<Occhiale> listaOcchiali = occhialeDAO.doRetrieveByAttivo(true);
            
            // 5. Cicliamo su ogni occhiale per caricarne i dettagli commerciali e i colori
            for (Occhiale occhiale : listaOcchiali) {
                
                // Cerca la versione commerciale corrente (dove corrente = true)
                VersioneOcchiale versioneCorrente = versioneDAO.doRetrieveCorrenteByOcchiale(occhiale.getId());
                occhiale.setVersioneCorrente(versioneCorrente); // Lo associamo all'occhiale
                
                // Cerca tutte le disponibilità di colore/quantità
                Collection<Disponibile> listaDisponibilita = disponibileDAO.doRetrieveByOcchiale(occhiale.getId());
                occhiale.setDisponibilita(listaDisponibilita); // Lo associamo all'occhiale
            }
            
            // 6. Ora la lista contiene oggetti completi di tutto! La passiamo alla JSP
            request.setAttribute("prodotti", listaOcchiali);
            
        } catch (SQLException e) {            // In caso di errore al DB, lo stampiamo in console
            e.printStackTrace(); 
        }
        

       // 7. Passiamo la palla alla pagina JSP che si occuperà della grafica
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/catalogo.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Se qualcuno fa una richiesta POST su /catalogo, lo rimandiamo al GET
        doGet(request, response);
    }
}