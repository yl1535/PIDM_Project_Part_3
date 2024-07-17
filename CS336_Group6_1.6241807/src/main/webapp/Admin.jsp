<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<style>
        	body, html {
            	height: 100%;
            	margin: 0;
            	display: flex;
            	justify-content: center;
            	align-items: center;
        	}
        	.container {
            	display: flex;
            	flex-direction: column;
            	justify-content: center;
            	height: 100%;
        	}
    	</style>
	</head>
	<body>
		<%
			String Username = (String) session.getAttribute("Username");
			
			out.print("<div>");
			out.print("Welcome, " + Username);
			out.print("</div>");
		%>
		<br>
		<div>
			<form action="HelloWorld.jsp">
				<div>
					<input type="submit" value="Logout"/>
				</div>
			</form>
		</div>
	</body>
</html>