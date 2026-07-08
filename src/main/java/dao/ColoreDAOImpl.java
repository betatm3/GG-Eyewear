
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
    public void doSave(Colore colore) throws SQLException {
        String insertSQL = "INSERT INTO " + TABLE_NAME + " (codice, nome) VALUES (?, ?)";

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {
            
            preparedStatement.setString(1, colore.getCodice());
            preparedStatement.setString(2, colore.getNome());

            preparedStatement.executeUpdate();
        }
    }

    @Override
    public void doUpdate(Colore colore) throws SQLException {
        String updateSQL = "UPDATE " + TABLE_NAME + " SET nome = ? WHERE codice = ?";

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {
            
            preparedStatement.setString(1, colore.getNome());
            preparedStatement.setString(2, colore.getCodice());

            preparedStatement.executeUpdate();
        }
    }

    @Override
    public boolean doDelete(String codice) throws SQLException {
        String deleteSQL = "DELETE FROM " + TABLE_NAME + " WHERE codice = ?";
        int result = 0;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(deleteSQL)) {
            
            preparedStatement.setString(1, codice);
            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public Colore doRetrieveByKey(String codice) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE codice = ?";
        Colore colore = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, codice);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next())
                    colore= leggiDBColore(rs);
            }
        }
        return colore;
    }

    @Override
    public Collection<Colore> doRetrieveByNome(String nomeScelto) throws SQLException {
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
        Colore colore = new Colore();
        colore.setCodice(rs.getString("codice"));
        colore.setNome(rs.getString("nome"));
        return colore;
    }
}
