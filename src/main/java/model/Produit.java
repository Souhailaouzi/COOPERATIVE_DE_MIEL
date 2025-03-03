package model;

public class Produit {
    private int id;
    private String nom;
    private String description;
    private double prix;
    private String poids;
    private int quantite;
    private String image;
    
    public Produit() {
    }
    
    public Produit(int id, String nom, String description, double prix, String poids, int quantite, String image) {
        this.id = id;
        this.nom = nom;
        this.description = description;
        this.prix = prix;
        this.poids = poids;
        this.quantite = quantite;
        this.image = image;
    }
    
    // Getters et Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getNom() {
        return nom;
    }
    
    public void setNom(String nom) {
        this.nom = nom;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public double getPrix() {
        return prix;
    }
    
    public void setPrix(double prix) {
        this.prix = prix;
    }
    
    public String getPoids() {
        return poids;
    }
    
    public void setPoids(String poids) {
        this.poids = poids;
    }
    
    public int getQuantite() {
        return quantite;
    }
    
    public void setQuantite(int quantite) {
        this.quantite = quantite;
    }
    
    public String getImage() {
        return image;
    }
    
    public void setImage(String image) {
        this.image = image;
    }
}