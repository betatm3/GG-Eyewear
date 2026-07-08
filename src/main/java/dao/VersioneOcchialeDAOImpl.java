package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.ArrayList;
import javax.sql.DataSource;

import model.VersioneOcchiale;
import model.Genere;
import model.Occhiale;

public class VersioneOcchialeDAOImpl implements VersioneOcchialeDAO {

    private DataSource ds;
    public static final String TABLE_NAME = "versione_occhiale";

    public VersioneOcchialeDAOImpl(DataSource ds) {
        this.ds = ds;
    }

    @Override
    public void doSave(VersioneOcchiale versione) throws SQLException {
        String insertSQL = "INSERT INTO " + TABLE_NAME + " (codice, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {
            
            preparedStatement.setInt(1, versione.getCodice());
            preparedStatement.setString(2, versione.getGenere() != null ? versione.getGenere().name() : null);
            preparedStatement.setString(3, versione.getTaglia());
            preparedStatement.setString(4, versione.getMontatura());
            preparedStatement.setString(5, versione.getForma());
            preparedStatement.setString(6, versione.getMateriale());
            preparedStatement.setDouble(7, versione.getPrezzo());
            preparedStatement.setBoolean(8, versione.isCorrente());
            preparedStatement.setInt(9, versione.getOcchiale() != null ? versione.getOcchiale().getId() : 0);

            preparedStatement.executeUpdate();
        }
    }

    @Override
    public void doUpdate(VersioneOcchiale versione) throws SQLException {
        String updateSQL = "UPDATE " + TABLE_NAME + " SET genere = ?, taglia = ?, montatura = ?, forma = ?, materiale = ?, prezzo = ?, corrente = ?, occhiale_id = ? WHERE codice = ?";

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {
            
            preparedStatement.setString(1, versione.getGenere() != null ? versione.getGenere().name() : null);
            preparedStatement.setString(2, versione.getTaglia());
            preparedStatement.setString(3, versione.getMontatura());
            preparedStatement.setString(4, versione.getForma());
            preparedStatement.setString(5, versione.getMateriale());
            preparedStatement.setDouble(6, versione.getPrezzo());
            preparedStatement.setBoolean(7, versione.isCorrente());
            preparedStatement.setInt(8, versione.getOcchiale() != null ? versione.getOcchiale().getId() : 0);
            preparedStatement.setInt(9, versione.getCodice());

            preparedStatement.executeUpdate();
        }
    }

    @Override
    public boolean doDelete(int codice) throws SQLException {
        String deleteSQL = "DELETE FROM " + TABLE_NAME + " WHERE codice = ?";
        int result = 0;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(deleteSQL)) {
            
            preparedStatement.setInt(1, codice);
            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public VersioneOcchiale doRetrieveByKey(int codice) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE codice = ?";
        VersioneOcchiale versione = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setInt(1, codice);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    versione = leggiDBVersioneOcchiale(rs);
                }
            }
        }
        return versione;
    }

    @Override
    public Collection<VersioneOcchiale> doRetrieveByOcchiale(int occhiale_id) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE occhiale_id = ?";
        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setInt(1,occhiale_id);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBVersioneOcchiale(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<VersioneOcchiale> doRetrieveByGenere(Genere genere) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE genere = ?";
        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, genere != null ? genere.name() : null);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBVersioneOcchiale(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<VersioneOcchiale> doRetrieveByTaglia(String tagliaScelta) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE taglia = ?";
        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, tagliaScelta);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBVersioneOcchiale(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<VersioneOcchiale> doRetrieveByMontatura(String montaturaScelta) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE montatura = ?";
        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, montaturaScelta);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBVersioneOcchiale(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<VersioneOcchiale> doRetrieveByForma(String formaScelta) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE forma = ?";
        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, formaScelta);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBVersioneOcchiale(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<VersioneOcchiale> doRetrieveByMateriale(String materialeScelto) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE materiale = ?";
        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, materialeScelto);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBVersioneOcchiale(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<VersioneOcchiale> doRetrieveByPrezzo(double prezzoScelto) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE prezzo = ?";
        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setDouble(1, prezzoScelto);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBVersioneOcchiale(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<VersioneOcchiale> doRetrieveByFasciaPrezzo(double prezzoMin, double prezzoMax) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE prezzo BETWEEN ? AND ?";
        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setDouble(1, prezzoMin);
            preparedStatement.setDouble(2, prezzoMax);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBVersioneOcchiale(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<VersioneOcchiale> doRetrieveByCorrente(boolean correnteScelta) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE corrente = ?";
        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setBoolean(1, correnteScelta);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBVersioneOcchiale(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<VersioneOcchiale> doRetrieveAll(String order) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME;

        if (order != null && !order.trim().isEmpty()) {
            selectSQL += " ORDER BY " + order;
        }

        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                lista.add(leggiDBVersioneOcchiale(rs));
            }
        }
        return lista;
    }

    private VersioneOcchiale leggiDBVersioneOcchiale(ResultSet rs) throws SQLException {
        VersioneOcchiale v = new VersioneOcchiale();
        v.setCodice(rs.getInt("codice"));
        
        String genereStr = rs.getString("genere");
        if (genereStr != null) {
            v.setGenere(Genere.valueOf(genereStr));
        }
        
        v.setTaglia(rs.getString("taglia"));
        v.setMontatura(rs.getString("montatura"));
        v.setForma(rs.getString("forma"));
        v.setMateriale(rs.getString("materiale"));
        v.setPrezzo(rs.getDouble("prezzo"));
        v.setCorrente(rs.getBoolean("corrente"));
        
        int idOcchiale = rs.getInt("occhiale_id");
        if (idOcchiale != 0) {
            Occhiale o = new Occhiale();
            o.setId(idOcchiale);
            v.setOcchiale(o);
        }
        
        return v;
    }
}