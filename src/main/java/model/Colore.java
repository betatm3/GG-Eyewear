package model;

public class Colore implements  Cloneable{
	private int idColore;
    private String codice;
    private String nome;
    private String hex;
	
	public Colore(int idColore, String codice, String nome, String hex) {
		this.idColore = idColore;
		this.codice = codice;
		this.nome = nome;
		this.hex = hex;
	}
	
	public Colore() {
	}
	
	public String getCodice() {
		return codice;
	}
	public String getNome() {
		return nome;
	}
	
	
	public int getIdColore() {
		return idColore;
	}

	public String getHex() {
		return hex;
	}

	public void setIdColore(int idColore) {
		this.idColore = idColore;
	}

	public void setHex(String hex) {
		this.hex = hex;
	}

	public void setCodice(String codice) {
		this.codice = codice;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}

	@Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Colore colore = (Colore) o;
        return idColore == colore.idColore;
    }
	
    @Override
    public Colore clone(){
        try{
            return (Colore) super.clone();
        } catch (CloneNotSupportedException e) {
            return null;
        }
    }

	@Override
	public String toString() {
		return getClass().getName()+"[codice=" + codice + ", nome=" + nome + "]";
	}

}
