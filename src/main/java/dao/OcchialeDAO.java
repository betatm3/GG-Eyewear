package dao;
import java.util.Collection;
import model.Occhiale;
import model.Tipologia;

import java.sql.SQLException;

public interface OcchialeDAO {

	boolean doSave(Occhiale occhiale) throws SQLException;

	boolean doUpdate(Occhiale occhiale) throws SQLException;

    boolean doDelete(int id) throws SQLException;

    Occhiale doRetrieveByKey(int id) throws SQLException;
    
    Collection<Occhiale> doRetrieveByTipologia(Tipologia tipo) throws SQLException;

    Collection<Occhiale> doRetrieveByAttivo(boolean attivo) throws SQLException;

    Collection<Occhiale> doRetrieveAll(String order) throws SQLException;
    

}
