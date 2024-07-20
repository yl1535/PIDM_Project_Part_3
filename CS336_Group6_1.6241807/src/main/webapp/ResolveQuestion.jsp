<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    String questionID = request.getParameter("questionID");
    String replyContent = request.getParameter("replyContent");

    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;

    try {
        con = db.getConnection();
        String resolveSQL = "UPDATE Questions SET ReplyContent = ?, Resolved = 1 WHERE QuestionID = ?";
        pstm = con.prepareStatement(resolveSQL);
        pstm.setString(1, replyContent);
        pstm.setString(2, questionID);
        pstm.executeUpdate();

        response.getWriter().write("Question resolved successfully.");
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().write("Error resolving question.");
    } finally {
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
