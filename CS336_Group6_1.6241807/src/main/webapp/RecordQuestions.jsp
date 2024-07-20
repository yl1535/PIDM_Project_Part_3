<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	int qCode = Integer.parseInt(request.getParameter("qCode"));
	String Replyusr = (String) session.getAttribute("Username");
	String reply = request.getParameter("reply");

	ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;

    try {
    	con = db.getConnection();
    	String FulfillQuery = "UPDATE QuestionBox SET Reply = ?, ReplyUsr = ? WHERE QCode = ?";
    	pstm = con.prepareStatement(FulfillQuery);
    	pstm.setString(1, reply);
    	pstm.setString(2, Replyusr);
    	pstm.setInt(3, qCode);
    	pstm.executeUpdate();
    	
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
    
    // Redirect to the main page or display success message
    response.sendRedirect("Customer_Representative.jsp");
%>
