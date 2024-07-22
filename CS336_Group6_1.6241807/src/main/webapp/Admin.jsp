<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.LocalDateTime"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Page</title>
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
                width: calc((100% / 5) - 20px);
                height: 80%;
                border: 2px solid black;
                position: relative;
                padding: 10px;
                display: flex;
                flex-direction: column;
            }
            
            .title-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px;
                border-bottom: 2px solid black;
            }
            
            .modal {
                display: none;
                position: fixed;
                z-index: 1;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0, 0, 0, 0.4);
                justify-content: center;
                align-items: center;
            }

            .modal-content {
                background-color: white;
                margin: auto;
                padding: 20px;
                border: 1px solid #888;
                width: 40%;
            }
            
            .modal-form {
                display: flex;
                flex-direction: column;
            }

            .modal-form-input {
                margin-bottom: 10px;
                padding: 5px;
            }

            .modal-form-button {
                align-self: flex-end;
                padding: 5px 10px;
            }
            
            .modal-form-button-SPECIAL {
                align-self: flex-end;
                padding: 50px 100px;
                font-weight: bold;
            }

        </style>
        <script>
            function openModal(content) {
                var modal = document.getElementById('modal');
                var modalContent = document.getElementById('modal-content');
                modalContent.innerHTML = content;
                modal.style.display = "flex";
            }

            function closeModal() {
                var modal = document.getElementById('modal');
                modal.style.display = "none";
            }

            function fetchSalesReport() {
                var year = document.getElementById('year').value;
                var month = document.getElementById('month').value;

                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'GenerateSalesReport.jsp', true);
                xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        openModal(xhr.responseText);
                    }
                };
                xhr.send('year=' + year + '&month=' + month);
            }

            function fetchAdminReservationList() {
                var criteria = document.getElementById('criteria').value;
                var search = document.getElementById('search').value;

                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'GenerateReservationList.jsp', true);
                xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        openModal(xhr.responseText);
                    }
                };
                xhr.send('criteria=' + criteria + '&search=' + search);
            }

            function fetchMostWelcomedCustomer() {
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'FindMostWelcomedCustomer.jsp', true);
                xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        openModal(xhr.responseText);
                    }
                };
                xhr.send();
            }

            function fetchMostPopularLines() {
                var year = document.getElementById('popYear').value;
                var month = document.getElementById('popMonth').value;

                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'FindMostPopularLines.jsp', true);
                xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        openModal(xhr.responseText);
                    }
                };
                xhr.send('year=' + year + '&month=' + month);
            }
            
            function updateForm() {
                var mode = document.getElementById('mode').value;
                var usernameLabel = document.getElementById('usernameLabel');
                var username = document.getElementById('username');
                var newUsernameLabel = document.getElementById('newUsernameLabel');
                var newUsername = document.getElementById('newUsername');
                var passwordLabel = document.getElementById('passwordLabel');
                var password = document.getElementById('password');

                if (mode === 'add') {
                    usernameLabel.style.display = 'none';
                    username.style.display = 'none';
                    newUsernameLabel.style.display = 'block';
                    newUsername.style.display = 'block';
                    passwordLabel.style.display = 'block';
                    password.style.display = 'block';
                } else if (mode === 'edit') {
                    usernameLabel.style.display = 'block';
                    username.style.display = 'block';
                    newUsernameLabel.style.display = 'block';
                    newUsername.style.display = 'block';
                    passwordLabel.style.display = 'block';
                    password.style.display = 'block';
                } else if (mode === 'delete') {
                    usernameLabel.style.display = 'block';
                    username.style.display = 'block';
                    newUsernameLabel.style.display = 'none';
                    newUsername.style.display = 'none';
                    passwordLabel.style.display = 'none';
                    password.style.display = 'none';
                }
            }

            function manageCustomerRepresentative() {
                var mode = document.getElementById('mode').value;
                var username = document.getElementById('username').value;
                var newUsername = document.getElementById('newUsername').value;
                var password = document.getElementById('password').value;

                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'ManageCustomerRepresentative.jsp', true);
                xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        openModal(xhr.responseText);
                    }
                };
                xhr.send('mode=' + mode + '&username=' + username + '&newUsername=' + newUsername + '&password=' + password);
            }

            document.addEventListener("DOMContentLoaded", function() {
                updateForm();
            });
        </script>
    </head>
    <body>
        <%
            String Username = (String) session.getAttribute("Username");
        %>
        <div class="top-part">
            <h1>Welcome, Admin <%=Username%></h1>
            <form action="HelloWorld.jsp">
            	<input type="submit" value="logout"/>
        	</form>
        </div>
        <div class="bottom-part">
            <div class="rectangle">
    			<div class="title-container">
        			<div id="CRTitle" class="CR-Title">Manage Customer Representatives</div>
    			</div>
    			<div>
        			<label for="mode">Select Mode:</label>
        			<select id="mode" name="mode" onchange="updateForm()">
            			<option value="add">Add</option>
            			<option value="edit">Edit</option>
            			<option value="delete">Delete</option>
        			</select>
    			</div>
    			<div>
        			<label id="usernameLabel" for="username">Username:</label>
        			<input type="text" id="username" name="username">
    			</div>
    			<div>
        			<label id="newUsernameLabel" for="newUsername">New Username:</label>
        			<input type="text" id="newUsername" name="newUsername">
    			</div>
    			<div>
        			<label id="passwordLabel" for="password">Password:</label>
        			<input type="password" id="password" name="password">
    			</div>
    			<div>
        			<button type="button" class="modal-form-button" onclick="manageCustomerRepresentative()">Submit</button>
    			</div>
			</div>
            <div class="rectangle">
                <div class="title-container">
                    <div id="SRTitle" class="SR-Title">Obtain Sales Report</div>
                </div>
                <div>
                    <label for="year">Year:</label>
                    <input type="number" id="year" name="year" required>
                </div>
                <div>
                    <label for="month">Month:</label>
                    <input type="number" id="month" name="month" min="1" max="12" required>
                </div>
                <div>
                    <button type="button" class="modal-form-button" onclick="fetchSalesReport()">Get Report</button>
                </div>
            </div>
            <div class="rectangle">
                <div class="title-container">
                    <div id="LRTitle" class="LR-Title">Produce List of Reservations And Total Revenue</div>
                </div>
                <div>
                    <label for="criteria">Select Criteria:</label>
                    <select id="criteria" name="criteria" required>
                        <option value="Linename">Transit Line Name</option>
                        <option value="Usr">Customer Username</option>
                    </select>
                </div>
                <div>
                    <label for="search">Enter Name:</label>
                    <input type="text" id="search" name="search" required>
                </div>
                <div>
                    <button type="button" class="modal-form-button" onclick="fetchAdminReservationList()">Search</button>
                </div>
            </div>
            <div class="rectangle">
                <div class="title-container">
                    <div id="BCTitle" class="BC-Title">Determine Best Customer</div>
                </div>
                <div>
                    <button type="button" class="modal-form-button-SPECIAL" onclick="fetchMostWelcomedCustomer()">Find Out Our Most Welcomed Customer!!!</button>
                </div>
            </div>
            <div class="rectangle">
                <div class="title-container">
                    <div id="FATitle" class="FA-Title">Find Most Popular Lines</div>
                </div>
                <div>
                    <label for="popYear">Year:</label>
                    <input type="number" id="popYear" name="popYear" required>
                </div>
                <div>
                    <label for="popMonth">Month:</label>
                    <input type="number" id="popMonth" name="popMonth" min="1" max="12" required>
                </div>
                <div>
                    <button type="button" class="modal-form-button" onclick="fetchMostPopularLines()">Find Out</button>
                </div>
            </div>
        </div>
        <div id="modal" class="modal" onclick="closeModal()">
            <div id="modal-content" class="modal-content" onclick="event.stopPropagation()"></div>
        </div>
    </body>
</html>
