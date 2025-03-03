package com; 

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class util {
    private static final String URL = "jdbc:mysql://localhost:3306/miel_website";
    private static final String USER = "souhail";
    private static final String PASSWORD = "123456";
    
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
    
    public static void closeConnection(Connection con) {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}