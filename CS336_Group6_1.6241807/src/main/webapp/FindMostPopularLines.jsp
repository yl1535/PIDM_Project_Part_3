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
        int year = Integer.parseInt(request.getParameter("year"));
        int month = Integer.parseInt(request.getParameter("month"));

        String sql = "SELECT ts.Linename, COUNT(r.RN) AS ReservationCount " +
                     "FROM Reservations r " +
                     "JOIN TrainSchedule ts ON r.TrainTid = ts.TrainTid AND r.ScheduleTid = ts.ScheduleTid " +
                     "JOIN Stops s ON r.TrainTid = s.TrainTid AND r.ScheduleTid = s.ScheduleTid " +
                     "WHERE MONTH(s.Deptime) = ? AND YEAR(s.Deptime) = ? " +
                     "GROUP BY ts.Linename " +
                     "ORDER BY ReservationCount DESC " +
                     "LIMIT 5";

        pstm = con.prepareStatement(sql);
        pstm.setInt(1, month);
        pstm.setInt(2, year);
        rs = pstm.executeQuery();

        StringBuilder report = new StringBuilder();
        report.append("<h2>The Five Most Popular Transit Lines in the given month are:</h2>");
        report.append("<ol>");

        while (rs.next()) {
            String lineName = rs.getString("Linename");
            int reservationCount = rs.getInt("ReservationCount");

            report.append("<li>").append(lineName).append(" - Having ").append(reservationCount).append(" times of reservations !!!</li>");
        }

        report.append("</ol>");

        out.println(report.toString());
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
