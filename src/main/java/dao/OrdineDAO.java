package dao;
import java.util.Collection;
import model.Ordine;
import model.Stato; 

public interface OrdineDAO {

	void doSave(Ordine ordine) throws Exception;

	void doUpdate(Ordine ordine) throws Exception;

	boolean doDelete(int id) throws Exception;

	Ordine doRetrieveByKey(int id) throws Exception;

	Collection<Ordine> doRetrieveByUtente(String utente_email) throws Exception;

	Collection<Ordine> doRetrieveByStato(Stato stato) throws Exception;

	Collection<Ordine> doRetrieveAll(String order) throws Exception;
	
}

