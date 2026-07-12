package model;

import java.time.LocalDate;

public class Utente implements Cloneable{
	private String email;
	private String password;
	private String nome;
	private String cognome;
	private LocalDate dataNascita;
	private String indirizzo;
	private String telefono;
	private Ruolo ruolo;

	
	public Utente(String email, String password, String nome, String cognome, LocalDate dataNascita, String indirizzo,
			String telefono, Ruolo ruolo) {
		this.email = email;
		this.password = password;
		this.nome = nome;
		this.cognome = cognome;
		this.dataNascita = dataNascita;
		this.indirizzo = indirizzo;
		this.telefono = telefono;
		this.ruolo = ruolo;
	}
	
	public Utente() {
	}
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	
	public String getCognome() {
		return cognome;
	}
	public void setCognome(String cognome) {
		this.cognome = cognome;
	}
	
	public String getIndirizzo() {
		return indirizzo;
	}
	public void setIndirizzo(String indirizzo) {
		this.indirizzo = indirizzo;
	}
	
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	
	public Ruolo getRuolo() {
		return ruolo;
	}
	public void setRuolo(Ruolo ruolo) {
		this.ruolo = ruolo;
	}
	
	public boolean isAdmin() {
		return this.ruolo != null && this.ruolo == Ruolo.AMMINISTRATORE;
	}
	
	public LocalDate getDataNascita() {
		return dataNascita;
	}
	public void setDataNascita(LocalDate dataNascita) {
		this.dataNascita = dataNascita;
	}

    @Override
    public Utente clone(){
        try{
            return (Utente) super.clone();
        } catch (CloneNotSupportedException e) {
            return null;
        }
    }

	@Override
	public String toString() {
		return getClass().getName()+" [email=" + email + ", password=" + password + ", nome=" + nome + ", cognome=" + cognome
				+ ", dataNascita=" + dataNascita + ", indirizzo=" + indirizzo + ", telefono=" + telefono + ", ruolo="
				+ ruolo + "]";
	}
	
}
