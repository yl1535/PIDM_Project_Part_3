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
        	.hidden {
        		display: none;
        	}
        	table {
        		margin: auto;
        	}
        	td {
        		text-align: right;
        		padding: 5px;
        	}
        	input[type="text"] {
        		width: 100%;
        	}
    	</style>
		<script>
			function toggleRegisterMode() {
				var boxtitle = document.getElementById('boxtitle');
				var loginButton = document.getElementById('loginButton');
				var registerButton = document.getElementById('registerButton');
				var firstnameRow = document.getElementById('firstnameRow');
				var lastnameRow = document.getElementById('lastnameRow');
				var form = document.querySelector('form');
				
				if (registerButton.value === "Register") {
					boxtitle.style.backgroundColor = '#ffcccc';
					boxtitle.innerText = 'Type in the registered Username and Password';
					loginButton.value = 'Register';
					registerButton.value = 'Cancel';
					form.action = 'Register.jsp';
					firstnameRow.classList.remove('hidden');
					lastnameRow.classList.remove('hidden');
				} else {
					boxtitle.style.backgroundColor = '#cccccc';
					boxtitle.innerText = 'ORBS Code:6 Login';
					loginButton.value = 'Login';
					registerButton.value = 'Register';
					form.action = 'check.jsp';
					firstnameRow.classList.add('hidden');
					lastnameRow.classList.add('hidden');
				}
			}

			function validateForm() {
				var username = document.forms["loginForm"]["Username"].value;
				var password = document.forms["loginForm"]["Password"].value;
				if (username == "" || password == "") {
					alert("Username and Password must be filled out");
					return false;
				}
				return true;
			}
		</script>
	</head>
	
	<body>
		<div class="container">
			<div id="boxtitle" class="boxtitle">
				ORBS Code:6 Login
			</div>
			<form name="loginForm" method="post" action="check.jsp" onsubmit="return validateForm()">
				<table>
					<tr id="firstnameRow" class="hidden">
						<td>Firstname:</td>
						<td><input type="text" name="Firstname"></td>
					</tr>
					<tr id="lastnameRow" class="hidden">
						<td>Lastname:</td>
						<td><input type="text" name="Lastname"></td>
					</tr>
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
					<input id="loginButton" type="submit" value="Login"/>
					<input id="registerButton" type="button" value="Register" onclick="toggleRegisterMode()"/>
				</div>
			</form>
		</div>
	</body>
</html>