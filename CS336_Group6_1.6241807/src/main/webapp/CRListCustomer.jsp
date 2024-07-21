<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.LocalDate"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    ResultSet rs = null;
    PreparedStatement pstm = null;
    StringBuilder responseText = new StringBuilder();

    try {
        con = db.getConnection();
        String CRLCLine = request.getParameter("CRLCLine");
        LocalDate CRLCTime = LocalDate.parse(request.getParameter("CRLCTime"));

        String query = "SELECT R.Usr, TS.Linename, TS.ScheduleTid " +
                       "FROM Reservations R " +
                       "JOIN TrainSchedule TS ON R.TrainTid = TS.TrainTid AND R.ScheduleTid = TS.ScheduleTid " +
                       "JOIN Stops S ON TS.TrainTid = S.TrainTid AND TS.ScheduleTid = S.ScheduleTid " +
                       "WHERE TS.Linename = ? AND DATE(S.Deptime) = ?";
        pstm = con.prepareStatement(query);
        pstm.setString(1, CRLCLine);
        pstm.setDate(2, java.sql.Date.valueOf(CRLCTime));
        rs = pstm.executeQuery();
        
        while (rs.next()) {
            String usr = rs.getString("Usr");
            String linename = rs.getString("Linename");
            String scheduleTid = rs.getString("ScheduleTid");
            responseText.append(usr).append(" ").append(linename).append(" ").append(scheduleTid).append("<br>");
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

