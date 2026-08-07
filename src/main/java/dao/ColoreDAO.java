package dao;

import java.sql.SQLException;
import java.util.Collection;
import model.Colore;

public interface ColoreDAO {
    
    int doSave(Colore colore) throws SQLException;
    
    boolean doUpdate(Colore colore) throws SQLException;
    
    boolean doDelete(int idColore) throws SQLException;
    
    Colore doRetrieveByKey(int idColore) throws SQLException;
    
    Colore doRetrieveByCodice(String codice) throws SQLException;
    
    Collection<Colore> doRetrieveByNomeGenerico(String nomeScelto) throws SQLException;
    
    Colore doRetrieveByNome(String nomeScelto) throws SQLException;
    
    Colore doRetrieveByHex(String hex) throws SQLException;
    
    Collection<Colore> doRetrieveAll(String order) throws SQLException;
}