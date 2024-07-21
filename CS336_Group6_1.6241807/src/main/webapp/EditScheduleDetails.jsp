<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    ResultSet rs = null;
    PreparedStatement pstm = null;
    PreparedStatement pstm2 = null;
    StringBuilder responseText = new StringBuilder();

    try {
        con = db.getConnection();
        String ScheduleTid = request.getParameter("ScheduleTid");

        String query = "SELECT TS.ScheduleTid, TS.Linename, TS.TrainTid, TS.TotalFare, S.Sid, S.Arrtime, S.Deptime " +
                       "FROM TrainSchedule TS " +
                       "LEFT JOIN Stops S ON TS.TrainTid = S.TrainTid AND TS.ScheduleTid = S.ScheduleTid " +
                       "WHERE TS.ScheduleTid = ?";
        pstm = con.prepareStatement(query);
        pstm.setString(1, ScheduleTid);
        rs = pstm.executeQuery();

        if (rs.next()) {
            String linename = rs.getString("Linename");
            String trainTid = rs.getString("TrainTid");
            int totalFare = rs.getInt("TotalFare");

            responseText.append("<div style='text-align:center;'>")
                        .append("<h2>Schedule Details</h2>")
                        .append("<p>ScheduleTid: ").append(ScheduleTid).append("</p>")
                        .append("<p>Linename: ").append(linename).append("</p>")
                        .append("<p>Train: ").append(trainTid).append("</p>")
                        .append("<p>TotalFare: ").append(totalFare).append("</p>");

            responseText.append("<table style='margin: auto;'><tr><th>Station</th><th>ArrTime</th><th>Deptime</th></tr>");
            do {
                String sid = rs.getString("Sid");
                Timestamp arrtime = rs.getTimestamp("Arrtime");
                Timestamp deptime = rs.getTimestamp("Deptime");
                responseText.append("<tr>")
                            .append("<td>").append(sid).append("</td>")
                            .append("<td>").append(arrtime).append("</td>")
                            .append("<td>").append(deptime).append("</td>")
                            .append("</tr>");
            } while (rs.next());
            responseText.append("</table>");

            responseText.append("<div style='display: flex; justify-content: space-around; margin-top: 20px;'>")
                        .append("<button onclick=\"openEditModal('Linename', '").append(ScheduleTid).append("')\">Edit Linename</button>")
                        .append("<button onclick=\"openEditModal('TrainTid', '").append(ScheduleTid).append("')\">Edit TrainTid</button>")
                        .append("<button onclick=\"openEditModal('TotalFare', '").append(ScheduleTid).append("')\">Edit TotalFare</button>")
                        .append("<button onclick=\"openEditModal('Stops', '").append(ScheduleTid).append("')\">Edit/Delete Stops</button>")
                        .append("</div></div>");
        }
        else{
        	responseText.append("<div> Target Schedule Not Found! </div>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }

    out.print(responseText.toString());
%>
