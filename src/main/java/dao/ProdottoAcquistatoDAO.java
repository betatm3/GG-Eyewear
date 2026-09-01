package dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collection;

import model.ProdottoAcquistato;


public interface ProdottoAcquistatoDAO {
    
    int doSave(ProdottoAcquistato prodotto) throws SQLException;
    
    int doSave(ProdottoAcquistato prodotto, Connection connection) throws SQLException;

    boolean doUpdate(ProdottoAcquistato prodotto) throws SQLException;
    
    boolean doDelete(int numero) throws SQLException;
    
    ProdottoAcquistato doRetrieveByKey(int numero, int id_ordine) throws SQLException;
    
    Collection<ProdottoAcquistato> doRetrieveByOrdine(int id_ordine) throws SQLException;
        
    Collection<ProdottoAcquistato> doRetrieveAll(String order) throws SQLException;
}
