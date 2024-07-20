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
        String detailsSQL = "SELECT * FROM Train WHERE TrainID = ?";
        pstm = con.prepareStatement(detailsSQL);
        pstm.setString(1, trainID);
        rs = pstm.executeQuery();

        StringBuilder modalContent = new StringBuilder();
        modalContent.append("<div style='text-align: center;'>");

        if (rs.next()) {
            modalContent.append("<h3>Train ID: ").append(rs.getString("TrainID")).append("</h3>");
            modalContent.append("<p>Train Name: ").append(rs.getString("TrainName")).append("</p>");
        } else {
            modalContent.append("<p>No details found for train ID: ").append(trainID).append("</p>");
        }
        modalContent.append("<button onclick='closeTrainModal()'>Close</button>");
        modalContent.append("</div>");

        out.print(modalContent.toString());
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
