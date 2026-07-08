package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException; 
import java.sql.Timestamp;
import java.util.Collection;
import java.util.ArrayList;
import javax.sql.DataSource;
import model.Ordine;
import model.Utente;
import model.Stato;

public class OrdineDAOImpl implements OrdineDAO {

    private DataSource ds;
    public static final String TABLE_NAME = "ordine";

    public OrdineDAOImpl(DataSource ds) {
        this.ds = ds;
    }

    @Override
    public void doSave(Ordine ordine) throws SQLException {
        
        String insertSQL = "INSERT INTO " + TABLE_NAME + " (id, metodo_pagamento, data_ordine, stato, totale, utente_email) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {
            
            preparedStatement.setInt(1, ordine.getId());
            preparedStatement.setString(2, ordine.getMetodoPagamento());
            
            preparedStatement.setTimestamp(3, Timestamp.valueOf(ordine.getDataOrdine()));
            
            preparedStatement.setString(4, ordine.getStato() != null ? ordine.getStato().name() : null);
            preparedStatement.setDouble(5, ordine.getTotale());
            
            preparedStatement.setString(6, ordine.getUtente() != null ? ordine.getUtente().getEmail() : null);

            preparedStatement.executeUpdate();
        }
    }

    @Override
    public void doUpdate(Ordine ordine) throws SQLException {
        String updateSQL = "UPDATE " + TABLE_NAME + " SET metodo_pagamento = ?, data_ordine = ?, stato = ?, totale = ?, utente_email = ? WHERE id = ?";

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {
            
            preparedStatement.setString(1, ordine.getMetodoPagamento());
            preparedStatement.setTimestamp(2, Timestamp.valueOf(ordine.getDataOrdine()));
            preparedStatement.setString(3, ordine.getStato() != null ? ordine.getStato().name() : null);
            preparedStatement.setDouble(4, ordine.getTotale());
            preparedStatement.setString(5, ordine.getUtente() != null ? ordine.getUtente().getEmail() : null);
            preparedStatement.setInt(6, ordine.getId());

            preparedStatement.executeUpdate();
        }
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

    @Override
    public Ordine doRetrieveByKey(int id) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE id = ?";
        Ordine ordine = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setInt(1, id);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    ordine = leggiDBOrdine(rs);
                }
            }
        }
        return ordine;
    }

    @Override
    public Collection<Ordine> doRetrieveByUtente(String utente_email) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE utente_email = ?";
        Collection<Ordine> ordini = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, utente_email);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    ordini.add(leggiDBOrdine(rs));
                }
            }
        }
        return ordini;
    }

    @Override
    public Collection<Ordine> doRetrieveByStato(Stato stato) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE stato = ?";
        Collection<Ordine> ordini = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, stato != null ? stato.name() : null);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    ordini.add(leggiDBOrdine(rs));
                }
            }
        }
        return ordini;
    }

    @Override
    public Collection<Ordine> doRetrieveAll(String order) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME;

        if (order != null && !order.trim().isEmpty()) {
            selectSQL += " ORDER BY " + order;
        }

        Collection<Ordine> ordini = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                ordini.add(leggiDBOrdine(rs));
            }
        }
        return ordini;
    }

  
    private Ordine leggiDBOrdine(ResultSet rs) throws SQLException {
        Ordine ordine = new Ordine();
        ordine.setId(rs.getInt("id"));
        ordine.setMetodoPagamento(rs.getString("metodo_pagamento"));
        
        Timestamp timestamp = rs.getTimestamp("data_ordine");
        if (timestamp != null) {
            ordine.setDataOrdine(timestamp.toLocalDateTime());
        }
        
      
        String statoStr = rs.getString("stato");
        if (statoStr != null) {
            ordine.setStato(Stato.valueOf(statoStr));
        }
        
        ordine.setTotale(rs.getDouble("totale"));
        
        String utente_email = rs.getString("utente_email");
        if (utente_email != null) {
            Utente u = new Utente();
            u.setEmail(utente_email); 
            ordine.setUtente(u);
        }
        
        return ordine;
    }
}
