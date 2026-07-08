package model;

public class Disponibile {
	private Colore colore;
	private Occhiale occhiale;
	private int quantita;
	
	public Disponibile(Colore colore, Occhiale occhiale, int quantita) {
		this.colore = colore;
		this.occhiale = occhiale;
		this.quantita = quantita;
	}
	
	public Disponibile() {
	}

	public Colore getColore() {
		return colore.clone();
	}

	public Occhiale getOcchiale() {
		return occhiale.clone();
	}

	public int getQuantita() {
		return quantita;
	}

	public void setColore(Colore colore) {
		this.colore = colore.clone();
	}

	public void setOcchiale(Occhiale occhiale) {
		this.occhiale = occhiale.clone();
	}

	public void setQuantita(int quantita) {
		this.quantita = quantita;
	}

	@Override
	public String toString() {
		return getClass().getName()+"[colore=" + colore + ", occhiale=" + occhiale + ", quantita=" + quantita + "]";
	}
	
	

}
