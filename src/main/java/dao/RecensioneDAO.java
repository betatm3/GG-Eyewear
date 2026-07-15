package dao;

import java.sql.SQLException;
import java.util.Collection;
import model.Recensione;

public interface RecensioneDAO {
    
    boolean doSave(Recensione recensione) throws SQLException;
    
    boolean doUpdate(Recensione recensione) throws SQLException;
    
    boolean doDelete(String utenteEmail, int occhialeId) throws SQLException;
    
    Recensione doRetrieveByKey(String utenteEmail, int occhialeId) throws SQLException;
    
    Collection<Recensione> doRetrieveByOcchiale(int occhialeId) throws SQLException;
    
    Collection<Recensione> doRetrieveByUtente(String utenteEmail) throws SQLException;
    
    Collection<Recensione> doRetrieveAll(String order) throws SQLException;
}