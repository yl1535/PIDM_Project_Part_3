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
        String criteria = request.getParameter("criteria");
        String search = request.getParameter("search");

        String sql = "SELECT r.RN, ts.Linename, st1.Stationname AS OriginStation, s1.Deptime AS OriginDepTime, " +
                     "st2.Stationname AS DestStation, s2.Arrtime AS DestArrTime, r.Usr " +
                     "FROM Reservations r " +
                     "JOIN TrainSchedule ts ON r.TrainTid = ts.TrainTid AND r.ScheduleTid = ts.ScheduleTid " +
                     "JOIN Stops s1 ON r.TrainTid = s1.TrainTid AND r.ScheduleTid = s1.ScheduleTid AND s1.Arrtime IS NULL " +
                     "JOIN Station st1 ON s1.Sid = st1.Sid " +
                     "JOIN Stops s2 ON r.TrainTid = s2.TrainTid AND r.ScheduleTid = s2.ScheduleTid AND s2.Deptime IS NULL " +
                     "JOIN Station st2 ON s2.Sid = st2.Sid " +
                     "WHERE " + criteria + " = ?";

        pstm = con.prepareStatement(sql);
        pstm.setString(1, search);
        rs = pstm.executeQuery();

        StringBuilder report = new StringBuilder();
        report.append("<h2>Reservation List</h2>");
        report.append("<table style='width:100%; text-align:center;'>");
        report.append("<tr><th>Reservation No</th><th>Line Name</th><th>Origin Station</th><th>Origin Departure Time</th><th>Destination Station</th><th>Destination Arrival Time</th><th>Customer Username</th></tr>");

        while (rs.next()) {
            int reservationNo = rs.getInt("RN");
            String lineName = rs.getString("Linename");
            String originStation = rs.getString("OriginStation");
            String originDepTime = rs.getString("OriginDepTime");
            String destStation = rs.getString("DestStation");
            String destArrTime = rs.getString("DestArrTime");
            String customerUsername = rs.getString("Usr");

            report.append("<tr><td>").append(reservationNo).append("</td><td>").append(lineName).append("</td><td>").append(originStation).append("</td><td>").append(originDepTime).append("</td><td>").append(destStation).append("</td><td>").append(destArrTime).append("</td><td>").append(customerUsername).append("</td></tr>");
        }

        report.append("</table>");

        out.println(report.toString());
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
