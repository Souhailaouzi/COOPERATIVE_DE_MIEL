package com;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import java.util.UUID;

@WebServlet("/ajouterProduit")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class AddProductServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        // Get form data
        String nom = request.getParameter("nom");
        String description = request.getParameter("description");
        double prix = Double.parseDouble(request.getParameter("prix"));
        int quantite = Integer.parseInt(request.getParameter("quantite"));
        String poids = request.getParameter("poids");
        
        // Handle file upload
        Part filePart = request.getPart("image");
        String fileName = getSubmittedFileName(filePart);
        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
        
        // Save the file to the server
        String uploadPath = request.getServletContext().getRealPath("") + File.separator + "img";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        
        filePart.write(uploadPath + File.separator + uniqueFileName);
        
        // Create Product object
        Product product = new Product();
        product.setNom(nom);
        product.setDescription(description);
        product.setPrix(prix);
        product.setQuantite(quantite);
        product.setImage(uniqueFileName);
        product.setPoids(poids);
        
        try {
            // Save to database
            ProductDAO productDAO = new ProductDAO();
            boolean success = productDAO.addProduct(product);
            
            if (success) {
                response.sendRedirect("admin.jsp?success=add");
            } else {
                response.sendRedirect("admin.jsp?error=add");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=add");
        }
    }
    
    // Helper method to get file name from Part
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}