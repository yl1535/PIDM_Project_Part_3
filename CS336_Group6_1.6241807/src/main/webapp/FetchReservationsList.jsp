<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.LocalDateTime"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    String usr = (String) session.getAttribute("Username");

    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;
    ResultSet rs = null;

    try {
        con = db.getConnection();
        String ResRequest = "SELECT R.RN, R.ScheduleTid, S.Deptime " +
                            "FROM Reservations R " +
                            "JOIN Stops S ON R.TrainTid = S.TrainTid AND R.ScheduleTid = S.ScheduleTid " +
                            "WHERE R.Usr = ? AND S.Arrtime IS NULL";
        pstm = con.prepareStatement(ResRequest);
        pstm.setString(1, usr);
        rs = pstm.executeQuery();
        int ResId = 0;
        while (rs.next()) {
            int RN = rs.getInt("RN");
            Timestamp departureTime = rs.getTimestamp("Deptime");
            ResId++;
            boolean IfNotHistory = LocalDateTime.now().isBefore(departureTime.toLocalDateTime());
            String ResColor = (IfNotHistory) ? "lightgreen" : "lightyellow";
%>
        <div class="Res" id="Res<%=ResId%>" style="background-color: <%=ResColor%>;" onclick="fetchReservationDetails(<%=RN%>)">
            <span class="Res-title">Reservation No <%=RN%></span>
        </div>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
