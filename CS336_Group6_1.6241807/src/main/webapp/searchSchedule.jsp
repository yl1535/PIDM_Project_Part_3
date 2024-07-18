<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Schedule</title>
</head>
<body>
    <h1>Search Results</h1>
    <%
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String date = request.getParameter("date");
        
        Connection conn = null;
        Statement stmt = null;
        try {
            ApplicationDB db = new ApplicationDB();
            conn = db.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM Schedule WHERE Origin='" + origin + "' AND Destination='" + destination + "' AND Date='" + date + "'";
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                out.println("<p>Train: " + rs.getString("TrainTid") + " Schedule: " + rs.getString("ScheduleTid") + " Line: " + rs.getString("Linename") + "</p>");
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
