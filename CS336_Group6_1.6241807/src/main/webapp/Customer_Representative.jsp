<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Representative Portal</title>
    <style>
        body, html {
            height: 100%;
            margin: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
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
            align-items: flex-start;
        }
        .rectangle {
            width: calc((100% / 4) - 20px);
            height: 80%;
            border: 2px solid black;
            position: relative;
            padding: 10px;
            display: flex;
            flex-direction: column;
            margin: 10px;
        }
        .scrollable-area {
            flex: 1;
            overflow-y: auto;
            padding: 10px;
            position: relative;
        }
        .block {
            height: calc(100% / 6);
            border: 1px solid black;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
        }
        .block-title {
            flex: 1;
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

        function openQuestionModal(qTitle, question, qCode) {
        	var xhr = new XMLHttpRequest();
	        xhr.open("POST", "AnswerQuestions.jsp", true);
	        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	        xhr.onreadystatechange = function() {
	            if (xhr.readyState === 4 && xhr.status === 200) {
	                openModal(xhr.responseText);
	            }
	        };
	        xhr.send("qTitle=" + qTitle + "&question=" + question + "&qCode=" + qCode);
        }
        
        function fetchSchedules(event) {
            event.preventDefault();
            var CRLSName = document.getElementById('CRLSName').value;
            var CRLSType = document.getElementById('CRLSType').value;
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "CRListSchedule.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    openModal(xhr.responseText);
                }
            };
            xhr.send("CRLSName=" + CRLSName + "&CRLSType=" + CRLSType);
        }
        
        function fetchCustomers(event) {
            event.preventDefault();
            var CRLCLine = document.getElementById('CRLCLine').value;
            var CRLCTime = document.getElementById('CRLCTime').value;
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "CRListCustomer.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    openModal(xhr.responseText);
                }
            };
            xhr.send("CRLCLine=" + CRLCLine + "&CRLCTime=" + CRLCTime);
        }
        
        function fetchEditSchedules(event) {
            event.preventDefault();
            var CRETSSTid = document.getElementById('CRETSSTid').value;
            var CRETSOperation = document.getElementById('CRETSOperation').value;

            if (CRETSOperation === "Delete") {
                if (confirm('Are you sure you want to delete this schedule?')) {
                    var xhr = new XMLHttpRequest();
                    xhr.open("POST", "DeleteSchedule.jsp", true);
                    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === 4 && xhr.status === 200) {
                            alert('Schedule deleted successfully.');
                        }
                    };
                    xhr.send("ScheduleTid=" + CRETSSTid);
                }
            } else {
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "EditScheduleDetails.jsp", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        openModal(xhr.responseText);
                    }
                };
                xhr.send("ScheduleTid=" + CRETSSTid);
            }
        }
        
        function openEditModal(type, scheduleTid) {
            var modalContent = document.getElementById('modal-content');
            var modalHtml = '';

            if (type === 'Linename' || type === 'TrainTid' || type === 'TotalFare') {
                modalHtml = '<div style="text-align:center;">' +
                            '<h2>Edit ' + type + '</h2>' +
                            '<form onsubmit="submitEdit(event, \'' + type + '\', \'' + scheduleTid + '\')">' +
                            '<input type="text" id="editInput" required>' +
                            '<button type="submit">Submit</button>' +
                            '</form></div>';
            } else if (type === 'Stops') {
                modalHtml = '<div style="text-align:center;">' +
                            '<h2>Edit/Delete Stops</h2>' +
                            '<form onsubmit="submitEditStop(event, \'' + scheduleTid + '\')">' +
                            'Station ID: <input type="text" id="stopSid" required><br>' +
                            'Arrival Time: <input type="datetime-local" id="stopArrtime"><br>' +
                            'Departure Time: <input type="datetime-local" id="stopDeptime"><br>' +
                            '<select id="stopOperation">' +
                            '<option value="Add">Add</option>' +
                            '<option value="Edit">Edit</option>' +
                            '<option value="Delete">Delete</option>' +
                            '</select>' +
                            '<button type="submit">Submit</button>' +
                            '</form></div>';
            }

            var secondModal = document.createElement('div');
            secondModal.id = 'second-modal';
            secondModal.className = 'modal';
            secondModal.innerHTML = '<div class="modal-content" onclick="event.stopPropagation()">' + modalHtml + '</div>';
            secondModal.onclick = function() {
                secondModal.remove();
            };
            document.body.appendChild(secondModal);
            secondModal.style.display = 'flex';
        }

        function submitEdit(event, type, scheduleTid) {
            event.preventDefault();
            var inputValue = document.getElementById('editInput').value;

            var xhr = new XMLHttpRequest();
            xhr.open("POST", "EditSchedule.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    if (xhr.responseText.includes("Update cancelled")) {
                        alert(xhr.responseText);
                    } else {
                        alert('Update successful.');
                        document.getElementById('second-modal').remove();
                        openModal(xhr.responseText);
                    }
                }
            };
            xhr.send("type=" + type + "&value=" + inputValue + "&ScheduleTid=" + scheduleTid);
        }

        function submitEditStop(event, scheduleTid) {
            event.preventDefault();
            var stopSid = document.getElementById('stopSid').value;
            var stopArrtime = document.getElementById('stopArrtime').value || '';
            var stopDeptime = document.getElementById('stopDeptime').value || '';
            var stopOperation = document.getElementById('stopOperation').value;

            if (stopArrtime === null && stopDeptime === null && !stopOperation === 'Delete') {
                alert("Either Arrival Time or Departure Time must be provided.");
                return;
            }

            var xhr = new XMLHttpRequest();
            xhr.open("POST", "EditStops.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    document.getElementById('second-modal').remove();
                    openModal(xhr.responseText);
                }
            };
            xhr.send("stopSid=" + stopSid + "&stopArrtime=" + stopArrtime + "&stopDeptime=" + stopDeptime + "&stopOperation=" + stopOperation + "&ScheduleTid=" + scheduleTid);
        }

    </script>
</head>
<body>
    <%
        ApplicationDB db = new ApplicationDB();
        Connection con = null;
        PreparedStatement pstm = null;
        PreparedStatement pstm2 = null;
        ResultSet rs = null;
        ResultSet rs2 = null;
        try {
            con = db.getConnection();
            String Username = (String) session.getAttribute("Username");
    %>
    <div class="top-part">
        <h1>Welcome, Customer Representative <%= Username %></h1>
        <form action="HelloWorld.jsp">
            <input type="submit" value="logout"/>
        </form>
    </div>
    <div class="bottom-part">
        <div class="rectangle">
            <div class="title-container">
            	<div id="TrainTitle" class="Train-Title">Edit/Delete Train Schedules</div>
            </div>
            <form class="modal-form" onsubmit="fetchEditSchedules(event)">
            	Type in Target Schedule-Tid: <input type="text" name="CRETSSTid" id="CRETSSTid" required><br>
            	Type in Specific Operation: 
            	<select name="CRETSOperation" id="CRETSOperation" size=1>
            		<option value="Edit">Edit</option>
            		<option value="Delete">Delete</option>
            	</select>
            	<button type="submit">Execute</button>
            </form>
        </div>
        <div class="rectangle">
            <div class="title-container">
            	<div id="CustomerTitle" class="Customer-Title">List Customers</div>
            </div>
            <form class="modal-form" onsubmit="fetchCustomers(event)">
    			Type in Target Transit Line Name: <input type="text" name="CRLCLine" id="CRLCLine" required><br>
    			Type in Target Day: <input type="date" name="CRLCTime" id="CRLCTime" required>
    			<button type="submit">Find Correspond Customers</button>
			</form>
        </div>
        <div class="rectangle">
        	<div class="title-container">
        		<div id="scheduleTitle" class="schedule-Title">List Schedules</div>
        	</div>
        	<form class="modal-form" onsubmit="fetchSchedules(event)">
        		Type in Target Station Name: <input type="text" name="CRLSName" id="CRLSName" required><br>
        		Choose Station Type: 
        		<select name="CRLSType" id="CRLSType" size=1>
        			<option value="Origin">Origin Station</option>
        			<option value="Destination">Destination Station</option>
        		</select>
        		<button type="submit">Find Correspond Schedules</button>
        	</form>
        </div>
        <div class="rectangle">
            <div class="title-container">
                <div id="boxTitle" class="box-title">Question Box</div>
            </div>
            <div class="scrollable-area">
                <%
                    String BlockRequest = "SELECT QTitle, Question, QCode, ReplyUsr FROM QuestionBox";
                    pstm = con.prepareStatement(BlockRequest);
                    rs = pstm.executeQuery();
                    int blockId = 0;
                    while (rs.next()) {
                        String QTitle = rs.getString("QTitle");
                        String Question = rs.getString("Question");
                        int QCode = rs.getInt("QCode");
                        String ReplyUsr = rs.getString("ReplyUsr");
                        blockId++;
                        boolean ifAnswered = (ReplyUsr != null);
                %>
                <div class="block" id="block<%=blockId%>" style="<%= ifAnswered ? "display: none;" : "background-color: lightcoral" %>;" onclick="openQuestionModal('<%=QTitle%>', '<%=Question%>', '<%=QCode%>')">
            		<span class="block-title"><%=QTitle%></span>
            	</div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    <div id="modal" class="modal" onclick="closeModal()">
        <div id="modal-content" class="modal-content" onclick="event.stopPropagation()"></div>
    </div>
    <%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs2 != null) rs2.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (pstm2 != null) pstm2.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    %>
</body>
</html>
