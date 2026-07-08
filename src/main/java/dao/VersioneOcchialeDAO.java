package dao;
import java.util.Collection;
import model.VersioneOcchiale;
import model.Genere;
import java.sql.SQLException;

public interface VersioneOcchialeDAO {

	void doSave(VersioneOcchiale versione) throws SQLException;

    void doUpdate(VersioneOcchiale versione) throws SQLException;

    boolean doDelete(int codice) throws SQLException;

    VersioneOcchiale doRetrieveByKey(int codice) throws SQLException;

    Collection<VersioneOcchiale> doRetrieveByOcchiale(int occhiale_id) throws SQLException;

    Collection<VersioneOcchiale> doRetrieveByGenere(Genere genere) throws SQLException;

    Collection<VersioneOcchiale> doRetrieveByTaglia(String taglia) throws SQLException;

    Collection<VersioneOcchiale> doRetrieveByMontatura(String montatura) throws SQLException;

    Collection<VersioneOcchiale> doRetrieveByForma(String forma) throws SQLException;

    Collection<VersioneOcchiale> doRetrieveByMateriale(String materiale) throws SQLException;

    Collection<VersioneOcchiale> doRetrieveByPrezzo(double prezzo) throws SQLException;

    Collection<VersioneOcchiale> doRetrieveByFasciaPrezzo(double prezzoMin, double prezzoMax) throws SQLException;

    Collection<VersioneOcchiale> doRetrieveByCorrente(boolean corrente) throws SQLException;

    Collection<VersioneOcchiale> doRetrieveAll(String order) throws SQLException;

}
