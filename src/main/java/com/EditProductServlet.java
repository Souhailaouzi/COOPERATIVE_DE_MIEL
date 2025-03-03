package com;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import java.util.UUID;

@WebServlet("/modifierProduit")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class EditProductServlet extends HttpServlet {
    
    // For GET - display the edit form
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        try {
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(id);
            
            if (product != null) {
                request.setAttribute("product", product);
                RequestDispatcher dispatcher = request.getRequestDispatcher("edit-product.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect("admin.jsp?error=notfound");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=retrieve");
        }
    }
    
    // For POST - process the form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        int id = Integer.parseInt(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String description = request.getParameter("description");
        double prix = Double.parseDouble(request.getParameter("prix"));
        int quantite = Integer.parseInt(request.getParameter("quantite"));
        String poids = request.getParameter("poids");
        
        try {
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(id);
            
            if (product != null) {
                product.setNom(nom);
                product.setDescription(description);
                product.setPrix(prix);
                product.setQuantite(quantite);
                product.setPoids(poids);
                
                // Handle file upload if a new image is provided
                Part filePart = request.getPart("image");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = getSubmittedFileName(filePart);
                    String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                    
                    String uploadPath = request.getServletContext().getRealPath("") + File.separator + "img";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    
                    filePart.write(uploadPath + File.separator + uniqueFileName);
                    product.setImage(uniqueFileName);
                }
                
                boolean success = productDAO.updateProduct(product);
                
                if (success) {
                    response.sendRedirect("admin.jsp?success=update");
                } else {
                    response.sendRedirect("admin.jsp?error=update");
                }
            } else {
                response.sendRedirect("admin.jsp?error=notfound");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=update");
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