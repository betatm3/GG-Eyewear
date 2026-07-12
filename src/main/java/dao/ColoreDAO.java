package dao;

import java.sql.SQLException;
import java.util.Collection;
import model.Colore;

public interface ColoreDAO {
    
    boolean doSave(Colore colore) throws SQLException;
    
    boolean doUpdate(Colore colore) throws SQLException;
    
    boolean doDelete(String codice) throws SQLException;
    
    Colore doRetrieveByKey(String codice) throws SQLException;
    
    Collection<Colore> doRetrieveByNomeGenerico(String nomeScelto) throws SQLException;
    
    Colore doRetrieveByNome(String nomeScelto) throws SQLException;
    
    Collection<Colore> doRetrieveAll(String order) throws SQLException;
}