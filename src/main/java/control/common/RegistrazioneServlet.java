package control.common;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javax.sql.DataSource;

import dao.UtenteDAOImpl;
import model.Ruolo;
import model.Utente;

@WebServlet("/registrazione")
public class RegistrazioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @jakarta.annotation.Resource(name = "jdbc/ecommerce_db")
    private DataSource ds;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/registrazione.jsp");
    	dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confermaPassword = request.getParameter("confermaPassword");
        String indirizzo = request.getParameter("indirizzo");
        String dataNascitaStr = request.getParameter("dataNascita"); // Arriva come stringa "YYYY-MM-DD" dal tag <input type="date">
        String telefono = request.getParameter("telefono");

        // Validazione campi
        if (nome == null || nome.trim().isEmpty() ||
            cognome == null || cognome.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            indirizzo == null || indirizzo.trim().isEmpty() ||
            dataNascitaStr == null || dataNascitaStr.trim().isEmpty() ||
            telefono == null || telefono.trim().isEmpty()){
        	
            request.setAttribute("errore", "Tutti i campi sono obbligatori.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/registrazione.jsp");
        	dispatcher.forward(request, response);
        	return;
        }

        // Conversione e validazione della data di nascita
        java.time.LocalDate dataNascita = null;
        try {
            dataNascita = java.time.LocalDate.parse(dataNascitaStr);
        } catch (java.time.format.DateTimeParseException e) {
            request.setAttribute("errore", "Formato della data di nascita non valido.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/registrazione.jsp");
        	dispatcher.forward(request, response);
        	return;
        }
        
        if (!password.equals(confermaPassword)) {
            request.setAttribute("errore", "Le password inserite non corrispondono.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/registrazione.jsp");
        	dispatcher.forward(request, response);
        	return;
        }

        UtenteDAOImpl utenteDAO = new UtenteDAOImpl(ds);

        try {
            // Controllo unicità dell'email
            if (utenteDAO.doRetrieveByKey(email) != null) {
                request.setAttribute("errore", "Questa email è già associata a un account esistente.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/registrazione.jsp");
            	dispatcher.forward(request, response);
            	return;
            }
            
            Utente nuovoUtente = new Utente();
            nuovoUtente.setNome(nome.trim());
            nuovoUtente.setCognome(cognome.trim());
            nuovoUtente.setEmail(email.trim().toLowerCase());
            nuovoUtente.setRuolo(Ruolo.CLIENTE); 
            nuovoUtente.setIndirizzo(indirizzo.trim());
            nuovoUtente.setDataNascita(dataNascita);
            nuovoUtente.setTelefono(telefono.trim());
            nuovoUtente.setPassword(password); 
            
            boolean isCreato = utenteDAO.doSave(nuovoUtente);

            if (isCreato) {
                // eseguiamo il login automatico recupeando dell'utente appena creato dal DB per avere anche l'ID generato dall'AUTO_INCREMENT
                Utente utenteLoggato = utenteDAO.doRetrieveByKey(nuovoUtente.getEmail());
                
                HttpSession session = request.getSession(true);
                session.setAttribute("utenteLoggato", utenteLoggato);
                response.sendRedirect(request.getContextPath() + "/area-utente");
                return;
            } else {
                request.setAttribute("errore", "Errore durante la registrazione. Riprova.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errore", "Si è verificato un errore tecnico nel database. Riprova più tardi.");
        }

        // Se qualcosa è andato storto, ricarichiamo la pagina di registrazione mostrando l'errore
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/common/registrazione.jsp");
    	dispatcher.forward(request, response);
    	}
}
