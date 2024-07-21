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

        	function openCreateTrainModal() {
                var content = `
                    <form class="modal-form" onsubmit="createTrain(event)">
                        <input type="text" id="newTrainID" name="trainID" placeholder="Train ID" required />
                        <input type="text" id="newTrainName" name="trainName" placeholder="Train Name" required />
                        <button type="submit">Create</button>
                    </form>`;
                openModal(content);
            }

            function createTrain(event) {
                event.preventDefault();
                var trainID = document.getElementById('newTrainID').value;
                var trainName = document.getElementById('newTrainName').value;
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "AddNewTrain.jsp", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        closeModal();
                        location.reload();
                    }
                };
                xhr.send("trainID=" + trainID + "&trainName=" + trainName);
            }

            function openSearchTrainModal() {
                var content = `
                    <form class="modal-form" onsubmit="searchTrains(event)">
                        <input type="text" id="searchTrainKeyword" name="keyword" placeholder="Enter search keyword" required />
                        <button type="submit" class="modal-form-button">Search</button>
                    </form>`;
                openModal(content);
            }

    		function searchTrains(event) {
                event.preventDefault();
                var keyword = document.getElementById('searchTrainKeyword').value.toLowerCase();
                var blocks = document.getElementsByClassName('block');
                for (var i = 0; i < blocks.length; i++) {
                    var title = blocks[i].getElementsByClassName('block-title')[0].innerText.toLowerCase();
                    if (title.includes(keyword)) {
                        blocks[i].style.display = 'flex';
                    } else {
                        blocks[i].style.display = 'none';
                    }
                }
                closeModal();
                document.getElementById('exitSearchTrainButton').style.display = 'block';
                document.getElementById('openCreateTrainModalButton').style.display = 'none';
                document.getElementById('searchTrainButton').style.display = 'none';
                document.getElementById('boxTitle').innerText = 'Search Results';
            }

    		function exitSearchTrainResults() {
                var blocks = document.getElementsByClassName('block');
                for (var i = 0; i < blocks.length; i++) {
                    blocks[i].style.display = 'flex';
                }
                document.getElementById('exitSearchTrainButton').style.display = 'none';
                document.getElementById('openCreateTrainModalButton').style.display = 'block';
                document.getElementById('searchTrainButton').style.display = 'block';
                document.getElementById('boxTitle').innerText = 'Train List';
            }

    		function fetchTrainDetails(trainID) {
    	        var xhr = new XMLHttpRequest();
    	        xhr.open("POST", "FetchTrainDetails.jsp", true);
    	        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    	        xhr.onreadystatechange = function() {
    	            if (xhr.readyState === 4 && xhr.status === 200) {
    	                openModal(xhr.responseText);
    	            }
    	        };
    	        xhr.send("trainID=" + trainID);
    	    }

    	    function closeTrainModal() {
    	        closeModal();
    	    }
    	    
    	    function openTrainHistoryModal() {
                var content = `
                    <form class="modal-form" onsubmit="searchTrainHistory(event)">
                        <input type="text" id="searchTrainHistoryKeyword" name="keyword" placeholder="Enter train ID" required />
                        <button type="submit" class="modal-form-button">Search</button>
                    </form>`;
                openModal(content);
            }
            
            function searchTrainHistory(event) {
                event.preventDefault();
                var trainID = document.getElementById('searchTrainHistoryKeyword').value.toLowerCase();
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "FetchTrainHistory.jsp", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        document.getElementById('trainHistoryResults').innerHTML = xhr.responseText;
                        closeModal();
                    }
                };
                xhr.send("trainID=" + trainID);
            }
            
            function exitTrainHistoryResults() {
                location.reload();
            }

    		function openResolveQuestionModal(questionID) {
    	        var content = `
    	            <form class="modal-form" onsubmit="resolveQuestion(event, ${questionID})">
    	                <textarea id="replyContent" name="replyContent" placeholder="Enter your reply" required></textarea>
    	                <button type="submit" class="modal-form-button">Submit</button>
    	            </form>`;
    	        openModal(content);
    	    }

    	    function resolveQuestion(event, questionID) {
    	        event.preventDefault();
    	        var replyContent = document.getElementById('replyContent').value;
    	        var xhr = new XMLHttpRequest();
    	        xhr.open("POST", "ResolveQuestion.jsp", true);
    	        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    	        xhr.onreadystatechange = function() {
    	            if (xhr.readyState === 4 && xhr.status === 200) {
    	                closeModal();
    	                location.reload();
    	            }
    	        };
    	        xhr.send("questionID=" + questionID + "&replyContent=" + replyContent);
    	    }

    	    function openQuestionDetailsModal(questionID) {
    	        var xhr = new XMLHttpRequest();
    	        xhr.open("POST", "FetchQuestionDetails.jsp", true);
    	        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    	        xhr.onreadystatechange = function() {
    	            if (xhr.readyState === 4 && xhr.status === 200) {
    	                openModal(xhr.responseText);
    	            }
    	        };
    	        xhr.send("questionID=" + questionID);
    	    }

    	    function closeQuestionDetailsModal() {
    	        closeModal();
    	    }
    	</script>
	</head>
	<body>
		<div class="top-part">
        	<h1>Admin Dashboard</h1>
    	</div>
    	<div class="bottom-part">
        	<div class="rectangle">
            	<div class="title-container">
                	<h2 id="boxTitle">Train List</h2>
                	<button onclick="openSearchTrainModal()" id="searchTrainButton">Search</button>
                	<button onclick="exitSearchTrainResults()" id="exitSearchTrainButton" style="display:none;">Exit Search</button>
                	<button onclick="openCreateTrainModal()" id="openCreateTrainModalButton">Create Train</button>
            	</div>
            	<div class="scrollable-area">
                	<%
                	List<Train> trainList = (List<Train>)request.getAttribute("trainList");
                	if(trainList != null) {
                    	for (Train train : trainList) {
                        	String trainID = train.getTrainID();
                        	String trainName = train.getTrainName();
                	%>
                    	<div class="block">
                        	<div class="block-title"><%=trainName%> (ID: <%=trainID%>)</div>
                        	<button onclick="fetchTrainDetails('<%=trainID%>')">View Details</button>
                    	</div>
                	<%
                    	}
                	}
                	%>
            	</div>
        	</div>
        	
        	<div class="rectangle">
            	<div class="title-container">
                	<h2>Train History</h2>
                	<button onclick="openTrainHistoryModal()">Search</button>
            	</div>
            	<div id="trainHistoryResults" class="scrollable-area">
            	
            	
                	<!-- Populate history results? -->
                	
                	
            	</div>
        	</div>
        	
        	<div class="rectangle">
            	<div class="title-container">
                	<h2>Questions</h2>
            	</div>
            	<div class="scrollable-area">
                	<%
                	List<Question> questionList = (List<Question>)request.getAttribute("questionList");
                	if(questionList != null) {
                    	for (Question question : questionList) {
                        	String questionID = question.getQuestionID();
                        	String questionContent = question.getQuestionContent();
                        	LocalDateTime createdAt = question.getCreatedAt();
                	%>
                    	<div class="block">
                        	<div class="block-title"><%=questionContent%> (ID: <%=questionID%>)</div>
                        	<button onclick="openQuestionDetailsModal('<%=questionID%>')">View Details</button>
                        	<button onclick="openResolveQuestionModal('<%=questionID%>')">Resolve</button>
                    	</div>
                	<%
                    	}
                	}
                	%>
            	</div>
        	</div>
        	
    	</div>

    	<div id="modal" class="modal">
        	<div class="modal-content" id="modal-content">
        	</div>
    	</div>
	</body>
</html>
