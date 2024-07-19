<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    int rn = Integer.parseInt(request.getParameter("rn"));
    String usr = (String) session.getAttribute("Username");

    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;

    try {
        con = db.getConnection();
        String cancelSQL = "DELETE FROM Reservations WHERE RN = ? AND Usr = ?";
        pstm = con.prepareStatement(cancelSQL);
        pstm.setInt(1, rn);
        pstm.setString(2, usr);
        pstm.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
