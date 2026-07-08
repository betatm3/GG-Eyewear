package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import javax.sql.DataSource;
import model.Disponibile;
import model.Colore;
import model.Occhiale;

public class DisponibileDAOImpl implements DisponibileDAO {

    private DataSource ds;
    public static final String TABLE_NAME = "disponibile";

    public DisponibileDAOImpl(DataSource ds) {
        this.ds = ds;
    }

    @Override
    public void doSave(Disponibile disponibile) throws SQLException {
        String insertSQL = "INSERT INTO " + TABLE_NAME + " (id_occhiale, codice_colore, quantita) VALUES (?, ?, ?)";

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {
            
            preparedStatement.setInt(1, disponibile.getOcchiale() != null ? disponibile.getOcchiale().getId() : 0);
            preparedStatement.setString(2, disponibile.getColore() != null ? disponibile.getColore().getCodice() : null);
            preparedStatement.setInt(3, disponibile.getQuantita());

            preparedStatement.executeUpdate();
        }
    }

    @Override
    public void doUpdate(Disponibile disponibile) throws SQLException {
        String updateSQL = "UPDATE " + TABLE_NAME + " SET quantita = ? WHERE id_occhiale = ? AND codice_colore = ?";

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {
            
            preparedStatement.setInt(1, disponibile.getQuantita());
            preparedStatement.setInt(2, disponibile.getOcchiale() != null ? disponibile.getOcchiale().getId() : 0);
            preparedStatement.setString(3, disponibile.getColore() != null ? disponibile.getColore().getCodice() : null);

            preparedStatement.executeUpdate();
        }
    }

    @Override
    public boolean doDelete(int idOcchiale, String codiceColore) throws SQLException {
        String deleteSQL = "DELETE FROM " + TABLE_NAME + " WHERE id_occhiale = ? AND codice_colore = ?";
        int result = 0;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(deleteSQL)) {
            
            preparedStatement.setInt(1, idOcchiale);
            preparedStatement.setString(2, codiceColore);
            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public Disponibile doRetrieveByKey(int idOcchiale, String codiceColore) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE id_occhiale = ? AND codice_colore = ?";
        Disponibile disponibile = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setInt(1, idOcchiale);
            preparedStatement.setString(2, codiceColore);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    disponibile = leggiDBDisponibile(rs);
                }
            }
        }
        return disponibile;
    }

    @Override
    public Collection<Disponibile> doRetrieveByOcchiale(int idOcchiale) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE id_occhiale = ?";
        Collection<Disponibile> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setInt(1, idOcchiale);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBDisponibile(rs));
                }
            }
        }
        return lista;
    }
    
    @Override
    public Collection<Disponibile> doRetrieveByColore(String codiceColore) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE codice_colore = ?";
        Collection<Disponibile> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, codiceColore);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBDisponibile(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<Disponibile> doRetrieveAll(String order) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME;

        if (order != null && !order.trim().isEmpty()) {
            selectSQL += " ORDER BY " + order;
        }

        Collection<Disponibile> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                lista.add(leggiDBDisponibile(rs));
            }
        }
        return lista;
    }

    private Disponibile leggiDBDisponibile(ResultSet rs) throws SQLException {
        Disponibile disponibile = new Disponibile();
        disponibile.setQuantita(rs.getInt("quantita"));
        
        Occhiale occ = new Occhiale();
        occ.setId(rs.getInt("id_occhiale"));
        disponibile.setOcchiale(occ);
        
        Colore col = new Colore();
        col.setCodice(rs.getString("codice_colore"));
        disponibile.setColore(col);
        
        return disponibile;
    }
}