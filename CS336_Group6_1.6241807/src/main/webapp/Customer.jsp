<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
	<head>
    	<title>Customer Page</title>
    	<style>
        	body, html {
            	margin: 0;
            	padding: 0;
            	height: 100%;
            	display: flex;
            	flex-direction: column;
        	}

        	.top-part {
            	flex: 1;
            	display: flex;
            	justify-content: center;
            	align-items: center;
        	}

        	.bottom-part {
            	flex: 4;
            	display: flex;
            	justify-content: space-around;
            	align-items: center;
        	}

        	.rectangle {
            	width: calc((100% / 3) - 20px);
            	height: 80%;
            	border: 2px solid black;
            	position: relative;
            	padding: 10px;
        	}

        	.title {
            	position: absolute;
            	top: 10px;
            	left: 10px;
        	}
    	</style>
	</head>
	<body>
    	<div class="top-part">
        	<%
        		String Username = (String) session.getAttribute("Username");
			
				out.print("<h1>");
				out.print("Welcome, " + Username);
				out.print("</h1>");
			%>
    	</div>
    	<div class="bottom-part">
        	<div class="rectangle">
            	<h2 class="title">Check And Book</h2>
        	</div>
        	<div class="rectangle">
            	<h2 class="title">History Reservation Check</h2>
        	</div>
        	<div class="rectangle">
            	<h2 class="title">Question Box</h2>
        	</div>
    	</div>
	</body>
</html>