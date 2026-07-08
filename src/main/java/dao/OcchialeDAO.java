package dao;
import java.util.Collection;
import model.Occhiale;
import java.sql.SQLException;

public interface OcchialeDAO {

	void doSave(Occhiale occhiale) throws SQLException;

	void doUpdate(Occhiale occhiale) throws SQLException;

    boolean doDelete(int id) throws Exception;

    Occhiale doRetrieveByKey(int id) throws SQLException;

    Collection<Occhiale> doRetrieveByAttivo(boolean attivo) throws SQLException;

    Collection<Occhiale> doRetrieveAll(String order) throws SQLException;
    

}
