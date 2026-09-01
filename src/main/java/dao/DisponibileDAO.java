package dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collection;
import model.Disponibile;

public interface DisponibileDAO {
    
    boolean doSave(Disponibile disponibile) throws SQLException;
    
    boolean doUpdate(Disponibile disponibile, Connection connection) throws SQLException;

    boolean doUpdate(Disponibile disponibile) throws SQLException;
    
    boolean doDelete(int idOcchiale, String codiceColore) throws SQLException;
    
    Disponibile doRetrieveByKey(int idOcchiale, String codiceColore, Connection connection) throws SQLException;
    
    Disponibile doRetrieveByKey(int idOcchiale, String codiceColore) throws SQLException;
    
    Collection<Disponibile> doRetrieveByOcchiale(int idOcchiale) throws SQLException;
    
    Collection<Disponibile> doRetrieveByColore(String codiceColore) throws SQLException;
    
    Collection<Disponibile> doRetrieveAll(String order) throws SQLException;
}
