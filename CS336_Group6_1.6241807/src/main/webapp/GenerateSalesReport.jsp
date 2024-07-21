<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.sql.*,java.time.LocalDateTime"%>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;
    ResultSet rs = null;
    try {
        con = db.getConnection();
        int year = Integer.parseInt(request.getParameter("year"));
        int month = Integer.parseInt(request.getParameter("month"));

        String sql = "SELECT ts.Linename, " +
                     "SUM(CASE WHEN r.RN IS NOT NULL THEN 1 ELSE 0 END) AS TotalPeople, " +
                     "SUM(CASE WHEN r.RN IS NOT NULL THEN ts.TotalFare ELSE 0 END) AS TotalFare " +
                     "FROM TrainSchedule ts " +
                     "LEFT JOIN Reservations r ON ts.TrainTid = r.TrainTid AND ts.ScheduleTid = r.ScheduleTid " +
                     "LEFT JOIN Stops s ON ts.TrainTid = s.TrainTid AND ts.ScheduleTid = s.ScheduleTid " +
                     "WHERE MONTH(s.Deptime) = ? AND YEAR(s.Deptime) = ? " +
                     "GROUP BY ts.Linename";

        pstm = con.prepareStatement(sql);
        pstm.setInt(1, month);
        pstm.setInt(2, year);
        rs = pstm.executeQuery();

        StringBuilder report = new StringBuilder();
        report.append("<h2>Sales Report</h2>");
        report.append("<table style='width:100%; text-align:center;'>");
        report.append("<tr><th>Line Name</th><th>Total People</th><th>Total Fare Earned</th></tr>");

        int totalPeople = 0;
        int totalFare = 0;

        while (rs.next()) {
            String lineName = rs.getString("Linename");
            int people = rs.getInt("TotalPeople");
            int fare = rs.getInt("TotalFare");

            totalPeople += people;
            totalFare += fare;

            report.append("<tr><td>").append(lineName).append("</td><td>").append(people).append("</td><td>").append(fare).append("</td></tr>");
        }

        report.append("<tr><td>Total</td><td>").append(totalPeople).append("</td><td>").append(totalFare).append("</td></tr>");
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
