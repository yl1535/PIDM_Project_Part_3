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

        	.button {
            	margin-left: auto;
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

        	function deleteBlock(blockId, QCode) {
            	var block = document.getElementById(blockId);
            	block.remove();
            	var xhr = new XMLHttpRequest();
            	xhr.open("POST", "RemoveQuestion.jsp", true);
            	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            	xhr.send("QCode=" + QCode);
        	}
        	function openCreateModal() {
                var content = `
                    <form class="modal-form" onsubmit="createBlock(event)">
                        <input type="text" id="newQTitle" name="qTitle" placeholder="Question Title" required />
                        <textarea id="newQuestion" name="question" placeholder="Question" required></textarea>
                        <button type="submit">Create</button>
                    </form>`;
                openModal(content);
            }

            function createBlock(event) {
                event.preventDefault();
                var qTitle = document.getElementById('newQTitle').value;
                var question = document.getElementById('newQuestion').value;
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "AddNewQuestion.jsp", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        closeModal();
                        location.reload();
                    }
                };
                xhr.send("qTitle=" + qTitle + "&question=" + question);
            }
    	</script>
	</head>
	<body>
		<% 
			ApplicationDB db = new ApplicationDB();
			Connection con = null;
			PreparedStatement pstm = null;
			ResultSet rs = null;
			try {
				con = db.getConnection();
		%>
    	<div class="top-part">
        	<%
        		String Username = (String) session.getAttribute("Username");
			
				out.print("<h1>");
				out.print("Welcome Back, " + Username);
				out.print("</h1>");
			%>
    	</div>
    	<div class="bottom-part">
        	<div class="rectangle">
            	<div class="title">Check And Book</div>
        	</div>
        	<div class="rectangle">
            	<div class="title">History Reservation Check</div>
        	</div>
        	<div class="rectangle">
        		<div class="title-container">
            		<div class="box-title">Question Box</div>
            		<button onclick="openCreateModal()">Post A New Question</button>
            	</div>
            	<div class="scrollable-area">
            		<%
            			String BlockRequest = "SELECT QTitle, Question, QCode, Reply, ReplyUsr FROM QuestionBox WHERE Usr = ?";
            			pstm = con.prepareStatement(BlockRequest);
            			pstm.setString(1, Username);
            			rs = pstm.executeQuery();
            			int blockId = 0;
            			while (rs.next()) {
            				String QTitle = rs.getString("QTitle");
            				String Question = rs.getString("Question");
            				int QCode = rs.getInt("QCode");
            				String Reply = rs.getString("Reply");
            				String ReplyUsr = rs.getString("ReplyUsr");
            				blockId++;
            				String blockColor = (ReplyUsr != null) ? "lightgreen" : "lightcoral";
            		%>
            		<div class="block" id="block<%=blockId%>" style="background-color: <%=blockColor%>;" onclick="openModal('Question: <br> <%=Question%> <br> Reply: <br> <%= (Reply == null ? "No reply to this question yet" : Reply) %> <br> Replier: <br> <%= (ReplyUsr == null ? "Waiting for a replier" : ReplyUsr) %>')">
            			<span class="block-title"><%=QTitle%></span>
            			<button class="button" onclick="event.stopPropagation(); deleteBlock('block<%=blockId%>', <%=QCode%>)">Delete</button>
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
			} catch (Exception e){
				e.printStackTrace();
			} finally {
	            try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
	            try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
	            try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
	        }
    	%>
	</body>
</html>