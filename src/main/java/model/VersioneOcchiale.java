package model;
public class VersioneOcchiale implements Cloneable{
    private int codice;
    private String marca;
    private String modello;
    private Genere genere;
    private String taglia;
    private Montatura montatura;
    private String forma;
    private String materiale;
    private double prezzo;
    private boolean corrente;
    private Occhiale occhiale;

    

    public VersioneOcchiale(int codice, String marca, String modello, Genere genere, String taglia, Montatura montatura, String forma, String materiale, double prezzo, boolean corrente, Occhiale occhiale) {
		this.codice = codice;
		this.marca = marca;
		this.modello = modello;
		this.genere = genere;
		this.taglia = taglia;
		this.montatura = montatura;
		this.forma = forma;
		this.materiale = materiale;
		this.prezzo = prezzo;
		this.corrente = corrente;
		this.occhiale = occhiale;
	}

	public VersioneOcchiale() {
    }

    public void setCodice(int codice) {
        this.codice = codice;
    }
    
    public void setMarca(String marca) {
		this.marca = marca;
	}

	public void setModello(String modello) {
		this.modello = modello;
	}

	public void setGenere(Genere genere) {
        this.genere = genere;
    }

    public void setTaglia(String taglia) {
        this.taglia = taglia;
    }

    public void setMontatura(Montatura montatura) {
        this.montatura = montatura;
    }

    public void setForma(String forma) {
        this.forma = forma;
    }

    public void setPrezzo(double prezzo) {
        this.prezzo = prezzo;
    }

    public void setCorrente(boolean corrente) {
        this.corrente = corrente;
    }

    public void setMateriale(String materiale) {
        this.materiale = materiale;
    }

    public void setOcchiale(Occhiale occhiale) {
        this.occhiale = occhiale.clone();
    }

    public Genere getGenere() {
        return genere;
    }
    
    public String getMarca() {
		return marca;
	}
    
    public String getModello() {
		return modello;
	}

    public int getCodice() {
        return codice;
    }

    public String getTaglia() {
        return taglia;
    }

    public Montatura getMontatura() {
        return montatura;
    }

    public String getForma() {
        return forma;
    }

    public String getMateriale() {
        return materiale;
    }

    public double getPrezzo() {
        return prezzo;
    }

    public boolean isCorrente() {
        return corrente;
    }

    public Occhiale getOcchiale() {
        return occhiale.clone();
    }

    @Override
    public VersioneOcchiale clone(){
        try{
            VersioneOcchiale cloned = (VersioneOcchiale) super.clone();
            if(occhiale!=null)	cloned.occhiale=occhiale.clone();
            else	cloned.occhiale=null;
            
            return cloned;
        } catch (CloneNotSupportedException e) {
            return null;
        }
    }

    @Override
    public String toString() {
        return getClass().getName()+"[" +
                "codice=" + codice +
                ", marca=" + marca +
                ", modello=" + modello +
                ", genere=" + genere +
                ", taglia=" + taglia  +
                ", montatura=" + montatura  +
                ", forma=" + forma +
                ", materiale=" + materiale +
                ", prezzo=" + prezzo +
                ", corrente=" + corrente +
                ", occhiale=" + occhiale +
                ']';
    }
}
