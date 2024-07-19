<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String travelDate = request.getParameter("travelDate");

    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;
    ResultSet rs = null;

    try {
        con = db.getConnection();

        // Clear previous search results
        String clearSQL = "DELETE FROM SearchResults";
        pstm = con.prepareStatement(clearSQL);
        pstm.executeUpdate();

        // Insert new search results
        String searchSQL = "INSERT INTO SearchResults (ScheduleTid, TrainTid, Linename, OSid, DSid, Otime, Dtime, Fare) " +
                           "SELECT ts.ScheduleTid, ts.TrainTid, ts.Linename, s1.Sid AS OSid, s2.Sid AS DSid, s1.Deptime AS Otime, s2.Arrtime AS Dtime, ts.TotalFare " +
                           "FROM TrainSchedule ts " +
                           "INNER JOIN Stops s1 ON ts.ScheduleTid = s1.ScheduleTid " +
                           "INNER JOIN Stops s2 ON ts.ScheduleTid = s2.ScheduleTid " +
                           "WHERE s1.Sid = ? AND s2.Sid = ? AND DATE(s1.Deptime) = ?";
        pstm = con.prepareStatement(searchSQL);
        pstm.setString(1, origin);
        pstm.setString(2, destination);
        pstm.setString(3, travelDate);
        pstm.executeUpdate();

        // Retrieve and display search results
        String displaySQL = "SELECT * FROM SearchResults";
        pstm = con.prepareStatement(displaySQL);
        rs = pstm.executeQuery();

        while (rs.next()) {
            String ScheduleTid = rs.getString("ScheduleTid");
            String TrainTid = rs.getString("TrainTid");
            String Linename = rs.getString("Linename");
            String OSid = rs.getString("OSid");
            Timestamp Otime = rs.getTimestamp("Otime");
            String DSid = rs.getString("DSid");
            Timestamp Dtime = rs.getTimestamp("Dtime");
            int Fare = rs.getInt("Fare");
%>
        <div class="book" id="book<%=ScheduleTid%>" onclick="fetchScheduleDetails('<%=ScheduleTid%>')">
            <span class="book-title"><%=ScheduleTid%> <%=TrainTid%> <%=Linename%> <%=OSid%> <%=Otime%> <%=DSid%> <%=Dtime%> Fare: <%=Fare%></span>
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
