package model;

import java.util.ArrayList;
import java.util.Collection;

public class Occhiale implements Cloneable{
	private int id;
	private boolean attivo;
	private Tipologia tipo;
	private byte[] immagine; // <-- NUOVO ATTRIBUTO PER IL BLOB
	private VersioneOcchiale versioneCorrente; 
	private Collection<Disponibile> disponibilita; 

	
   	public Occhiale(int id, boolean attivo, Tipologia tipo, byte[] immagine, VersioneOcchiale versioneCorrente,
			Collection<Disponibile> disponibilita) {
		super();
		this.id = id;
		this.attivo = attivo;
		this.tipo = tipo;
		this.immagine = immagine;
		this.versioneCorrente = versioneCorrente.clone();
		this.disponibilita = disponibilita;
	}

	public Occhiale() {
	}
	
	public int getId() {
		return id;
	}
	public boolean isAttivo() {
		return attivo;
	}
	public void setId(int id) {
		this.id = id;
	}
	public void setAttivo(boolean attivo) {
		this.attivo = attivo;
	}
	
    public byte[] getImmagine() {
        return immagine != null ? immagine.clone() : null;
    }

    public void setImmagine(byte[] immagine) {
        this.immagine = immagine != null ? immagine.clone() : null;
    }

    public Tipologia getTipo() {
		return tipo;
	}

	public void setTipo(Tipologia tipo) {
		this.tipo = tipo;
	}

	public VersioneOcchiale getVersioneCorrente() {
		return versioneCorrente.clone();
	}

	public Collection<Disponibile> getDisponibilita() {
		if (this.disponibilita == null) {
	        return null;
	    }
	    
	    Collection<Disponibile> copia = new java.util.ArrayList<>();
	    for (Disponibile disp : this.disponibilita) {
	        if (disp != null) {
	            copia.add((Disponibile) disp.clone());
	        } else {
	            copia.add(null);
	        }
	    }
	    return copia;
	}

	public void setVersioneCorrente(VersioneOcchiale versioneCorrente) {
	    if (versioneCorrente != null) {
	        this.versioneCorrente = (VersioneOcchiale) versioneCorrente.clone();
	    } else {
	        this.versioneCorrente = null;
	    }
	}

	public void setDisponibilita(Collection<Disponibile> disponibilita) {
			if (disponibilita == null) {
		        this.disponibilita = null;
		        return;
		    }
		    
		    Collection<Disponibile> copia = new java.util.ArrayList<>();
		    for (Disponibile disp : disponibilita) {
		        if (disp != null) {
		            copia.add((Disponibile) disp.clone()); 
		        } else {
		            copia.add(null);
		        }
		    }
		    this.disponibilita = copia;
	}

	@Override
    public Occhiale clone(){
    	try {
            Occhiale cloned = (Occhiale) super.clone();
            if (this.immagine != null) {
                cloned.immagine = this.immagine.clone();
            }
            if (this.versioneCorrente != null) {
                cloned.versioneCorrente = this.versioneCorrente.clone();
            }
            
            if (this.disponibilita != null) {
                ArrayList<Disponibile> clonedDisp = new ArrayList<>();
                for (Disponibile disp : this.disponibilita) {
                    if (disp != null) {
                        clonedDisp.add((Disponibile) disp.clone());
                    } else {
                        clonedDisp.add(null);
                    }
                }
                cloned.disponibilita = clonedDisp;
            }
            return cloned;
        } catch (CloneNotSupportedException e) {
            return null;
        }
    }

	@Override
	public String toString() {
		return getClass().getName()+" [id=" + id + ", attivo=" + attivo + ", tipo= "+tipo+ "versioneCorrente= "+versioneCorrente+", disponibilita=" + disponibilita+ "]";
	}
	
}
