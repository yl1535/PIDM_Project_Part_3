<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Technically This is a Title</title>
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
        	.boxtitle {
        		background-color: #cccccc;
        		text-align: center;
        	}
        	.button {
        		text-align: center;
        	}
    	</style>
	</head>
	
	<body>
		<div class="container">
			<div class="boxtitle">
				Project Test Login
			</div>
			<form method="post" action="check.jsp">                 
				<table>
					<tr>
						<td>Username:</td>
						<td><input type="text" name="Username"></td>
					</tr>
					<tr>
						<td>Password:</td>
						<td><input type="text" name="Password"></td>
					</tr>
				</table>
				<div class="button">
					<input type="submit" value="Login"/>
				</div>
			</form>
		</div>
	</body>
</html>