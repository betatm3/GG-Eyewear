package control.common;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import dao.OcchialeDAOImpl;
import dao.VersioneOcchialeDAOImpl;

import model.Occhiale;
import model.Tipologia;
import model.VersioneOcchiale;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
        VersioneOcchialeDAOImpl versioneDAO = new VersioneOcchialeDAOImpl(ds);

        try {
            // 1. Recupera gli occhiali da sole attivi (massimo 4)
            Collection<Occhiale> sole = occhialeDAO.doRetrieveByTipologia(Tipologia.DA_SOLE);
            List<Occhiale> soleCompleti = caricaDettagli(sole, versioneDAO, 4);

            // 2. Recupera gli occhiali da vista attivi (massimo 4)
            Collection<Occhiale> vista = occhialeDAO.doRetrieveByTipologia(Tipologia.DA_VISTA);
            List<Occhiale> vistaCompleti = caricaDettagli(vista, versioneDAO, 4);

            // 3. Imposta gli attributi per la JSP
            request.setAttribute("sole", soleCompleti);
            request.setAttribute("vista", vistaCompleti);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("sole", new ArrayList<Occhiale>());
            request.setAttribute("vista", new ArrayList<Occhiale>());
        }

        // 4. Passa alla JSP della home
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/home.jsp");
        dispatcher.forward(request, response);
    }

    private List<Occhiale> caricaDettagli(Collection<Occhiale> occhiali, 
                                         VersioneOcchialeDAOImpl versioneDAO, 
                                         int limit) throws SQLException {
        List<Occhiale> completi = new ArrayList<>();
        if (occhiali != null) {
            int count = 0;
            for (Occhiale o : occhiali) {
                if (count >= limit) {
                    break;
                }
                // Carica la versione commerciale corrente
                VersioneOcchiale versione = versioneDAO.doRetrieveCorrenteByOcchiale(o.getId());
                o.setVersioneCorrente(versione);

                completi.add(o);
                count++;
            }
        }
        return completi;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
