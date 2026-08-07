
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Collection;
import java.util.ArrayList;
import javax.sql.DataSource;
import model.Colore;

public class ColoreDAOImpl implements ColoreDAO {

    private DataSource ds;
    public static final String TABLE_NAME = "colore";

    public ColoreDAOImpl(DataSource ds) {
        this.ds = ds;
    }

    @Override
    public int doSave(Colore colore) throws SQLException {
        String insertSQL = "INSERT INTO " + TABLE_NAME + " (codice, nome, hex) VALUES (?, ?, ?)";
        int generatedId = -1;

        // Statement.RETURN_GENERATED_KEYS serve per recuperare l'id AUTO_INCREMENT dal DB
        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL, Statement.RETURN_GENERATED_KEYS)) {
            
            preparedStatement.setString(1, colore.getCodice());
            preparedStatement.setString(2, colore.getNome());
            preparedStatement.setString(3, colore.getHex());

            int affectedRows = preparedStatement.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = preparedStatement.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                        colore.setIdColore(generatedId); 
                    }
                }
            }
        }
        return generatedId;
    }
    @Override
    public boolean doUpdate(Colore colore) throws SQLException {
        String updateSQL = "UPDATE " + TABLE_NAME + " SET codice = ?, nome = ?, hex = ? WHERE id_colore = ?";
        int result = 0;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {
            
            preparedStatement.setString(1, colore.getCodice());
            preparedStatement.setString(2, colore.getNome());
            preparedStatement.setString(3, colore.getHex());
            preparedStatement.setInt(4, colore.getIdColore());

            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public boolean doDelete(int idColore) throws SQLException {
        String deleteSQL = "DELETE FROM " + TABLE_NAME + " WHERE id_colore = ?";
        int result = 0;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(deleteSQL)) {
            
            preparedStatement.setInt(1, idColore);
            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public Colore doRetrieveByKey(int idColore) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE id_colore = ?";
        Colore colore = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setInt(1, idColore);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next())
                    colore= leggiDBColore(rs);
            }
        }
        return colore;
    }
    
    @Override
    public Colore doRetrieveByCodice(String codice) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE codice = ?";
        Colore colore = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, codice);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                	colore = leggiDBColore(rs);
                }
            }
        }
        return colore;
    }
    
    @Override
    public Colore doRetrieveByNome(String nomeScelto) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE nome = ?";
        Colore colore = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, nomeScelto);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                	colore = leggiDBColore(rs);
                }
            }
        }
        return colore;
    }
    
    @Override
    public Colore doRetrieveByHex(String hex) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE hex = ?";
        Colore colore = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, hex);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                	colore = leggiDBColore(rs);
                }
            }
        }
        return colore;
    }

    @Override
    public Collection<Colore> doRetrieveByNomeGenerico(String nomeScelto) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE nome LIKE ?";
        Collection<Colore> colori = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, "%" + nomeScelto + "%");

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    colori.add(leggiDBColore(rs));
                }
            }
        }
        return colori;
    }

    
    
    @Override
    public Collection<Colore> doRetrieveAll(String order) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME;

        if (order != null && !order.trim().isEmpty()) {
            selectSQL += " ORDER BY " + order;
        }

        Collection<Colore> colori = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                colori.add(leggiDBColore(rs));
            }
        }
        return colori;
    }
    
    
    private Colore leggiDBColore(ResultSet rs) throws SQLException {
        Colore c = new Colore();
        c.setIdColore(rs.getInt("id_colore"));
        c.setCodice(rs.getString("codice"));
        c.setNome(rs.getString("nome"));
        c.setHex(rs.getString("hex"));
        return c;
    }
}
