<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;

    try {
        con = db.getConnection();
        String stopSid = request.getParameter("stopSid");
        String stopArrtime = request.getParameter("stopArrtime");
        String stopDeptime = request.getParameter("stopDeptime");
        String stopOperation = request.getParameter("stopOperation");
        String ScheduleTid = request.getParameter("ScheduleTid");

        if (stopOperation.equals("Add")) {
            String checkStation = "SELECT COUNT(*) FROM Station WHERE Sid = ?";
            pstm = con.prepareStatement(checkStation);
            pstm.setString(1, stopSid);
            ResultSet rs = pstm.executeQuery();
            if (rs.next() && rs.getInt(1) == 0) {
                out.print("<p>Station ID does not exist. Operation cancelled.</p>");
                return;
            }
            String checkExistingStop = "SELECT COUNT(*) FROM Stops WHERE ScheduleTid = ? AND Sid = ?";
            pstm = con.prepareStatement(checkExistingStop);
            pstm.setString(1, ScheduleTid);
            pstm.setString(2, stopSid);
            rs = pstm.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                out.print("<p>Stop already exists in the schedule. Operation cancelled.</p>");
                return;
            }
			String addStop = "";
            if(stopArrtime.equals("")){
            	 addStop = "INSERT INTO Stops (TrainTid, ScheduleTid, Sid, Deptime) VALUES ((SELECT TrainTid FROM TrainSchedule WHERE ScheduleTid = ?), ?, ?, ?)";
            	 pstm = con.prepareStatement(addStop);
            	 pstm.setString(4, stopDeptime);
            }
            else if(stopDeptime.equals("")){
            	 addStop = "INSERT INTO Stops (TrainTid, ScheduleTid, Sid, Arrtime) VALUES ((SELECT TrainTid FROM TrainSchedule WHERE ScheduleTid = ?), ?, ?, ?)";
            	 pstm = con.prepareStatement(addStop);
            	 pstm.setString(4, stopArrtime);
            }
            else{
            	 addStop = "INSERT INTO Stops (TrainTid, ScheduleTid, Sid, Arrtime, Deptime) VALUES ((SELECT TrainTid FROM TrainSchedule WHERE ScheduleTid = ?), ?, ?, ?, ?)";
            	 pstm = con.prepareStatement(addStop);
            	 pstm.setString(4, stopArrtime);
            	 pstm.setString(5, stopDeptime);
            }
            pstm.setString(1, ScheduleTid);
            pstm.setString(2, ScheduleTid);
            pstm.setString(3, stopSid);
            pstm.executeUpdate();
        } else if (stopOperation.equals("Edit")) {
        	String checkExistingStop = "SELECT COUNT(*) FROM Stops WHERE ScheduleTid = ? AND Sid = ?";
            pstm = con.prepareStatement(checkExistingStop);
            pstm.setString(1, ScheduleTid);
            pstm.setString(2, stopSid);
            ResultSet rs = pstm.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
        		String editStop = "UPDATE Stops SET Arrtime = CASE WHEN ? = '' THEN NULL ELSE ? END, Deptime = CASE WHEN ? = '' THEN NULL ELSE ? END WHERE ScheduleTid = ? AND Sid = ?";
        		pstm = con.prepareStatement(editStop);
        		pstm.setString(1, stopArrtime);
        		pstm.setString(2, stopArrtime);
        		pstm.setString(3, stopDeptime);
        		pstm.setString(4, stopDeptime);
        		pstm.setString(5, ScheduleTid);
        		pstm.setString(6, stopSid);
        		pstm.executeUpdate();
        	}
        	else{
        		out.print("<p>Target stop does not exist in the schedule. Operation cancelled.</p>");
                return;
        	}
        } else if (stopOperation.equals("Delete")) {
        	String checkExistingStop = "SELECT COUNT(*) FROM Stops WHERE ScheduleTid = ? AND Sid = ?";
            pstm = con.prepareStatement(checkExistingStop);
            pstm.setString(1, ScheduleTid);
            pstm.setString(2, stopSid);
            ResultSet rs = pstm.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
            	String deleteStop = "DELETE FROM Stops WHERE ScheduleTid = ? AND Sid = ?";
                pstm = con.prepareStatement(deleteStop);
                pstm.setString(1, ScheduleTid);
                pstm.setString(2, stopSid);
                pstm.executeUpdate();
            }
            else{
            	out.print("<p>Target stop does not exist in the schedule. Operation cancelled.</p>");
                return;
            }
        }

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
        e.printStackTrace();
    } finally {
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
