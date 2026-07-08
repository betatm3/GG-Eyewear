package dao;

import java.sql.SQLException;
import java.util.Collection;
import model.Colore;

public interface ColoreDAO {
    
    public void doSave(Colore colore) throws SQLException;
    
    public void doUpdate(Colore colore) throws SQLException;
    
    public boolean doDelete(String codice) throws SQLException;
    
    public Colore doRetrieveByKey(String codice) throws SQLException;
    
    public Collection<Colore> doRetrieveByNome(String nomeScelto) throws SQLException;
    
    public Collection<Colore> doRetrieveAll(String order) throws SQLException;
}