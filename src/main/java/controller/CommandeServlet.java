package controller;

import com.util;
import model.Produit;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/processCommande")
public class CommandeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Produit> produits = new ArrayList<>();
        Connection conn = null;

        try {
            conn = util.getConnection();
            String sql = "SELECT * FROM produits";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    Produit produit = new Produit(
                        rs.getInt("id"),
                        rs.getString("nom"),
                        rs.getString("description"),
                        rs.getDouble("prix"),
                        rs.getString("poids"),
                        rs.getInt("quantite"),
                        rs.getString("image")
                    );
                    produits.add(produit);
                }
                rs.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        } finally {
            util.closeConnection(conn);
        }

        request.setAttribute("produits", produits);
        request.getRequestDispatcher("/Commande.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        // Récupérer les données du panier en JSON
        String cartItems = request.getParameter("cartItems");
        String totalAmount = request.getParameter("totalAmount");
        
        if (cartItems == null || cartItems.isEmpty() || totalAmount == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Données de panier invalides\"}");
            return;
        }
        
        Connection conn = null;
        
        try {
            conn = util.getConnection();
            conn.setAutoCommit(false);
            
            // Récupérer l'ID de l'utilisateur
            int userId = getUserId(conn, username);
            if (userId == -1) {
                throw new SQLException("Utilisateur non trouvé");
            }
            
            // Insérer dans la table Commande
            String insertCommandeSql = "INSERT INTO commande (id_user, prix_totale, Qte_prod, date_cmd) VALUES (?, ?, ?, CURDATE())";
            PreparedStatement pstmt = conn.prepareStatement(insertCommandeSql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, userId);
            pstmt.setDouble(2, Double.parseDouble(totalAmount));
            
            // Calculer le nombre total d'articles
            int totalItems = countTotalItems(cartItems);
            pstmt.setInt(3, totalItems);
            
            pstmt.executeUpdate();
            
            // Récupérer l'ID de la commande
            ResultSet rs = pstmt.getGeneratedKeys();
            int commandeId = 0;
            if (rs.next()) {
                commandeId = rs.getInt(1);
            }
            
            // Ici, on pourrait insérer les détails des produits dans une table commande_produits
            // si vous souhaitez conserver ces informations
            
            conn.commit();
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"commandeId\": " + commandeId + "}");
            
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        } finally {
            util.closeConnection(conn);
        }
    }
    
    private int getUserId(Connection conn, String username) throws SQLException {
        String sql = "SELECT id FROM utilisateur WHERE nom = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
        }
        return -1;
    }
    
    private int countTotalItems(String cartItems) {
        // Cette méthode devrait analyser le JSON et calculer le nombre total d'articles
        // Pour simplifier, nous retournons une valeur arbitraire
        return 1;
    }
}