<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.util" %>
<%@ page import="com.Product" %>
<%@ page import="com.ProductDAO" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Administration - APIGOLD</title>
    <link rel="stylesheet" href="admin.css">
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
                <li><a href="#ajouter">AJOUTER</a></li>
                <li><a href="home.html">DECONNEXION</a></li>
                <li><a href=""></a></li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h1>Gestion des Produits de Miel</h1>
        
        <% 
            // Display success messages
            String success = request.getParameter("success");
            if (success != null) {
                if (success.equals("add")) {
        %>
                <div class="success-message">Produit ajouté avec succès!</div>
        <%
                } else if (success.equals("update")) {
        %>
                <div class="success-message">Produit mis à jour avec succès!</div>
        <%
                } else if (success.equals("delete")) {
        %>
                <div class="success-message">Produit supprimé avec succès!</div>
        <%
                }
            }
            
            // Display error messages
            String error = request.getParameter("error");
            if (error != null) {
                if (error.equals("add")) {
        %>
                <div class="error-message">Erreur lors de l'ajout du produit!</div>
        <%
                } else if (error.equals("update")) {
        %>
                <div class="error-message">Erreur lors de la mise à jour du produit!</div>
        <%
                } else if (error.equals("delete")) {
        %>
                <div class="error-message">Erreur lors de la suppression du produit!</div>
        <%
                } else if (error.equals("search")) {
        %>
                <div class="error-message">Erreur lors de la recherche!</div>
        <%
                } else if (error.equals("notfound")) {
        %>
                <div class="error-message">Produit non trouvé!</div>
        <%
                }
            }
        %>

        <!-- Barre de recherche -->
        <div class="search-bar">
            <form action="rechercheProduit" method="get">
                <input type="text" name="recherche" placeholder="Rechercher un produit...">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
        </div>
        
        <% 
            // Display search results if any
            String search = request.getParameter("search");
            boolean isSearchResults = search != null && search.equals("true");
            String searchTitle = "Tous les Produits";
            
            if (isSearchResults) {
                String keyword = (String) session.getAttribute("searchKeyword");
                searchTitle = "Résultats de recherche pour '" + keyword + "'";
        %>
                <div class="search-results-header">
                    <h2><%= searchTitle %></h2>
                    <a href="admin.jsp" class="btn-secondary">Voir tous les produits</a>
                </div>
        <%
            }
        %>

        <!-- Tableau des produits -->
        <table>
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Description</th>
                    <th>Prix</th>
                    <th>Quantité</th>
                    <th>Image</th>
                    <th>Poids</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    ProductDAO productDAO = new ProductDAO();
                    List<Product> products;
                    
                    if (isSearchResults) {
                        products = (List<Product>) session.getAttribute("searchResults");
                    } else {
                        products = productDAO.getAllProducts();
                    }
                    
                    if (products != null && !products.isEmpty()) {
                        for (Product product : products) {
                %>
                            <tr>
                                <td><%= product.getNom() %></td>
                                <td><%= product.getDescription() %></td>
                                <td><%= product.getPrix() %> €</td>
                                <td><%= product.getQuantite() %></td>
                                <td><img src="img/<%= product.getImage() %>" alt="<%= product.getNom() %>" width="50"></td>
                                <td><%= product.getPoids() %></td>
                                <td class="actions">
                                    <a href="modifierProduit?id=<%= product.getId() %>" class="edit-btn" title="Modifier"><i class="fas fa-edit"></i></a>
                                    <a href="supprimerProduit?id=<%= product.getId() %>" class="delete-btn" title="Supprimer" 
                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce produit?');"><i class="fas fa-trash"></i></a>
                                </td>
                            </tr>
                <%
                        }
                    } else {
                %>
                        <tr>
                            <td colspan="7" class="no-data">Aucun produit trouvé</td>
                        </tr>
                <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                %>
                    <tr>
                        <td colspan="7" class="error-data">Erreur lors de la récupération des produits</td>
                    </tr>
                <%
                }
                %>
            </tbody>
        </table>

        <!-- Formulaire pour ajouter un produit -->
        <div class="add-product-form" id="ajouter">
            <h2>Ajouter un Nouveau Produit</h2>
            <form action="ajouterProduit" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="nom">Nom du Produit</label>
                    <input type="text" id="nom" name="nom" placeholder="Nom du produit" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" placeholder="Description"></textarea>
                </div>
                
                <div class="form-group">
                    <label for="prix">Prix (€)</label>
                    <input type="number" id="prix" name="prix" placeholder="Prix" step="0.01" required>
                </div>
                
                <div class="form-group">
                    <label for="quantite">Quantité en Stock</label>
                    <input type="number" id="quantite" name="quantite" placeholder="Quantité" required>
                </div>
                
                <div class="form-group">
                    <label for="image">Image</label>
                    <input type="file" id="image" name="image" accept="image/*" required>
                </div>
                
                <div class="form-group">
                    <label for="poids">Poids</label>
                    <input type="text" id="poids" name="poids" placeholder="Poids (ex: 500g)" required>
                </div>
                
                <button type="submit" class="btn-primary">Ajouter</button>
            </form>
        </div>
    </div>
    
    <script>
        // Afficher les messages de succès/erreur pendant 5 secondes seulement
        setTimeout(function() {
            var messages = document.querySelectorAll('.success-message, .error-message');
            for (var i = 0; i < messages.length; i++) {
                messages[i].style.display = 'none';
            }
        }, 5000);
    </script>
</body>
</html>