package dao;

import java.sql.SQLException;
import java.util.Collection;
import model.Disponibile;

public interface DisponibileDAO {
    
    public void doSave(Disponibile disponibile) throws SQLException;
    
    public void doUpdate(Disponibile disponibile) throws SQLException;
    
    public boolean doDelete(int idOcchiale, String codiceColore) throws SQLException;
    
    public Disponibile doRetrieveByKey(int idOcchiale, String codiceColore) throws SQLException;
    
    // Recupera tutti i colori per un determinato occhiale
    public Collection<Disponibile> doRetrieveByOcchiale(int idOcchiale) throws SQLException;
    
    // Recupera tutti gli occhiali disponibili in un determinato colore
    public Collection<Disponibile> doRetrieveByColore(String codiceColore) throws SQLException;
    
    public Collection<Disponibile> doRetrieveAll(String order) throws SQLException;
}
