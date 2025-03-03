package com;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/supprimerProduit")
public class DeleteProductServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        // Get product ID
        int id = Integer.parseInt(request.getParameter("id"));
        
        try {
            // Delete from database
            ProductDAO productDAO = new ProductDAO();
            boolean success = productDAO.deleteProduct(id);
            
            if (success) {
                response.sendRedirect("admin.jsp?success=delete");
            } else {
                response.sendRedirect("admin.jsp?error=delete");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=delete");
        }
    }
}