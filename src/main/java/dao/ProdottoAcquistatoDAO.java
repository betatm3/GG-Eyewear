package dao;

import java.sql.SQLException;
import java.util.Collection;
import model.ProdottoAcquistato;
import model.Ordine;

public interface ProdottoAcquistatoDAO {
    
    public void doSave(ProdottoAcquistato prodotto) throws SQLException;
    
    public void doUpdate(ProdottoAcquistato prodotto) throws SQLException;
    
    public boolean doDelete(int numero) throws SQLException;
    
    public ProdottoAcquistato doRetrieveByKey(int numero) throws SQLException;
    
    public Collection<ProdottoAcquistato> doRetrieveByOrdine(Ordine ordine) throws SQLException;
    
    public Collection<ProdottoAcquistato> doRetrieveAll(String order) throws SQLException;
}
