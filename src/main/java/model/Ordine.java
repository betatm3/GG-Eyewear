package model;

import java.time.LocalDateTime;

public class Ordine implements Cloneable{
	private int id;
	private String metodoPagamento;
	private LocalDateTime dataOrdine;
	private Stato stato;
	private double totale;
	private Utente utente;
	
	
	public Ordine(int id, String metodoPagamento, LocalDateTime dataOrdine, Stato stato, double totale,
			Utente utente) {
		this.id = id;
		this.metodoPagamento = metodoPagamento;
		this.dataOrdine = dataOrdine;
		this.stato = stato;
		this.totale = totale;
		this.utente = utente.clone();
	}
	
	public Ordine() {
	}
	
	public int getId() {
		return id;
	}
	public String getMetodoPagamento() {
		return metodoPagamento;
	}
	public LocalDateTime getDataOrdine() {
		return dataOrdine;
	}
	public Stato getStato() {
		return stato;
	}
	public double getTotale() {
		return totale;
	}
	public Utente getUtente() {
		return utente.clone();
	}
	public void setId(int id) {
		this.id = id;
	}
	public void setMetodoPagamento(String metodoPagamento) {
		this.metodoPagamento = metodoPagamento;
	}
	public void setDataOrdine(LocalDateTime dataOrdine) {
		this.dataOrdine = dataOrdine;
	}
	public void setStato(Stato stato) {
		this.stato = stato;
	}
	public void setTotale(double totale) {
		this.totale = totale;
	}
	public void setUtente(Utente utente) {
		this.utente = utente.clone();
	}

	
	@Override
	public boolean equals(Object o) {
	    if (o == null || getClass() != o.getClass()) return false;
	    Ordine ordine = (Ordine) o;
	    return id == ordine.id; 
	}



	@Override
    public Ordine clone(){
        try{
        	Ordine cloned = (Ordine) super.clone();
        	if(utente!=null)   		cloned.utente = utente.clone();
        	else	cloned.utente=null;
        	return cloned;
        } catch (CloneNotSupportedException e) {
            return null;
        }
    }

	@Override
	public String toString() {
		return getClass().getName()+"[id=" + id + ", metodoPagamento=" + metodoPagamento + ", dataOrdine=" + dataOrdine + ", stato="
				+ stato + ", totale=" + totale + ", utente=" + utente + "]";
	}

}
