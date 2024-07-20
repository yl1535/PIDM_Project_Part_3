<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    String trainID = request.getParameter("trainID");
    String trainName = request.getParameter("trainName");

    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;

    try {
        con = db.getConnection();
        String insertSQL = "INSERT INTO Train (TrainID, TrainName) VALUES (?, ?)";
        pstm = con.prepareStatement(insertSQL);
        pstm.setString(1, trainID);
        pstm.setString(2, trainName);
        pstm.executeUpdate();

        response.getWriter().write("Train added successfully.");
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().write("Error adding train.");
    } finally {
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
