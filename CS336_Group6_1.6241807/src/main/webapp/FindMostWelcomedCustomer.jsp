<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.sql.*"%>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;
    ResultSet rs = null;
    try {
        con = db.getConnection();
        String sql = "SELECT r.Usr, COUNT(r.RN) AS TotalReservations, SUM(ts.TotalFare) AS TotalRevenue " +
                     "FROM Reservations r " +
                     "JOIN TrainSchedule ts ON r.TrainTid = ts.TrainTid AND r.ScheduleTid = ts.ScheduleTid " +
                     "GROUP BY r.Usr " +
                     "ORDER BY TotalRevenue DESC " +
                     "LIMIT 1";

        pstm = con.prepareStatement(sql);
        rs = pstm.executeQuery();

        if (rs.next()) {
            String mostWelcomedUser = rs.getString("Usr");
            int totalReservations = rs.getInt("TotalReservations");
            int totalRevenue = rs.getInt("TotalRevenue");

            out.println("<h2>Our Most Welcomed Customer is: " + mostWelcomedUser + "</h2>");
            out.println("<p>Making a total revenue of " + totalRevenue + " by taking " + totalReservations + " times of train!!!</p>");
        } else {
            out.println("<h2>No data found.</h2>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
