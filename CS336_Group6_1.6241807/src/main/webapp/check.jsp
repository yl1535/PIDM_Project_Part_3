<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Login Data Check Page</title>
		<script type="text/javascript">
        	function redirect(url) {
            	setTimeout(function() {
                	window.location.href = url;
            	}, 3000);
        	}
    	</script>
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
		
		ApplicationDB db = new ApplicationDB();
		Connection con = null;
		ResultSet rs = null;
		PreparedStatement pstm = null;
		String redirectURL = "";
		
		try{	
			con = db.getConnection();
	
			String userid = request.getParameter("Username");
			String mypwd  = request.getParameter("Password");
			boolean scs;

			String sql = "SELECT username FROM users WHERE username = ? AND pwd = ?";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, userid);
            pstm.setString(2, mypwd);
            rs = pstm.executeQuery();
		
			if(rs == null || !rs.isBeforeFirst()) {
				
				out.print("<h1>");
				out.print("Login Failed, can't find user " + userid + " or input password not correct");
				out.print("</h1>");
				
				scs = false;
				
			} else {
				
				out.print("<h1>");
				out.print("Login Success, welcome " + userid);
				out.print("</h1>");
				
				scs = true;
				
				session.setAttribute("Username", userid);
				
			}
			
			redirectURL = scs ? "success.jsp":"HelloWorld.jsp";
			
			out.print("<h1>");
			out.print(". Redirecting...");
			out.print("</h1>");
		
			con.close();
			
		} catch (Exception e){
			e.printStackTrace();
			out.print("<h1>");
			out.print("Experiencing Error: " + e);
			out.print(". Redirecting...");
			out.print("</h1>");
			redirectURL = "HelloWorld.jsp";
		} finally {
            try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
        }
		
		%>
		<script type="text/javascript">
        	redirect("<%= redirectURL %>");
    	</script>
	</body>
</html>