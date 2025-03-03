

document.addEventListener('DOMContentLoaded', function() {
    // Éléments du DOM
    const productCards = document.querySelectorAll('.product-card');
    const cartItems = document.getElementById('cart-items');
    const totalPrice = document.getElementById('total-price');
    const clearCartBtn = document.getElementById('clear-cart');
    const validateOrderBtn = document.getElementById('validate-order');
    const messageContainer = document.querySelector('.message-container');
    const messageText = document.getElementById('message-text');
    const modal = document.getElementById('confirmation-modal');
    const modalTotal = document.getElementById('modal-total');
    const modalCloseBtn = document.querySelector('.modal-close');

    // Initialiser le panier
    let cart = JSON.parse(localStorage.getItem('mielCart')) || [];

    // Sauvegarder le panier
    function saveCart() {
        localStorage.setItem('mielCart', JSON.stringify(cart));
        validateOrderBtn.disabled = cart.length === 0;
    }

    // Afficher un message
    function showMessage(text, isSuccess = true) {
        messageText.textContent = text;
        const messageElement = messageContainer.querySelector('.message');
        messageElement.className = `message ${isSuccess ? 'success' : 'error'}`;
        messageContainer.classList.add('message-visible');
        setTimeout(() => {
            messageContainer.classList.remove('message-visible');
        }, 3000);
    }

    // Mettre à jour l'affichage du panier
    function updateCartDisplay() {
        if (cart.length === 0) {
            cartItems.innerHTML = '<div class="empty-cart">Votre panier est vide</div>';
            totalPrice.textContent = '0.00 DH';
            validateOrderBtn.disabled = true;
            return;
        }

        let total = 0;
        cartItems.innerHTML = '';

        cart.forEach((item, index) => {
            const itemTotal = item.price * item.quantity;
            total += itemTotal;

            const cartItemHTML = `
                <div class="cart-item" data-id="${item.id}" data-index="${index}">
                    <div class="cart-item-info">
                        <div class="cart-item-details">
                            <h4>${item.name}</h4>
                            <p>${item.price.toFixed(2)} DH × ${item.quantity}</p>
                        </div>
                    </div>
                    <div class="cart-item-actions">
                        <div class="cart-quantity">
                            <button class="cart-quantity-btn cart-minus-btn" onclick="decreaseCartQuantity(${index})">-</button>
                            <span class="cart-quantity-display">${item.quantity}</span>
                            <button class="cart-quantity-btn cart-plus-btn" onclick="increaseCartQuantity(${index})">+</button>
                        </div>
                        <button class="remove-from-cart" onclick="removeCartItem(${index})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            `;

            cartItems.innerHTML += cartItemHTML;
        });

        totalPrice.textContent = `${total.toFixed(2)} DH`;
        validateOrderBtn.disabled = false;
    }

    // Ajouter au panier
    function addToCart(productCard) {
        const id = parseInt(productCard.dataset.id);
        const name = productCard.dataset.name;
        const price = parseFloat(productCard.dataset.price);
        const stock = parseInt(productCard.dataset.stock);
        const quantityDisplay = productCard.querySelector('.quantity-display');
        const quantity = parseInt(quantityDisplay.textContent);

        if (quantity === 0) {
            showMessage('Veuillez sélectionner une quantité', false);
            return;
        }

        const existingItemIndex = cart.findIndex(item => item.id === id);

        if (existingItemIndex !== -1) {
            const newQuantity = cart[existingItemIndex].quantity + quantity;
            if (newQuantity > stock) {
                showMessage(`Désolé, seulement ${stock} unités disponibles`, false);
                return;
            }
            cart[existingItemIndex].quantity = newQuantity;
        } else {
            if (quantity > stock) {
                showMessage(`Désolé, seulement ${stock} unités disponibles`, false);
                return;
            }
            cart.push({
                id: id,
                name: name,
                price: price,
                quantity: quantity
            });
        }

        quantityDisplay.textContent = '0';
        saveCart();
        updateCartDisplay();
        showMessage(`${name} ajouté au panier`);
    }

    // Fonction pour supprimer un article
    window.removeCartItem = function(index) {
        if (index >= 0 && index < cart.length) {
            const itemName = cart[index].name;
            cart.splice(index, 1);
            saveCart();
            updateCartDisplay();
            showMessage(`${itemName} retiré du panier`);
        }
    };

    // Fonction pour augmenter la quantité
    window.increaseCartQuantity = function(index) {
        if (index >= 0 && index < cart.length) {
            const item = cart[index];
            const productCard = document.querySelector(`.product-card[data-id="${item.id}"]`);
            const stock = parseInt(productCard.dataset.stock);
            
            if (item.quantity < stock) {
                item.quantity += 1;
                saveCart();
                updateCartDisplay();
                showMessage(`Quantité de ${item.name} augmentée`);
            } else {
                showMessage(`Désolé, seulement ${stock} unités disponibles`, false);
            }
        }
    };

    // Fonction pour diminuer la quantité
    window.decreaseCartQuantity = function(index) {
        if (index >= 0 && index < cart.length) {
            const item = cart[index];
            if (item.quantity > 1) {
                item.quantity -= 1;
                saveCart();
                updateCartDisplay();
                showMessage(`Quantité de ${item.name} diminuée`);
            } else {
                removeCartItem(index);
            }
        }
    };

    // Vider le panier
    function clearCart() {
        if (cart.length === 0) return;
        cart = [];
        saveCart();
        updateCartDisplay();
        showMessage('Panier vidé');
    }
    
    // Valider la commande
    function validateOrder() {
        if (cart.length === 0) return;
        
        let total = 0;
        cart.forEach(item => {
            total += item.price * item.quantity;
        });
        
        // Envoyer la commande au serveur
        const xhr = new XMLHttpRequest();
        xhr.open('POST', 'processCommande', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        const response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            modalTotal.textContent = total.toFixed(2);
                            modal.style.display = 'flex';
                            
                            cart = [];
                            saveCart();
                            updateCartDisplay();
                        } else {
                            showMessage('Erreur lors de la validation: ' + response.message, false);
                        }
                    } catch (e) {
                        showMessage('Erreur lors de la validation de la commande', false);
                    }
                } else {
                    showMessage('Erreur de communication avec le serveur', false);
                }
            }
        };
        
        const data = `cartItems=${encodeURIComponent(JSON.stringify(cart))}&totalAmount=${encodeURIComponent(total.toFixed(2))}`;
        xhr.send(data);
    }
    
    // Fermer la modal
    function closeModal() {
        modal.style.display = 'none';
    }

    // Initialiser les événements des produits
    productCards.forEach(card => {
        const plusBtn = card.querySelector('.plus-btn');
        const minusBtn = card.querySelector('.minus-btn');
        const quantityDisplay = card.querySelector('.quantity-display');
        const addToCartBtn = card.querySelector('.add-to-cart');

        plusBtn.addEventListener('click', function() {
            let quantity = parseInt(quantityDisplay.textContent);
            const stock = parseInt(card.dataset.stock);
            if (quantity < stock) {
                quantity++;
                quantityDisplay.textContent = quantity;
            } else {
                showMessage(`Désolé, seulement ${stock} unités disponibles`, false);
            }
        });

        minusBtn.addEventListener('click', function() {
            let quantity = parseInt(quantityDisplay.textContent);
            if (quantity > 0) {
                quantity--;
                quantityDisplay.textContent = quantity;
            }
        });

        addToCartBtn.addEventListener('click', function() {
            addToCart(card);
        });
    });

    // Autres événements
    clearCartBtn.addEventListener('click', clearCart);
    validateOrderBtn.addEventListener('click', validateOrder);
    modalCloseBtn.addEventListener('click', closeModal);
    
    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            closeModal();
        }
    });

    // Initialiser l'affichage du panier
    updateCartDisplay();
});