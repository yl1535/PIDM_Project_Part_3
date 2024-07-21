<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;
    PreparedStatement pstm2 = null;

    try {
        con = db.getConnection();
        con.setAutoCommit(false);

        String type = request.getParameter("type");
        String value = request.getParameter("value");
        String ScheduleTid = request.getParameter("ScheduleTid");

        if (type.equals("TrainTid")) {
            String checkTrain = "SELECT COUNT(*) FROM Train WHERE TrainTid = ?";
            pstm = con.prepareStatement(checkTrain);
            pstm.setString(1, value);
            ResultSet rs = pstm.executeQuery();
            if (rs.next() && rs.getInt(1) == 0) {
                out.print("<p>TrainTid does not exist. Update cancelled.</p>");
                con.rollback();
                return;
            }
            String updateTrainSchedule = "UPDATE TrainSchedule SET TrainTid = ? WHERE ScheduleTid = ?";
            pstm = con.prepareStatement(updateTrainSchedule);
            pstm.setString(1, value);
            pstm.setString(2, ScheduleTid);
            pstm.executeUpdate();
        } else {
            String updateQuery = "UPDATE TrainSchedule SET " + type + " = ? WHERE ScheduleTid = ?";
            pstm = con.prepareStatement(updateQuery);
            pstm.setString(1, value);
            pstm.setString(2, ScheduleTid);
            pstm.executeUpdate();
        }

        con.commit();
        
        String query = "SELECT TS.ScheduleTid, TS.Linename, TS.TrainTid, TS.TotalFare, S.Sid, S.Arrtime, S.Deptime " +
                       "FROM TrainSchedule TS " +
                       "LEFT JOIN Stops S ON TS.TrainTid = S.TrainTid AND TS.ScheduleTid = S.ScheduleTid " +
                       "WHERE TS.ScheduleTid = ?";
        pstm = con.prepareStatement(query);
        pstm.setString(1, ScheduleTid);
        ResultSet rs = pstm.executeQuery();

        if (rs.next()) {
            String linename = rs.getString("Linename");
            String trainTid = rs.getString("TrainTid");
            int totalFare = rs.getInt("TotalFare");

            out.print("<div style='text-align:center;'>");
            out.print("<h2>Schedule Details</h2>");
            out.print("<p>ScheduleTid: " + ScheduleTid + "</p>");
            out.print("<p>Linename: " + linename + "</p>");
            out.print("<p>Train: " + trainTid + "</p>");
            out.print("<p>TotalFare: " + totalFare + "</p>");

            out.print("<table style='margin: auto;'><tr><th>Station</th><th>ArrTime</th><th>Deptime</th></tr>");
            do {
                String sid = rs.getString("Sid");
                Timestamp arrtime = rs.getTimestamp("Arrtime");
                Timestamp deptime = rs.getTimestamp("Deptime");
                out.print("<tr>");
                out.print("<td>" + sid + "</td>");
                out.print("<td>" + arrtime + "</td>");
                out.print("<td>" + deptime + "</td>");
                out.print("</tr>");
            } while (rs.next());
            out.print("</table>");
            out.print("<div style='display: flex; justify-content: space-around; margin-top: 20px;'>");
            out.print("<button onclick=\"openEditModal('Linename', '" + ScheduleTid + "')\">Edit Linename</button>");
            out.print("<button onclick=\"openEditModal('TrainTid', '" + ScheduleTid + "')\">Edit TrainTid</button>");
            out.print("<button onclick=\"openEditModal('TotalFare', '" + ScheduleTid + "')\">Edit TotalFare</button>");
            out.print("<button onclick=\"openEditModal('Stops', '" + ScheduleTid + "')\">Edit/Delete Stops</button>");
            out.print("</div></div>");
        }
    } catch (Exception e) {
        if (con != null) {
            try {
                con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        e.printStackTrace();
    } finally {
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstm2 != null) pstm2.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
