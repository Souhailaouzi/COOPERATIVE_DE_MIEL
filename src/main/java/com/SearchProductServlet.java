package com;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.util.List;

@WebServlet("/rechercheProduit")
public class SearchProductServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        // Get search keyword
        String keyword = request.getParameter("recherche");
        
        try {
            // Search in database
            ProductDAO productDAO = new ProductDAO();
            List<Product> products = productDAO.searchProducts(keyword);
            
            // Store results in session for admin.jsp to display
            HttpSession session = request.getSession();
            session.setAttribute("searchResults", products);
            session.setAttribute("searchKeyword", keyword);
            
            response.sendRedirect("admin.jsp?search=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=search");
        }
    }
}