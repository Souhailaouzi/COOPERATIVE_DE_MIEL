package com;

public class Product {
    private int id;
    private String nom;
    private String description;
    private double prix;
    private int quantite;
    private String image;
    private String poids;
    
    // Constructors
    public Product() {}
    
    public Product(int id, String nom, String description, double prix, int quantite, String image, String poids) {
        this.id = id;
        this.nom = nom;
        this.description = description;
        this.prix = prix;
        this.quantite = quantite;
        this.image = image;
        this.poids = poids;
    }
    
    // Getters and Setters
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
    
    public String getPoids() {
        return poids;
    }
    
    public void setPoids(String poids) {
        this.poids = poids;
    }
}