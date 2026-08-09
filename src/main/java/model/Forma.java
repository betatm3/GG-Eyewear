package model;

public enum Forma {
    
    // --- FORME CLASSICHE E GEOMETRICHE BASE ---
    RETTANGOLARE("Rettangolare"),
    QUADRATO("Quadrato / Squadrata"),
    ROTONDO("Rotondo / Rotonda"),
    OVALE("Ovale"),
    
    // --- FORME ICONICHE E STILIZZATE ---
    AVIATOR("Aviator / Goccia"),
    CAT_EYE("Cat Eye / Gatto"),
    BROWLINE("Browline / Clubmaster"),
    FARFALLA("Farfalla"),
    PANTO("Pantos / Panto"),
    CUORE("Cuore"),
    
    // --- FORME POLIGONALI E MODERNE ---
    POLIGONO("Poligonale"),
    ESAGONALE("Esagonale"),
    OTTAGONALE("Ottagonale"),
    GEOMETRICO("Geometrico"),
    
    // --- FORME SPORTIVE E TECNICHE ---
    MASCHERINA("Mascherina / Maschera"),
    AVVOLGENTE("Avvolgente"),
    
    // --- DESIGN PARTICOLARI ---
    ASIMMETRICO("Asimmetrico");

    private final String displayName;

    Forma(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    // Converte stringa nell'Enum
    public static Forma fromString(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        String cleanValue = value.trim();
        for (Forma f : Forma.values()) {
            if (f.name().equalsIgnoreCase(cleanValue) || f.displayName.equalsIgnoreCase(cleanValue)) {
                return f;
            }
        }
        return null;
    }
}