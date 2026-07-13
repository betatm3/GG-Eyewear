package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.ArrayList;
import javax.sql.DataSource;
import model.Occhiale;
import model.Tipologia;

public class OcchialeDAOImpl implements OcchialeDAO {

    private DataSource ds;
    public static final String TABLE_NAME = "occhiale";

    public OcchialeDAOImpl(DataSource ds) {
        this.ds = ds;
    }

    @Override
    public int doSave(Occhiale occhiale) throws SQLException {
        String insertSQL = "INSERT INTO " + TABLE_NAME + " (attivo, immagine, tipologia) VALUES (?, ?, ?)";
        
        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            
            preparedStatement.setBoolean(1, occhiale.isAttivo());
            preparedStatement.setBytes(2, occhiale.getImmagine());
            preparedStatement.setString(3, occhiale.getTipo() != null ? occhiale.getTipo().name() : null);
            
            preparedStatement.executeUpdate();
            
            try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Inserimento fallito, nessun ID generato dal database.");
                }
            }
        }
    }

    @Override
    public boolean doUpdate(Occhiale occhiale) throws SQLException {
        String updateSQL = "UPDATE " + TABLE_NAME + " SET attivo = ?, immagine = ?, tipologia = ? WHERE id = ?";
        int result = 0;
        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {
            
            preparedStatement.setBoolean(1, occhiale.isAttivo());
            preparedStatement.setBytes(2, occhiale.getImmagine());
            preparedStatement.setString(3, occhiale.getTipo() != null ? occhiale.getTipo().name() : null);
            preparedStatement.setInt(4, occhiale.getId());

            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public boolean doDelete(int id) throws SQLException {
        String deleteSQL = "DELETE FROM " + TABLE_NAME + " WHERE id = ?";
        int result = 0;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(deleteSQL)) {
            
            preparedStatement.setInt(1, id);
            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }
    
    public boolean doDeleteLogica(int id) throws SQLException {
        String updateSQL = "UPDATE " + TABLE_NAME + " SET attivo = false WHERE id = ?";
        int result = 0;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {
            
            preparedStatement.setInt(1, id);
            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }
    

    @Override
    public Occhiale doRetrieveByKey(int id) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE id = ?";
        Occhiale occhiale = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setInt(1, id);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    occhiale = leggiDBOcchiale(rs);
                }
            }
        }
        return occhiale;
    }
    
    @Override
    public Collection<Occhiale> doRetrieveByTipologia(Tipologia tipo) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE tipologia = ? AND attivo = TRUE";
        Collection<Occhiale> lista = new java.util.ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, tipo != null ? tipo.name() : null);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                	lista.add(leggiDBOcchiale(rs));     
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<Occhiale> doRetrieveByAttivo(boolean attivoScelto) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE attivo = ?";
        Collection<Occhiale> occhiali = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setBoolean(1, attivoScelto);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    occhiali.add(leggiDBOcchiale(rs));
                }
            }
        }
        return occhiali;
    }

    @Override
    public Collection<Occhiale> doRetrieveAll(String order) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME;

        if (order != null && !order.trim().isEmpty()) {
            selectSQL += " ORDER BY " + order;
        }

        Collection<Occhiale> occhiali = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                occhiali.add(leggiDBOcchiale(rs));
            }
        }
        return occhiali;
    }

    private Occhiale leggiDBOcchiale(ResultSet rs) throws SQLException {
        Occhiale occhiale = new Occhiale();
        occhiale.setId(rs.getInt("id"));
        occhiale.setAttivo(rs.getBoolean("attivo"));
        occhiale.setImmagine(rs.getBytes("immagine"));
        
        String tipologiaStr = rs.getString("tipologia");
        if (tipologiaStr != null) {
            occhiale.setTipo(Tipologia.valueOf(tipologiaStr));
        }
        
        return occhiale;
    }
}