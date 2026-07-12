package dao;


import java.sql.SQLException;
import java.util.Collection;
import model.Utente;
import model.Ruolo;

public interface UtenteDAO {
    
    boolean doSave(Utente utente) throws SQLException;
    
    boolean doUpdate(Utente utente) throws SQLException;
    
    boolean doDelete(String email) throws SQLException;
    
    Utente doRetrieveByKey(String email) throws SQLException;
    
    Collection<Utente> doRetrieveByRuolo(Ruolo ruoloScelto) throws SQLException;
    
    Collection<Utente> doRetrieveAll(String order) throws SQLException;
}
