<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Produit" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Boutique de Miel APIGOLD</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="home.css">
   <style>
        body {
            background-color: #f7f7f7;
            color: #333;
            margin-top: 60px; /* Added to account for fixed navbar */
        }
        
        header {
    position: fixed;
    top: 0;
    width: 100%;
    background-color: white; /* Ajoutez une couleur de fond si nécessaire */
    z-index: 1000; /* Assurez-vous que la barre de navigation est au-dessus du contenu */
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* Optionnel: Ajoutez une ombre pour un effet de superposition */
}
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .welcome {
            font-size: 24px;
            color: #5D4037;
        }
        
        .welcome span {
            font-weight: bold;
            color: #FF9800;
        }
        
        h1 {
            text-align: center;
            margin-bottom: 40px;
            color: #5D4037;
            font-size: 32px;
            position: relative;
        }
        
        h1::after {
            content: '🍯';
            position: absolute;
            margin-left: 10px;
        }
        
        .products-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }
        
        .product-card {
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        
        .product-image {
            width: 100%;
            height: 180px;
            object-fit: cover;
            border-bottom: 2px solid #FFC107;
        }
        
        .product-content {
            padding: 15px;
        }
        
        .product-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 5px;
            color: #5D4037;
        }
        
        .product-desc {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
            height: 60px;
            overflow: hidden;
        }
        
        .product-price {
            font-weight: bold;
            color: #FF9800;
            font-size: 18px;
            margin-bottom: 5px;
        }
        
        .product-weight {
            color: #888;
            font-size: 14px;
            margin-bottom: 15px;
        }
        
        .product-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .quantity-controls {
            display: flex;
            align-items: center;
        }
        
        .quantity-btn {
            background-color: #FFC107;
            border: none;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-weight: bold;
            font-size: 16px;
            color: white;
            transition: background-color 0.3s;
        }
        
        .quantity-btn:hover {
            background-color: #FF9800;
        }
        
        .quantity-display {
            width: 40px;
            text-align: center;
            font-weight: 500;
        }
        
        .add-to-cart {
            background-color: #5D4037;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .add-to-cart:hover {
            background-color: #4E342E;
        }
        
        /* Panier */
        .cart-section {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .cart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #FFC107;
        }
        
        .cart-title {
            font-size: 22px;
            color: #5D4037;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .cart-items {
            max-height: 300px;
            overflow-y: auto;
        }
        
        .cart-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .cart-item-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .cart-item-details h4 {
            font-size: 16px;
            margin-bottom: 3px;
            color: #5D4037;
        }
        
        .cart-item-details p {
            font-size: 14px;
            color: #888;
        }
        
        .cart-item-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .cart-quantity {
            display: flex;
            align-items: center;
        }
        
        .cart-quantity-btn {
            background-color: #FFC107;
            border: none;
            width: 25px;
            height: 25px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
            color: white;
        }
        
        .cart-quantity-display {
            width: 30px;
            text-align: center;
            font-weight: 500;
        }
        
        .remove-from-cart {
            background-color: #F44336;
            color: white;
            border: none;
            width: 25px;
            height: 25px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }
        
        .cart-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 2px solid #FFC107;
            font-size: 18px;
            font-weight: 600;
        }
        
        .validate-order {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            margin-top: 15px;
            width: 100%;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        
        .validate-order:hover {
            background-color: #3e8e41;
        }
        
        .validate-order:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
        }
        
        /* Message de confirmation */
        .message-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            transition: transform 0.3s, opacity 0.3s;
            transform: translateX(100%);
            opacity: 0;
        }
        
        .message {
            padding: 15px 20px;
            border-radius: 5px;
            color: white;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        
        .success {
            background-color: #4CAF50;
        }
        
        .error {
            background-color: #F44336;
        }
        
        .message-visible {
            transform: translateX(0);
            opacity: 1;
        }
        
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1001;
            justify-content: center;
            align-items: center;
        }
        
        .modal-content {
            background-color: #fff;
            border-radius: 8px;
            max-width: 500px;
            width: 90%;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        
        .modal-title {
            color: #5D4037;
            font-size: 24px;
            margin-bottom: 15px;
        }
        
        .modal-message {
            margin-bottom: 25px;
            font-size: 16px;
            line-height: 1.5;
        }
        
        .modal-close {
            background-color: #5D4037;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        
        .modal-close:hover {
            background-color: #4E342E;
        }

        /* Footer */
        footer {
            background-color: var(--primary, #FF8C00); /* Bright orange as default with fallback */
            color: white;
            padding: 40px 0 20px;
            margin-top: 50px;
        }

        .footer-content {
            display: flex;
            justify-content: space-around; /* Changed from space-between for better spacing */
            flex-wrap: wrap;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            gap: 40px; /* Added gap between sections */
        }

        .footer-section {
            flex: 1;
            min-width: 280px;
            margin-bottom: 30px;
            padding: 0 15px; /* Added padding for better separation */
        }

        .footer-section h3 {
            font-size: 20px;
            margin-bottom: 20px;
            color: white; /* Changed from yellow for better contrast */
            position: relative;
            padding-bottom: 10px;
        }

        .footer-section h3::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 50px;
            height: 2px;
            background-color: white;
        }

        .footer-section p, .footer-section a {
            color: white;
            margin-bottom: 15px;
            display: block;
            text-decoration: none;
            font-size: 16px;
            line-height: 1.6;
        }

        .footer-section a:hover {
            transform: translateX(5px);
            transition: transform 0.3s;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 25px;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
            margin-top: 20px;
            color: white;
            font-size: 14px;
        }

        .social-links {
            display: flex;
            gap: 20px;
            margin-top: 15px;
        }

        .social-links a {
            color: white;
            font-size: 22px;
            transition: transform 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
        }

        .social-links a:hover {
            transform: scale(1.15);
            background: rgba(255, 255, 255, 0.2);
        }

        /* Make the footer responsive */
        @media (max-width: 768px) {
            .footer-content {
                flex-direction: column;
                gap: 30px;
            }
            
            .footer-section {
                min-width: 100%;
                padding: 0;
            }
            
            .products-container {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            }
            
            .nav ul {
                display: none;
            }
        }
    </style>
</head>
<body>
    <!-- Header with navigation from home page -->
    <header>
        <nav class="nav">
            <a href="#" class="logo">
                <img src="img/logo.png" alt="Logo" class="logo-image">
               <strong>APIGOLD</strong>
            </a>
            <ul>
               
                <li><a href="#"></a></li>
                <li><a href="#"></a></li>
                <li><a href="#"></a></li>
                 <li><a href="home.html">Accueil</a></li>
                <li><a href="home.html">Déconnexion</a></li>
            </ul>
        </nav>
    </header>
    <br>

    <div class="container">

        <h1><div class="welcome">Bienvenue <span>${sessionScope.username}</span> dans notre boutique de miel APIGOLD</div></h1>
        <div class="cart-section">
            <div class="cart-header">
                <div class="cart-title">
                    <i class="fas fa-shopping-cart"></i> Mon Panier
                </div>
                <button id="clear-cart" class="remove-from-cart" title="Vider le panier">
                    <i class="fas fa-trash"></i>
                </button>
            </div>

            <div id="cart-items" class="cart-items">
                <div class="empty-cart">Votre panier est vide</div>
            </div>

            <div class="cart-total">
                <span>Total:</span>
                <span id="total-price">0.00 DH</span>
            </div>
            
            <button id="validate-order" class="validate-order" disabled>
                Valider la commande
            </button>
        </div>

        <div class="products-container">
            <%
            List<Produit> produits = (List<Produit>) request.getAttribute("produits");
            if (produits != null && !produits.isEmpty()) {
                for (Produit produit : produits) {
            %>
                <div class="product-card" data-id="<%= produit.getId() %>" data-name="<%= produit.getNom() %>"
                     data-price="<%= produit.getPrix() %>" data-image="<%= produit.getImage() %>"
                     data-weight="<%= produit.getPoids() %>" data-stock="<%= produit.getQuantite() %>">
                    <img src="img/<%= produit.getImage() %>" alt="<%= produit.getNom() %>" class="product-image">
                    <div class="product-content">
                        <h3 class="product-title"><%= produit.getNom() %></h3>
                        <p class="product-desc"><%= produit.getDescription() %></p>
                        <div class="product-price"><%= String.format("%.2f", produit.getPrix()) %> DH</div>
                        <div class="product-weight">Poids: <%= produit.getPoids() %></div>
                        <div class="product-actions">
                            <div class="quantity-controls">
                                <button class="quantity-btn minus-btn">-</button>
                                <span class="quantity-display">0</span>
                                <button class="quantity-btn plus-btn">+</button>
                            </div>
                            <button class="add-to-cart">
                                <i class="fas fa-cart-plus"></i> Ajouter
                            </button>
                        </div>
                    </div>
                </div>
            <%
                }
            } else {
            %>
                <div style="grid-column: 1 / -1; text-align: center; padding: 50px;">
                    <p>Aucun produit disponible pour le moment.</p>
                </div>
            <% } %>
        </div>
    </div>

    <div class="message-container">
        <div class="message success">
            <i class="fas fa-check-circle"></i>
            <span id="message-text"></span>
        </div>
    </div>
    
    <!-- Modal for order confirmation -->
    <div id="confirmation-modal" class="modal">
        <div class="modal-content">
            <h2 class="modal-title">Commande validée !</h2>
            <p class="modal-message">
                Votre commande sera disponible dans notre boutique apigold. Soyez le bienvenue !<br>
                <strong>Montant total: <span id="modal-total">0.00</span> DH</strong>
            </p>
            <button class="modal-close">Fermer</button>
        </div>
    </div>

    

   
    <script src="cart.js"></script>
    
</body>
</html>