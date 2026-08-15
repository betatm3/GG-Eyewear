package model;

import java.util.ArrayList;

public class Carrello {
	private ArrayList<ProdottoAcquistato> prodotti;
	
	public Carrello() {
        this.prodotti = new ArrayList<>();
    }
	
	public void addProdotto(ProdottoAcquistato nuovo) {
        // Controlliamo se lo STESSO identico prodotto (stessa versione e colore) è già nel carrello
        for (ProdottoAcquistato p : prodotti) {
            if (p.getVersioneOcchiale().getOcchiale().getId() == nuovo.getOcchiale().getId() &&
                p.getVersioneOcchiale().getCodice() == nuovo.getVersioneOcchiale().getCodice() &&
                p.getColore().getCodice().equalsIgnoreCase(nuovo.getColore().getCodice())) {
                
                p.setQuantita(p.getQuantita() + nuovo.getQuantita());
                return;
            }
        }
        prodotti.add(nuovo);
    }
	
	public void rimuoviProdotto(int idOcchiale, int codiceVersione, String codiceColore) {
        for (ProdottoAcquistato p : prodotti) {
        	if (p.getVersioneOcchiale().getOcchiale().getId() == idOcchiale && 
                p.getVersioneOcchiale().getCodice() == codiceVersione && 
                p.getColore().getCodice().equalsIgnoreCase(codiceColore)) {        
                
        		prodotti.remove(p); 
                break;
            }
        }
    }
	
	public void modificaQuantita(int idOcchiale, int codiceVersione, String codiceColore, int nuovaQuantita) {
        if (nuovaQuantita <= 0) {
            rimuoviProdotto(idOcchiale, codiceVersione, codiceColore);
            return;
        }
        for (ProdottoAcquistato p : prodotti) {
            if (p.getVersioneOcchiale().getOcchiale().getId() == idOcchiale &&
                p.getVersioneOcchiale().getCodice() == codiceVersione &&
                p.getColore().getCodice().equalsIgnoreCase(codiceColore)) {
                
                p.setQuantita(nuovaQuantita);
                break;
            }
        }
    }
	
	public double getTotale() {
        double totale = 0.0;
        for (ProdottoAcquistato p : prodotti) {
            totale += p.getVersioneOcchiale().getPrezzo() * p.getQuantita();
        }
        return totale;
    }

    public boolean isEmpty() {
        return prodotti.isEmpty();
    }

    public ArrayList<ProdottoAcquistato> getProdotti() {
		return prodotti;
	}

	public void setProdotti(ArrayList<ProdottoAcquistato> prodotti) {
		this.prodotti = prodotti;
	}

	public void svuota() {
        prodotti.clear();
    }
    

}
