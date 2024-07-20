<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    String questionID = request.getParameter("questionID");

    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;
    ResultSet rs = null;

    try {
        con = db.getConnection();
        String questionDetailsSQL = "SELECT q.QuestionID, q.QuestionContent, q.CreatedAt, a.AnswerContent, a.AnsweredAt " +
                                    "FROM Questions q LEFT JOIN Answers a ON q.QuestionID = a.QuestionID " +
                                    "WHERE q.QuestionID = ?";
        pstm = con.prepareStatement(questionDetailsSQL);
        pstm.setString(1, questionID);
        rs = pstm.executeQuery();

        StringBuilder modalContent = new StringBuilder();
        modalContent.append("<div style='text-align: center;'>");
        modalContent.append("<h3>Question Details</h3>");

        if (rs.next()) {
            String questionContent = rs.getString("QuestionContent");
            Timestamp createdAt = rs.getTimestamp("CreatedAt");
            String answerContent = rs.getString("AnswerContent");
            Timestamp answeredAt = rs.getTimestamp("AnsweredAt");

            modalContent.append("<p><strong>Question:</strong> ").append(questionContent).append("</p>");
            modalContent.append("<p><strong>Created At:</strong> ").append(createdAt == null ? "N/A" : createdAt).append("</p>");
            if (answerContent != null) {
                modalContent.append("<p><strong>Answer:</strong> ").append(answerContent).append("</p>");
                modalContent.append("<p><strong>Answered At:</strong> ").append(answeredAt).append("</p>");
            } else {
                modalContent.append("<p><strong>Answer:</strong> Not yet answered</p>");
            }
        } else {
            modalContent.append("<p>Question not found.</p>");
        }

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
