<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Reservations</title>
</head>
<body>
    <h1>Reservations for Customer</h1>
    <%
        String username = request.getParameter("username");
        
        Connection conn = null;
        Statement stmt = null;
        try {
            ApplicationDB db = new ApplicationDB();
            conn = db.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM Reservations WHERE Usr='" + username + "'";
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                out.println("<p>Reservation Number: " + rs.getInt("RN") + " Date: " + rs.getDate("Date") + "</p>");
                // Add more fields as needed
            }
            rs.close();
            stmt.close();
            db.closeConnection(conn);
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</body>
</html>
