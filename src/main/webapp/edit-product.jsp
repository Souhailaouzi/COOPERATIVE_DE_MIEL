<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.Product" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier un Produit</title>
    <link rel="stylesheet" href="edit-product.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <header>
        <nav class="nav">
            <a href="#" class="logo">
                <img src="img/logo.png" alt="Logo" class="logo-image">
                <strong>APIGOLD</strong>
            </a>
            <ul>
                <li><a href="admin.jsp">RETOUR</a></li>
                <li><a href="home.html">DECONNEXION</a></li>
                
            </ul>
        </nav>
    </header>

    <div class="container">
        <h1>Modifier un Produit</h1>
        <% 
            Product product = (Product) request.getAttribute("product");
            if (product != null) {
        %>
        <div class="edit-product-form">
            <form action="modifierProduit" method="post" enctype="multipart/form-data">
                <input type="hidden" name="id" value="<%= product.getId() %>">
                
                <div class="form-group">
                    <label for="nom">Nom du Produit</label>
                    <input type="text" id="nom" name="nom" value="<%= product.getNom() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description"><%= product.getDescription() %></textarea>
                </div>
                
                <div class="form-group">
                    <label for="prix">Prix (€)</label>
                    <input type="number" id="prix" name="prix" value="<%= product.getPrix() %>" step="0.01" required>
                </div>
                
                <div class="form-group">
                    <label for="quantite">Quantité en Stock</label>
                    <input type="number" id="quantite" name="quantite" value="<%= product.getQuantite() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="poids">Poids</label>
                    <input type="text" id="poids" name="poids" value="<%= product.getPoids() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="image">Image Actuelle</label>
                    <img src="img/<%= product.getImage() %>" alt="<%= product.getNom() %>" width="100">
                    <label for="image">Nouvelle Image (laisser vide pour conserver l'actuelle)</label>
                    <input type="file" id="image" name="image" accept="image/*">
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn-primary">Enregistrer les modifications</button>
                    <a href="admin.jsp" class="btn-secondary">Annuler</a>
                </div>
            </form>
        </div>
        <% } else { %>
        <div class="error-message">
            <p>Produit non trouvé!</p>
            <a href="admin.jsp" class="btn-primary">Retour</a>
        </div>
        <% } %>
    </div>
</body>
</html>