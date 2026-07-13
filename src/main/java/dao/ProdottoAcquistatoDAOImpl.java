package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.ArrayList;
import javax.sql.DataSource;
import model.ProdottoAcquistato;
import model.Ordine;
import model.Colore;
import model.Occhiale;
import model.VersioneOcchiale;

public class ProdottoAcquistatoDAOImpl implements ProdottoAcquistatoDAO {

    private DataSource ds;

    public static final String TABLE_NAME = "prodotto_acquistato";

    public ProdottoAcquistatoDAOImpl(DataSource ds) {
        this.ds = ds;
    }

    @Override
    public boolean doSave(ProdottoAcquistato prodotto) throws SQLException {
        String insertSQL = "INSERT INTO " + TABLE_NAME + " (numero, ordine_id, quantita, colore_codice, versione_codice, occhiale_id) VALUES (?, ?, ?, ?, ?, ?)";
        int result = 0;
        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {
            
            preparedStatement.setInt(1, prodotto.getNumero());
            
            preparedStatement.setInt(2, prodotto.getOrdine() != null ? prodotto.getOrdine().getId() : 0); 
            preparedStatement.setInt(3, prodotto.getQuantita());
            preparedStatement.setString(4, prodotto.getColore() != null ? prodotto.getColore().getCodice() : null);
            preparedStatement.setInt(5, prodotto.getVersioneOcchiale() != null ? prodotto.getVersioneOcchiale().getCodice() : 0);
            preparedStatement.setInt(6, prodotto.getOcchiale() != null ? prodotto.getOcchiale().getId() : 0);

            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public boolean doUpdate(ProdottoAcquistato prodotto) throws SQLException {
        String updateSQL = "UPDATE " + TABLE_NAME + " SET ordine_id = ?, quantita = ?, colore_codice = ?, versione_codice = ?, occhiale_id = ? WHERE numero = ?";
        int result = 0;
        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {
            
            preparedStatement.setInt(1, prodotto.getOrdine() != null ? prodotto.getOrdine().getId() : 0);
            preparedStatement.setInt(2, prodotto.getQuantita());
            preparedStatement.setString(3, prodotto.getColore() != null ? prodotto.getColore().getCodice() : null);
            preparedStatement.setInt(4, prodotto.getVersioneOcchiale() != null ? prodotto.getVersioneOcchiale().getCodice() : 0);
            preparedStatement.setInt(5, prodotto.getOcchiale() != null ? prodotto.getOcchiale().getId() : 0);
            preparedStatement.setInt(6, prodotto.getNumero());

            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public boolean doDelete(int numero) throws SQLException {
        String deleteSQL = "DELETE FROM " + TABLE_NAME + " WHERE numero = ?";
        int result = 0;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(deleteSQL)) {
            
            preparedStatement.setInt(1, numero);
            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public ProdottoAcquistato doRetrieveByKey(int numero, int id_ordine) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE numero = ? AND ordine_id = ?";
        ProdottoAcquistato prodotto = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setInt(1, numero);
            preparedStatement.setInt(2, id_ordine);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    prodotto = leggiDBProdottoAcquistato(rs);
                }
            }
        }
        return prodotto;
    }

    @Override
    public Collection<ProdottoAcquistato> doRetrieveByOrdine(int id_ordine) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE ordine_id = ?";
        Collection<ProdottoAcquistato> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setInt(1, id_ordine);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {                  
                    lista.add(leggiDBProdottoAcquistato(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<ProdottoAcquistato> doRetrieveAll(String order) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME;

        if (order != null && !order.trim().isEmpty()) {
            selectSQL += " ORDER BY " + order;
        }

        Collection<ProdottoAcquistato> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {               
                lista.add(leggiDBProdottoAcquistato(rs));
            }
        }
        return lista;
    }
    
    private ProdottoAcquistato leggiDBProdottoAcquistato(ResultSet rs) throws SQLException {
        ProdottoAcquistato prodotto = new ProdottoAcquistato();
        prodotto.setNumero(rs.getInt("numero"));
        prodotto.setQuantita(rs.getInt("quantita"));
        
        // ARCHITETTURA: Qui nel DAO creiamo degli oggetti "finti" contenenti solo l'ID.
        // Sarà poi compito della Servlet usare gli altri DAO 
        // (es. OcchialeDAO) per riempire completamente l'oggetto se necessario.
        
        Ordine ord = new Ordine();
        ord.setId(rs.getInt("ordine_id"));
        prodotto.setOrdine(ord);
        
        Colore col = new Colore();
        col.setCodice(rs.getString("colore_codice"));
        prodotto.setColore(col);
        
        VersioneOcchiale ver = new VersioneOcchiale();
        ver.setCodice(rs.getInt("versione_codice"));
        prodotto.setVersioneOcchiale(ver);
        
        Occhiale occ = new Occhiale();
        occ.setId(rs.getInt("occhiale_id"));
        prodotto.setOcchiale(occ);
        
        return prodotto;
    }
}