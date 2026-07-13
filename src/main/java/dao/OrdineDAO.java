package dao;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Collection;

import model.Ordine;
import model.Stato;

public interface OrdineDAO {

	boolean doSave(Ordine ordine) throws SQLException;

	boolean doUpdate(Ordine ordine) throws SQLException;

	boolean doDelete(int id) throws SQLException;

	Ordine doRetrieveByKey(int id) throws SQLException;

	Collection<Ordine> doRetrieveByUtente(String utente_email) throws SQLException;

	Collection<Ordine> doRetrieveByStato(Stato stato) throws SQLException;
	
    Collection<Ordine> doRetrieveByFiltri(Stato stato, String metodoPagamento, Double prezzoMin, Double prezzoMax, LocalDateTime dataInizio, LocalDateTime dataFine) throws SQLException;

	Collection<Ordine> doRetrieveByProdotti(Collection<Integer> codiciVersioni, Collection<Integer> idOcchiali) throws SQLException;
	
	Collection<Ordine> doRetrieveAll(String order) throws SQLException;
	
}

