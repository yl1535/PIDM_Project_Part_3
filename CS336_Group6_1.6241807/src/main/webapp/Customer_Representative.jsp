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
            Edit Train Schedules
        </div>
        <div class="rectangle">
            List Customers
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
