<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Representatives</title>
</head>
<body>
    <h1>Manage Customer Representatives</h1>
    <%
        String username = request.getParameter("username");
        String action = request.getParameter("action");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            ApplicationDB db = new ApplicationDB();
            conn = db.getConnection();
            if ("add".equalsIgnoreCase(action)) {
                String sql = "INSERT INTO Users (Firstname, Lastname, Usr, Pwd, UsrType) VALUES (?, ?, ?, ?, 'Representative')";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "Firstname");
                pstmt.setString(2, "Lastname");
                pstmt.setString(3, username);
                pstmt.setString(4, "password");
                pstmt.executeUpdate();
            } else if ("edit".equalsIgnoreCase(action)) {
                // Add edit logic
            } else if ("delete".equalsIgnoreCase(action)) {
                String sql = "DELETE FROM Users WHERE Usr=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.executeUpdate();
            }
            pstmt.close();
            db.closeConnection(conn);
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</body>
</html>
