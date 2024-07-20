<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	String qTitle = request.getParameter("qTitle");
	String question = request.getParameter("question");
	int qCode = Integer.parseInt(request.getParameter("qCode"));
	String usr = (String) session.getAttribute("Username");
%>
<div style="text-align: center;">
    <form class="modal-form" action="RecordQuestions.jsp" method="post">
        <h3>Title: <%= qTitle %></h3>
        <h3>Question: <%= question %></h3>
        <h3>Reply: </h3>
        <textarea id="newReply" name="reply" placeholder="Type your reply here..." required></textarea>
        <h3>Replier: <%= usr %></h3>
        <input type="hidden" name="qCode" value="<%= qCode %>">
        <button type="submit">Submit Your Answer</button>
    </form>
</div>

