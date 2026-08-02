package model;

public enum Taglia {
    S("S ( < 50 mm)"),
    M("M ( 51 - 54 mm)"),
    L("L ( > 55 mm)");

    private final String descrizione;

    // Costruttore dell'enum
    Taglia(String descrizione) {
        this.descrizione = descrizione;
    }

    // Getter per ottenere la stringa formattata con i millimetri
    public String getDescrizione() {
        return descrizione;
    }
}