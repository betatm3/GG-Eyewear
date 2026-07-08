package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.ArrayList;
import javax.sql.DataSource;
import model.Utente;
import model.Ruolo; 

public class UtenteDAOImpl implements UtenteDAO {

    private DataSource ds;

    public static final String TABLE_NAME = "utente";

    public UtenteDAOImpl(DataSource ds) {
        this.ds = ds;
    }

    @Override
    public void doSave(Utente utente) throws SQLException {
        String insertSQL = "INSERT INTO " + TABLE_NAME + " (email, password, nome, cognome, data_nascita, indirizzo, telefono, ruolo) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {
            
            preparedStatement.setString(1, utente.getEmail());
            preparedStatement.setString(2, utente.getPassword());
            preparedStatement.setString(3, utente.getNome());
            preparedStatement.setString(4, utente.getCognome());
            
            // Gestione LocalDate -> java.sql.Date
            if (utente.getDataNascita() != null) {
                preparedStatement.setDate(5, java.sql.Date.valueOf(utente.getDataNascita()));
            } else {
                preparedStatement.setNull(5, java.sql.Types.DATE);
            }
            
            preparedStatement.setString(6, utente.getIndirizzo());
            preparedStatement.setString(7, utente.getTelefono());
            
            // Gestione Enum -> String
            preparedStatement.setString(8, utente.getRuolo() != null ? utente.getRuolo().name() : null);

            preparedStatement.executeUpdate();
        }
    }

    @Override
    public void doUpdate(Utente utente) throws SQLException {
        String updateSQL = "UPDATE " + TABLE_NAME + " SET password = ?, nome = ?, cognome = ?, data_nascita = ?, indirizzo = ?, telefono = ?, ruolo = ? WHERE email = ?";

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {
            
            preparedStatement.setString(1, utente.getPassword());
            preparedStatement.setString(2, utente.getNome());
            preparedStatement.setString(3, utente.getCognome());
            
            if (utente.getDataNascita() != null) {
                preparedStatement.setDate(4, java.sql.Date.valueOf(utente.getDataNascita()));
            } else {
                preparedStatement.setNull(4, java.sql.Types.DATE);
            }
            
            preparedStatement.setString(5, utente.getIndirizzo());
            preparedStatement.setString(6, utente.getTelefono());
            preparedStatement.setString(7, utente.getRuolo() != null ? utente.getRuolo().name() : null);
            preparedStatement.setString(8, utente.getEmail());

            preparedStatement.executeUpdate();
        }
    }

    @Override
    public boolean doDelete(String email) throws SQLException {
        String deleteSQL = "DELETE FROM " + TABLE_NAME + " WHERE email = ?";
        int result = 0;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(deleteSQL)) {
            
            preparedStatement.setString(1, email);
            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public Utente doRetrieveByKey(String email) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE email = ?";
        Utente utente = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, email);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next())
                    utente = leggiDBUtente(rs);
                
            }
        }
        return utente;
    }

    @Override
    public Collection<Utente> doRetrieveByRuolo(Ruolo ruoloScelto) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE ruolo = ?";
        Collection<Utente> utenti = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, ruoloScelto.name());

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {              
                    utenti.add(leggiDBUtente(rs));
                }
            }
        }
        return utenti;
    }

    @Override
    public Collection<Utente> doRetrieveAll(String order) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME;

        if (order != null && !order.trim().isEmpty()) {
            selectSQL += " ORDER BY " + order;
        }

        Collection<Utente> utenti = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {             
                utenti.add(leggiDBUtente(rs));
            }
        }
        return utenti;
    }
    
    private Utente leggiDBUtente(ResultSet rs) throws SQLException {
        Utente utente = new Utente();
        utente.setEmail(rs.getString("email"));
        utente.setPassword(rs.getString("password"));
        utente.setNome(rs.getString("nome"));
        utente.setCognome(rs.getString("cognome"));
        
        java.sql.Date dbDate = rs.getDate("data_nascita");
        if (dbDate != null) {
            utente.setDataNascita(dbDate.toLocalDate());
        }
        
        utente.setIndirizzo(rs.getString("indirizzo"));
        utente.setTelefono(rs.getString("telefono"));
        
        String ruoloStr = rs.getString("ruolo");
        if (ruoloStr != null) {
            utente.setRuolo(Ruolo.valueOf(ruoloStr));
        }
        
        return utente;
    }
}