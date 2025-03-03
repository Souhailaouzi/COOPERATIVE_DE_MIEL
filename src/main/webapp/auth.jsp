<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.util" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Authentification Miel</title>
    <link rel="stylesheet" href="auth.css">
    <script>
        function toggleForm() {
            let formContainer = document.querySelector(".forms-container");
            formContainer.classList.toggle("active");
        }

        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const errorParam = urlParams.get('error');
            const successParam = urlParams.get('success');
            
            if (errorParam === 'login') {
                document.querySelector(".forms-container").classList.remove("active");
            } else if (errorParam === 'signup') {
                document.querySelector(".forms-container").classList.add("active");
            }
            
            if (successParam === 'registered') {
                document.querySelector(".forms-container").classList.remove("active");
            }
        }
    </script>
    <style>
        .message {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            text-align: center;
        }
        .error {
            background-color: #ffcccc;
            color: #cc0000;
            border: 1px solid #cc0000;
        }
        .success {
            background-color: #ccffcc;
            color: #006600;
            border: 1px solid #006600;
        }
    </style>
</head>
<body>
<%
    String errorMessage = null;
    String successMessage = null;
    
    if (request.getMethod().equals("POST")) {
        if (request.getParameter("formType") != null && request.getParameter("formType").equals("login")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = util.getConnection();
                String sql = "SELECT * FROM utilisateur WHERE nom = ? AND password = ? AND role = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                pstmt.setString(3, role);
                
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    session.setAttribute("username", username);
                    session.setAttribute("role", role);
                    
                    if ("admin".equals(role)) {
                        response.sendRedirect("admin.jsp");
                        return;
                    } else {
                        response.sendRedirect("processCommande");
                        return;
                    }
                } else {
                    errorMessage = "Nom d'utilisateur ou mot de passe incorrect";
                    request.setAttribute("errorMessage", errorMessage);
                }
            } 
            
            
            catch (Exception e) {
                errorMessage = "Erreur de connexion à la base de données: " + e.getMessage();
                request.setAttribute("errorMessage", errorMessage);
                e.printStackTrace();
            } 
            finally {
                try { if (rs != null) rs.close(); } catch (Exception e) { }
                try { if (pstmt != null) pstmt.close(); } catch (Exception e) { }
                util.closeConnection(conn);
            }
        }
        else if (request.getParameter("formType") != null && request.getParameter("formType").equals("signup")) {
            String email = request.getParameter("email");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = util.getConnection();
                String checkSql = "SELECT * FROM utilisateur WHERE nom = ? OR email = ?";
                pstmt = conn.prepareStatement(checkSql);
                pstmt.setString(1, username);
                pstmt.setString(2, email);
                
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    if (rs.getString("email").equals(email)) {
                        errorMessage = "Cet email est déjà utilisé.";
                    } else if (rs.getString("nom").equals(username)) {
                        errorMessage = "Ce nom d'utilisateur est déjà utilisé.";
                    }
                    request.setAttribute("errorMessage", errorMessage);
                    request.setAttribute("form", "signup");
                } 
                else {
                    String insertSql = "INSERT INTO utilisateur (nom, password, email, role) VALUES (?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(insertSql);
                    pstmt.setString(1, username);
                    pstmt.setString(2, password);
                    pstmt.setString(3, email);
                    pstmt.setString(4, role);
                    
                    int rowsAffected = pstmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        successMessage = "Inscription réussie ! Vous pouvez maintenant vous connecter.";
                        session.setAttribute("successMessage", successMessage);
                        response.sendRedirect("auth.jsp?success=registered");
                        return;
                    }
                    else {
                        errorMessage = "Échec de l'inscription. Veuillez réessayer.";
                        request.setAttribute("errorMessage", errorMessage);
                        request.setAttribute("form", "signup");
                    }
                }
            } 
            catch (Exception e) {
                errorMessage = "Erreur lors de l'inscription: " + e.getMessage();
                request.setAttribute("errorMessage", errorMessage);
                request.setAttribute("form", "signup");
                e.printStackTrace();
            } 
            finally {
                try { if (rs != null) rs.close(); } catch (Exception e) { }
                try { if (pstmt != null) pstmt.close(); } catch (Exception e) { }
                util.closeConnection(conn);
            }
        }
    }
%>

    <div class="container">
        <div class="forms-container">
            <div class="form sign-up-form">
                <h2>Inscription 🐝</h2>
                <h3>Salut, entre tes informations pour créer un compte !</h3>
                
                <% if (request.getAttribute("errorMessage") != null && request.getAttribute("form") != null && request.getAttribute("form").equals("signup")) { %>
                    <div class="message error"><%= request.getAttribute("errorMessage") %></div>
                <% } %>
                
                <form action="auth.jsp" method="POST">
                    <input type="hidden" name="formType" value="signup">
                    <input type="email" name="email" placeholder="Email" required>
                    <input type="text" name="username" placeholder="Nom d'utilisateur" required>
                    <input type="password" name="password" placeholder="Mot de passe" required>
                    <input type="hidden" name="role" value="client">
                    <p class="signup-phrase">Tu as déjà un compte ? <a href="#" onclick="toggleForm()">Se connecter</a></p>
                    <button type="submit">S'inscrire</button>
                </form>
            </div>

            <div class="form log-in-form">
                <h2>Se connecter 🍯</h2>
                <h3>Content de te revoir ! Entre tes informations pour te connecter.</h3>
                
                <% if (request.getAttribute("errorMessage") != null && (request.getAttribute("form") == null || !request.getAttribute("form").equals("signup"))) { %>
                    <div class="message error"><%= request.getAttribute("errorMessage") %></div>
                <% } %>
                
                <% if (session.getAttribute("successMessage") != null) { %>
                    <div class="message success"><%= session.getAttribute("successMessage") %></div>
                    <% session.removeAttribute("successMessage"); %>
                <% } %>
                
                <form action="auth.jsp" method="POST">
                    <input type="hidden" name="formType" value="login">
                    <input type="text" name="username" placeholder="Nom d'utilisateur" required>
                    <input type="password" name="password" placeholder="Mot de passe" required>
                    <select id="role" name="role" required>
                        <option value="client">Client</option>
                        <option value="admin">Administrateur</option>
                    </select>
                    <button type="submit">Se connecter</button>
                    <p class="login-phrase">Tu n'as pas de compte ? <a href="#" onclick="toggleForm()">S'inscrire</a></p>
                    
                    
                </form>
            </div>
        </div>
    </div>
</body>
</html>