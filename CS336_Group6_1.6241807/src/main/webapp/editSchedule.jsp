<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Schedule</title>
</head>
<body>
    <h1>Edit Schedule</h1>
    <%
        String trainId = request.getParameter("trainId");
        String scheduleId = request.getParameter("scheduleId");
        String departureTime = request.getParameter("departureTime");
        String arrivalTime = request.getParameter("arrivalTime");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            ApplicationDB db = new ApplicationDB();
            conn = db.getConnection();
            String sql = "UPDATE Schedule SET Deptime=?, Arrtime=? WHERE TrainTid=? AND ScheduleTid=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, departureTime);
            pstmt.setString(2, arrivalTime);
            pstmt.setString(3, trainId);
            pstmt.setString(4, scheduleId);
            int rows = pstmt.executeUpdate();
            out.println("<p>Updated " + rows + " rows.</p>");
            pstmt.close();
            db.closeConnection(conn);
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</body>
</html>
