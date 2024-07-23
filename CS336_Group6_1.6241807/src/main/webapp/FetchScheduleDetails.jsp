<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    String scheduleTid = request.getParameter("scheduleTid");

    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;
    ResultSet rs = null;

    try {
        con = db.getConnection();

        String detailsSQL = "SELECT ts.ScheduleTid, ts.TrainTid, ts.Linename, ts.TotalFare, s.Sid, s.Arrtime, s.Deptime, st.Stationname " +
                            "FROM TrainSchedule ts " +
                            "INNER JOIN Stops s ON ts.ScheduleTid = s.ScheduleTid " +
                            "INNER JOIN Station st ON s.Sid = st.Sid " +
                            "WHERE ts.ScheduleTid = ? " +
                            "ORDER BY s.Arrtime";
        pstm = con.prepareStatement(detailsSQL);
        pstm.setString(1, scheduleTid);
        rs = pstm.executeQuery();

        StringBuilder modalContent = new StringBuilder();
        modalContent.append("<div style='text-align: center;'>");
        modalContent.append("<h3>").append(scheduleTid).append("</h3>");

        boolean first = true;
        int totalStops = 0;
        int totalFare = 0;
        String lineName = "";
        String trainTid = "";
        while (rs.next()) {
            if (first) {
                lineName = rs.getString("Linename");
                trainTid = rs.getString("TrainTid");
                totalFare = rs.getInt("TotalFare");
                modalContent.append("<p>Linename: ").append(lineName).append(" Train: ").append(trainTid).append("</p>");
                modalContent.append("<table style='width: 100%; text-align: center;'>");
                modalContent.append("<tr><th>Station</th><th>ArrTime</th><th>DepTime</th><th>Fare</th></tr>");
                first = false;
            }
            String stationName = rs.getString("Stationname");
            Timestamp arrTime = rs.getTimestamp("Arrtime");
            Timestamp depTime = rs.getTimestamp("Deptime");
            totalStops++;
            int fare = totalStops == 1 ? 0 : totalFare / (totalStops-1);
            modalContent.append("<tr>")
                .append("<td>").append(stationName).append("</td>")
                .append("<td>").append(arrTime == null ? "X" : arrTime).append("</td>")
                .append("<td>").append(depTime == null ? "X" : depTime).append("</td>")
                .append("<td>").append(fare).append("</td>")
                .append("</tr>");
        }
        session.setAttribute("trainTid",trainTid);
        session.setAttribute("scheduleTid",scheduleTid);
        modalContent.append("</table>");
        modalContent.append("<p>Do you want to make a reservation of this line?</p>");
        modalContent.append("<button onclick='openReservationModal()'>Yes</button>");
        modalContent.append("<button onclick='closeReservationModal()'>No</button>");
        modalContent.append("</div>");

        out.print(modalContent.toString());
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
