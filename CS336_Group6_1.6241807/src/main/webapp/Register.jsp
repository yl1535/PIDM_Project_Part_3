<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<%
    String userid = request.getParameter("Username");
    String mypwd  = request.getParameter("Password");
    String First  = request.getParameter("Firstname");
    String Last   = request.getParameter("Lastname");

    boolean registrationSuccess = false;
    boolean isDuplicate = false;

    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;
    ResultSet rs = null;

    try {
        con = db.getConnection();
        String findDuplicate = "SELECT Usr FROM Users WHERE Usr = ?";
        pstm = con.prepareStatement(findDuplicate);
        pstm.setString(1, userid);
        rs = pstm.executeQuery();
        
        if(rs == null || !rs.isBeforeFirst()){
            String inputRegister = "INSERT INTO Users (Firstname, Lastname, Usr, Pwd, UsrType) VALUES (?, ?, ?, ?, 'Passenger')";
            pstm = con.prepareStatement(inputRegister);
            pstm.setString(1, First);
            pstm.setString(2, Last);
            pstm.setString(3, userid);
            pstm.setString(4, mypwd);
            pstm.executeUpdate();
            registrationSuccess = true;
        } else {
            isDuplicate = true;
        }
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
<html>
	<head>
    	<meta charset="UTF-8">
    	<title>Registration Result</title>
    	<style>
        	.modal {
            	display: block;
            	position: fixed;
            	z-index: 1;
            	left: 0;
            	top: 0;
            	width: 100%;
            	height: 100%;
            	overflow: auto;
            	background-color: rgb(0,0,0);
            	background-color: rgba(0,0,0,0.4);
            	padding-top: 60px;
        	}
        	.modal-content {
            	background-color: #fefefe;
            	margin: 5% auto;
            	padding: 20px;
            	border: 1px solid #888;
            	width: 80%;
        	}
        	.close {
            	color: #aaa;
            	float: right;
            	font-size: 28px;
            	font-weight: bold;
        	}
        	.close:hover,
        	.close:focus {
            	color: black;
            	text-decoration: none;
            	cursor: pointer;
        	}
    	</style>
    	<script>
        	function closeModal() {
            	var modal = document.getElementById("resultModal");
            	modal.style.display = "none";
            	if (<%= registrationSuccess %>) {
                	window.location.href = "HelloWorld.jsp";
            	} else {
                	window.history.back();
            	}
        	}
    	</script>
	</head>
	<body>
		<div id="resultModal" class="modal">
    		<div class="modal-content">
        		<span class="close" onclick="closeModal()">&times;</span>
        		<p>
            		<%
                		if (registrationSuccess) {
                    		out.println("Registration successful! Redirecting to login page...");
                		} else if (isDuplicate) {
                    		out.println("Registration failed: Username already exists.");
                		} else {
                    		out.println("Registration failed: Please try again.");
                		}
            		%>
        		</p>
        		<button onclick="closeModal()">OK</button>
    		</div>
		</div>
	</body>
</html>