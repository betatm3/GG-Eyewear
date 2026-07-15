package model;

public class Recensione implements Cloneable {
    private String utenteEmail;
    private int occhialeId;
    private String descrizione;
    private int voto;

    public Recensione() {
    }

    public Recensione(String utenteEmail, int occhialeId, String descrizione, int voto) {
        this.utenteEmail = utenteEmail;
        this.occhialeId = occhialeId;
        this.descrizione = descrizione;
        setVoto(voto);
    }

    public String getUtenteEmail() {
        return utenteEmail;
    }

    public void setUtenteEmail(String utenteEmail) {
        this.utenteEmail = utenteEmail;
    }

    public int getOcchialeId() {
        return occhialeId;
    }

    public void setOcchialeId(int occhialeId) {
        this.occhialeId = occhialeId;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public int getVoto() {
        return voto;
    }

    public void setVoto(int voto) {
        if (voto < 1 || voto > 5) {
            throw new IllegalArgumentException("Il voto deve essere compreso tra 1 e 5.");
        }
        this.voto = voto;
    }

    @Override
    public Recensione clone(){
        try{
            return (Recensione) super.clone();
        } catch (CloneNotSupportedException e) {
            return null;
        }
    }
    
    @Override
    public String toString() {
        return getClass().getName()+"[" +
                "utenteEmail=" + utenteEmail  +
                ", occhialeId=" + occhialeId +
                ", descrizione=" + descrizione +
                ", voto=" + voto +
                ']';
    }
}