package com;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    
    // Get all products
    public List<Product> getAllProducts() throws SQLException, ClassNotFoundException {
        List<Product> products = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = util.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM produits";
            rs = stmt.executeQuery(sql);
            
            while(rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setNom(rs.getString("nom"));
                product.setDescription(rs.getString("description"));
                product.setPrix(rs.getDouble("prix"));
                product.setQuantite(rs.getInt("quantite"));
                product.setImage(rs.getString("image"));
                product.setPoids(rs.getString("poids"));
                
                products.add(product);
            }
        } finally {
            if(rs != null) rs.close();
            if(stmt != null) stmt.close();
            util.closeConnection(conn);
        }
        
        return products;
    }
    
    // Get product by ID
    public Product getProductById(int id) throws SQLException, ClassNotFoundException {
        Product product = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = util.getConnection();
            String sql = "SELECT * FROM produits WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                product = new Product();
                product.setId(rs.getInt("id"));
                product.setNom(rs.getString("nom"));
                product.setDescription(rs.getString("description"));
                product.setPrix(rs.getDouble("prix"));
                product.setQuantite(rs.getInt("quantite"));
                product.setImage(rs.getString("image"));
                product.setPoids(rs.getString("poids"));
            }
        } finally {
            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
            util.closeConnection(conn);
        }
        
        return product;
    }
    
    // Add a new product
    public boolean addProduct(Product product) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = util.getConnection();
            String sql = "INSERT INTO produits (nom, description, prix, quantite, image, poids) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, product.getNom());
            pstmt.setString(2, product.getDescription());
            pstmt.setDouble(3, product.getPrix());
            pstmt.setInt(4, product.getQuantite());
            pstmt.setString(5, product.getImage());
            pstmt.setString(6, product.getPoids());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if(pstmt != null) pstmt.close();
            util.closeConnection(conn);
        }
    }
    
    // Update an existing product
    public boolean updateProduct(Product product) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = util.getConnection();
            String sql = "UPDATE produits SET nom = ?, description = ?, prix = ?, quantite = ?, image = ?, poids = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, product.getNom());
            pstmt.setString(2, product.getDescription());
            pstmt.setDouble(3, product.getPrix());
            pstmt.setInt(4, product.getQuantite());
            pstmt.setString(5, product.getImage());
            pstmt.setString(6, product.getPoids());
            pstmt.setInt(7, product.getId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if(pstmt != null) pstmt.close();
            util.closeConnection(conn);
        }
    }
    
    // Delete a product
    public boolean deleteProduct(int id) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = util.getConnection();
            String sql = "DELETE FROM produits WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if(pstmt != null) pstmt.close();
            util.closeConnection(conn);
        }
    }
    
    // Search products by name
    public List<Product> searchProducts(String keyword) throws SQLException, ClassNotFoundException {
        List<Product> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = util.getConnection();
            String sql = "SELECT * FROM produits WHERE nom LIKE ? OR description LIKE ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setNom(rs.getString("nom"));
                product.setDescription(rs.getString("description"));
                product.setPrix(rs.getDouble("prix"));
                product.setQuantite(rs.getInt("quantite"));
                product.setImage(rs.getString("image"));
                product.setPoids(rs.getString("poids"));
                
                products.add(product);
            }
        } finally {
            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
            util.closeConnection(conn);
        }
        
        return products;
    }
}