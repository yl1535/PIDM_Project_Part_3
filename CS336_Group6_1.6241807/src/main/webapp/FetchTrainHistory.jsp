<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    String trainID = request.getParameter("trainID");

    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;
    ResultSet rs = null;

    try {
        con = db.getConnection();
        String historySQL = "SELECT * FROM TrainHistory WHERE TrainID = ?";
        pstm = con.prepareStatement(historySQL);
        pstm.setString(1, trainID);
        rs = pstm.executeQuery();

        StringBuilder historyContent = new StringBuilder();
        historyContent.append("<div style='text-align: center;'>");

        historyContent.append("<table style='width: 100%; text-align: center;'>");
        historyContent.append("<tr><th>Train ID</th><th>Event</th><th>Timestamp</th></tr>");

        while (rs.next()) {
            historyContent.append("<tr>")
                          .append("<td>").append(rs.getString("TrainID")).append("</td>")
                          .append("<td>").append(rs.getString("Event")).append("</td>")
                          .append("<td>").append(rs.getTimestamp("Timestamp")).append("</td>")
                          .append("</tr>");
        }

        historyContent.append("</table>");
        historyContent.append("</div>");

        out.print(historyContent.toString());
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
