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
        </script>
    </head>
    <body>
        <%
            String Username = (String) session.getAttribute("Username");
        %>
        <div class="top-part">
            <h1>Welcome, Admin <%=Username%></h1>
        </div>
        <div class="bottom-part">
            <div class="rectangle">
                <div class="title-container">
                    <div id="CRTitle" class="CR-Title">Edit/Delete Customer Representatives</div>
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
                
            </div>
            <div class="rectangle">
                <div class="title-container">
                    <div id="FATitle" class="FA-Title">Determine Most Popular Lines</div>
                </div>
                
            </div>
        </div>

        <div id="modal" class="modal" onclick="closeModal()">
        	<div id="modal-content" class="modal-content" onclick="event.stopPropagation()"></div>
    	</div>
    </body>
</html>
