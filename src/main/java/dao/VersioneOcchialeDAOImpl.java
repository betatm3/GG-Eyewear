package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.ArrayList;
import javax.sql.DataSource;

import model.VersioneOcchiale;
import model.Colore;
import model.Genere;
import model.Montatura;
import model.Occhiale;
import model.Tipologia;

public class VersioneOcchialeDAOImpl implements VersioneOcchialeDAO {

    private DataSource ds;
    public static final String TABLE_NAME = "versione_occhiale";

    public VersioneOcchialeDAOImpl(DataSource ds) {
        this.ds = ds;
    }

    @Override
    public boolean doSave(VersioneOcchiale versione) throws SQLException {
        String insertSQL = "INSERT INTO " + TABLE_NAME + " (codice, marca, modello, genere, taglia, montatura, forma, materiale, prezzo, corrente, occhiale_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int result = 0;
        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {
            
            preparedStatement.setInt(1, versione.getCodice());
            preparedStatement.setString(2, versione.getMarca());
            preparedStatement.setString(3, versione.getModello());
            preparedStatement.setString(4, versione.getGenere() != null ? versione.getGenere().name() : null);
            preparedStatement.setString(5, versione.getTaglia());
            preparedStatement.setString(6, versione.getMontatura()!= null ? versione.getMontatura().name() : null);
            preparedStatement.setString(7, versione.getForma());
            preparedStatement.setString(8, versione.getMateriale());
            preparedStatement.setDouble(9, versione.getPrezzo());
            preparedStatement.setBoolean(10, versione.isCorrente());
            preparedStatement.setInt(11, versione.getOcchiale() != null ? versione.getOcchiale().getId() : 0);

            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
    }

    @Override
    public boolean doUpdate(VersioneOcchiale versione) throws SQLException {
        String updateSQL = "UPDATE " + TABLE_NAME + " SET marca = ?, modello = ?, genere = ?, taglia = ?, montatura = ?, forma = ?, materiale = ?, prezzo = ?, corrente = ? WHERE occhiale_id = ? AND codice = ?";
        int result = 0;
        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {
            
        	preparedStatement.setString(1, versione.getMarca());
            preparedStatement.setString(2, versione.getModello());
            preparedStatement.setString(3, versione.getGenere() != null ? versione.getGenere().name() : null);
            preparedStatement.setString(4, versione.getTaglia());
            preparedStatement.setString(5, versione.getMontatura()!= null ? versione.getMontatura().name() : null);
            preparedStatement.setString(6, versione.getForma());
            preparedStatement.setString(7, versione.getMateriale());
            preparedStatement.setDouble(8, versione.getPrezzo());
            preparedStatement.setBoolean(9, versione.isCorrente());
            preparedStatement.setInt(10, versione.getOcchiale() != null ? versione.getOcchiale().getId() : 0);
            preparedStatement.setInt(11, versione.getCodice());

            result = preparedStatement.executeUpdate();
        }
        return (result != 0);
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
    public VersioneOcchiale doRetrieveByKey(int codice, int idOcchiale) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE codice = ? AND occhiale_id = ?";
        VersioneOcchiale versione = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setInt(1, codice);
            preparedStatement.setInt(2, idOcchiale);

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
    public Collection<VersioneOcchiale> doRetrieveByMontatura(Montatura montaturaScelta) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE montatura = ?";
        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, montaturaScelta!= null ? montaturaScelta.name() : null);

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
    public VersioneOcchiale doRetrieveCorrenteByOcchiale(int idOcchiale) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE occhiale_id = ? AND corrente = TRUE";
        VersioneOcchiale versione = null;

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {

            preparedStatement.setInt(1, idOcchiale);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    versione = leggiDBVersioneOcchiale(rs);
                }
            }
        }
        return versione; 
    }
    
    @Override
    public Collection<VersioneOcchiale> doRetrieveByMarca(String marcaScelta) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE marca = ?";
        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, marcaScelta);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBVersioneOcchiale(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public Collection<VersioneOcchiale> doRetrieveByModello(String modelloScelto) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE modello = ?";
        Collection<VersioneOcchiale> lista = new ArrayList<>();

        try (Connection connection = ds.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setString(1, modelloScelto);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lista.add(leggiDBVersioneOcchiale(rs));
                }
            }
        }
        return lista;
    }
    
    @Override
    public Collection<VersioneOcchiale> doRetrieveByFiltri(Genere genere, Montatura montatura, String materiale, String forma, String marca, String colore, String taglia, Double prezzoMin, Double prezzoMax) throws SQLException {
        Collection<VersioneOcchiale> lista = new ArrayList<>();
        
        // Convertiamo il nome del colore nel suo ID tramite il ColoreDAO se è stato passato
        String codiceColore = null;
        if (colore != null && !colore.trim().isEmpty()) {
            ColoreDAOImpl coloreDAO = new ColoreDAOImpl(ds);
            Colore c = coloreDAO.doRetrieveByNome(colore);
            
            if (c != null) {
            	codiceColore = c.getCodice(); 
            } else {
                // Se il colore cercato non esiste, restituiamo la lista vuota
                return lista; 
            }
        }
        
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT v.*, o.id AS o_id, o.attivo AS o_attivo, o.tipologia AS o_tipologia FROM versione_occhiale v " +
            "JOIN occhiale o ON v.occhiale_id = o.id "
        );
        
        // Per filtrare per colore, aggiungiamo la JOIN con la tabella disponibilità
        if (codiceColore != null) {
            sql.append("JOIN disponibilita d ON o.id = d.occhiale_id ");
        }
        
        sql.append("WHERE o.attivo = true AND v.corrente = true");
        
        if (genere != null) {
            sql.append(" AND v.genere = ?");
        }
        if (montatura != null) {
            sql.append(" AND v.montatura = ?");
        }
        if (materiale != null && !materiale.trim().isEmpty()) {
            sql.append(" AND v.materiale = ?");
        }
        if (forma != null && !forma.trim().isEmpty()) {
            sql.append(" AND v.forma = ?");
        }
        if (marca != null && !marca.trim().isEmpty()) {
            sql.append(" AND v.marca = ?");
        }
        if (codiceColore != null) {
            sql.append(" AND d.colore_codice = ?"); 
        }
        if (taglia != null && !taglia.trim().isEmpty()) {
            sql.append(" AND v.taglia = ?");
        }
        if (prezzoMin != null) {
            sql.append(" AND v.prezzo >= ?");
        }
        if (prezzoMax != null) {
            sql.append(" AND v.prezzo <= ?");
        }
        
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int index = 1;
            
            if (genere != null) {
                ps.setString(index++, genere.name());
            }
            if (montatura != null) {
                ps.setString(index++, montatura.name());
            }
            if (materiale != null && !materiale.trim().isEmpty()) {
                ps.setString(index++, materiale);
            }
            if (forma != null && !forma.trim().isEmpty()) {
                ps.setString(index++, forma);
            }
            if (marca != null && !marca.trim().isEmpty()) {
                ps.setString(index++, marca);
            }
            if (codiceColore != null) {
                ps.setString(index++, codiceColore);
            }
            if (taglia != null && !taglia.trim().isEmpty()) {
                ps.setString(index++, taglia);
            }
            if (prezzoMin != null) {
                ps.setDouble(index++, prezzoMin);
            }
            if (prezzoMax != null) {
                ps.setDouble(index++, prezzoMax);
            }
            
            ResultSet rs = ps.executeQuery();
            OcchialeDAOImpl occhialeDAO = new OcchialeDAOImpl(ds);
            
            while (rs.next()) {
                VersioneOcchiale versione = new VersioneOcchiale();
                
                // Settiamo tutti gli attributi di VersioneOcchiale
                versione.setCodice(rs.getInt("codice"));
                versione.setTaglia(rs.getString("taglia"));
                versione.setForma(rs.getString("forma"));
                versione.setMateriale(rs.getString("materiale"));
                versione.setPrezzo(rs.getDouble("prezzo"));
                versione.setCorrente(rs.getBoolean("corrente"));
                versione.setMarca(rs.getString("marca"));
                versione.setModello(rs.getString("modello"));
                
                String genereStr = rs.getString("genere");
                if (genereStr != null) {
                    versione.setGenere(Genere.valueOf(genereStr));
                }
                
                String montaturaStr = rs.getString("montatura");
                if (montaturaStr != null) {
                    versione.setMontatura(Montatura.valueOf(montaturaStr));
                }

                // Mappiamo l'oggetto Occhiale
                Occhiale occhialeAssociato = new Occhiale();
                occhialeAssociato.setId(rs.getInt("o_id")); 
                occhialeAssociato.setAttivo(rs.getBoolean("o_attivo"));
                
                String tipologiaStr = rs.getString("o_tipologia");
                if (tipologiaStr != null) {
                    occhialeAssociato.setTipo(Tipologia.valueOf(tipologiaStr));
                }

                occhialeAssociato.setImmagini(occhialeDAO.getImmaginiByOcchialeId(occhialeAssociato.getId()));

                versione.setOcchiale(occhialeAssociato);
                lista.add(versione);
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
        
        v.setMarca(rs.getString("marca"));
        v.setModello(rs.getString("modello"));
        
        String genereStr = rs.getString("genere");
        if (genereStr != null) {
            v.setGenere(Genere.valueOf(genereStr));
        }
        
        v.setTaglia(rs.getString("taglia"));
        
        String montaturaStr = rs.getString("montatura");
        if (montaturaStr != null) {
            v.setMontatura(Montatura.valueOf(montaturaStr));
        }
        
        v.setForma(rs.getString("forma"));
        v.setMateriale(rs.getString("materiale"));
        v.setPrezzo(rs.getDouble("prezzo"));
        v.setCorrente(rs.getBoolean("corrente"));
        
        OcchialeDAOImpl occDAO = new OcchialeDAOImpl(ds);
        int idOcchiale = rs.getInt("occhiale_id");
        v.setOcchiale(occDAO.doRetrieveByKey(idOcchiale));
    
        return v;
    }

 
}
