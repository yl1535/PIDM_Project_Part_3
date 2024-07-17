<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	String Usr = (String) session.getAttribute("Username");
    String QTitle = request.getParameter("qTitle");
    String Question = request.getParameter("question");

    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;
    ResultSet rs = null;

    try {
    	con = db.getConnection();
        String findQCodeSql = "SELECT QCode FROM QuestionBox";
        pstm = con.prepareStatement(findQCodeSql);
        rs = pstm.executeQuery();
        List<Integer> usedQCodes = new ArrayList<>();
        while (rs.next()) {
            usedQCodes.add(rs.getInt("QCode"));
        }
        int qCode = 0;
        while (usedQCodes.contains(qCode)) {
            qCode++;
        }
        String sql = "INSERT INTO QuestionBox (Usr, QTitle, Question, QCode, Reply, ReplyUsr) VALUES (?, ?, ?, ?, NULL, NULL)";
        pstm = con.prepareStatement(sql);
        pstm.setString(1, Usr);
        pstm.setString(2, QTitle);
        pstm.setString(3, Question);
        pstm.setInt(4, qCode);
        pstm.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstm != null) pstm.close();
            if (con != null) con.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }
%>