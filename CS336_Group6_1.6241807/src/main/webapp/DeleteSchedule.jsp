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
        String ScheduleTid = request.getParameter("ScheduleTid");

        String deleteReservations = "DELETE FROM Reservations WHERE ScheduleTid = ?";
        pstm = con.prepareStatement(deleteReservations);
        pstm.setString(1, ScheduleTid);
        pstm.executeUpdate();

        String deleteStops = "DELETE FROM Stops WHERE ScheduleTid = ?";
        pstm = con.prepareStatement(deleteStops);
        pstm.setString(1, ScheduleTid);
        pstm.executeUpdate();

        String deleteTrainSchedule = "DELETE FROM TrainSchedule WHERE ScheduleTid = ?";
        pstm = con.prepareStatement(deleteTrainSchedule);
        pstm.setString(1, ScheduleTid);
        pstm.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
