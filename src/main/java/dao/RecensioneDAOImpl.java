package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.ArrayList;
import javax.sql.DataSource;
import model.Recensione;

public class RecensioneDAOImpl implements RecensioneDAO {

    private DataSource ds;
    public static final String TABLE_NAME = "recensisce";

    public RecensioneDAOImpl(DataSource ds) {
        this.ds = ds;
    }

    @Override
    public boolean doSave(Recensione recensione) throws SQLException {
        String insertSQL = "INSERT INTO " + TABLE_NAME + " (utente_email, occhiale_id, descrizione, voto) VALUES (?, ?, ?, ?)";
        int result = 0;
        
        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {
            
            preparedStatement.setString(1, recensione.getUtenteEmail());
            preparedStatement.setInt(2, recensione.getOcchialeId());
            preparedStatement.setString(3, recensione.getDescrizione());
            preparedStatement.setInt(4, recensione.getVoto());

            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public boolean doUpdate(Recensione recensione) throws SQLException {
        String updateSQL = "UPDATE " + TABLE_NAME + " SET descrizione = ?, voto = ? WHERE utente_email = ? AND occhiale_id = ?";
        int result = 0;
        
        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {
            
            preparedStatement.setString(1, recensione.getDescrizione());
            preparedStatement.setInt(2, recensione.getVoto());
            preparedStatement.setString(3, recensione.getUtenteEmail());
            preparedStatement.setInt(4, recensione.getOcchialeId());

            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public boolean doDelete(String utenteEmail, int occhialeId) throws SQLException {
        String deleteSQL = "DELETE FROM " + TABLE_NAME + " WHERE utente_email = ? AND occhiale_id = ?";
        int result = 0;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(deleteSQL)) {
            
            preparedStatement.setString(1, utenteEmail);
            preparedStatement.setInt(2, occhialeId);
            
            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public Recensione doRetrieveByKey(String utenteEmail, int occhialeId) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE utente_email = ? AND occhiale_id = ?";
        Recensione recensione = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, utenteEmail);
            preparedStatement.setInt(2, occhialeId);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    recensione = leggiDBRecensione(rs);
                }
            }
        }
        return recensione;
    }

    @Override
    public Collection<Recensione> doRetrieveByOcchiale(int occhialeId) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE occhiale_id = ?";
        Collection<Recensione> recensioni = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setInt(1, occhialeId);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    recensioni.add(leggiDBRecensione(rs));
                }
            }
        }
        return recensioni;
    }

    @Override
    public Collection<Recensione> doRetrieveByUtente(String utenteEmail) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE utente_email = ?";
        Collection<Recensione> recensioni = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, utenteEmail);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    recensioni.add(leggiDBRecensione(rs));
                }
            }
        }
        return recensioni;
    }

    @Override
    public Collection<Recensione> doRetrieveAll(String order) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME;

        if (order != null && !order.trim().isEmpty()) {
            selectSQL += " ORDER BY " + order;
        }

        Collection<Recensione> recensioni = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                recensioni.add(leggiDBRecensione(rs));
            }
        }
        return recensioni;
    }
    
    private Recensione leggiDBRecensione(ResultSet rs) throws SQLException {
        Recensione recensione = new Recensione();
        recensione.setUtenteEmail(rs.getString("utente_email"));
        recensione.setOcchialeId(rs.getInt("occhiale_id"));
        recensione.setDescrizione(rs.getString("descrizione"));
        recensione.setVoto(rs.getInt("voto"));
        return recensione;
    }
}