<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String travelDate = request.getParameter("travelDate");

    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = db.getConnection();
        String sql = "SELECT ts.TrainTid, ts.ScheduleTid, ts.Linename, ts.TotalFare, s1.Sid AS Origin, s1.Deptime AS StartTime, s2.Sid AS Destination, s2.Arrtime AS EndTime " +
                     "FROM TrainSchedule ts " +
                     "INNER JOIN Stops s1 ON ts.ScheduleTid = s1.ScheduleTid " +
                     "INNER JOIN Stops s2 ON ts.ScheduleTid = s2.ScheduleTid " +
                     "WHERE s1.Sid = ? AND s2.Sid = ? AND DATE(s1.Deptime) = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, origin);
        pstmt.setString(2, destination);
        pstmt.setString(3, travelDate);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            String TrainTid = rs.getString("TrainTid");
            String ScheduleTid = rs.getString("ScheduleTid");
            String Linename = rs.getString("Linename");
            int TotalFare = rs.getInt("TotalFare");
            String Origin = rs.getString("Origin");
            Timestamp StartTime = rs.getTimestamp("StartTime");
            String Destination = rs.getString("Destination");
            Timestamp EndTime = rs.getTimestamp("EndTime");
%>
        <div class="book" id="book<%=ScheduleTid%>" onclick="">
            <span class="book-title"><%=ScheduleTid%> <%=TrainTid%> <%=Linename%> <%=Origin%> <%=StartTime%> <%=Destination%> <%=EndTime%> Fare: <%=TotalFare%></span>
        </div>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>

