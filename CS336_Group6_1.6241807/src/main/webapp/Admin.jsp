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
        	
        	.book {
            	height: calc(100% / 6);
            	border: 1px solid black;
            	margin-bottom: 10px;
            	display: flex;
            	justify-content: space-between;
            	align-items: center;
            	padding: 10px;
        	}
        	
        	.Res {
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
        	
        	.book-title {
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
                        <input type="text" id="newTrainTid" name="trainTid" placeholder="Train ID" required />
                        <input type="text" id="newLinename" name="linename" placeholder="Line Name" required />
                        <button type="submit" class="modal-form-button">Create</button>
                    </form>`;
                openModal(content);
            }

            function createTrain(event) {
                event.preventDefault();
                var trainTid = document.getElementById('newTrainTid').value;
                var linename = document.getElementById('newLinename').value;
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "AddNewTrain.jsp", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        closeModal();
                        location.reload();
                    }
                };
                xhr.send("trainTid=" + trainTid + "&linename=" + linename);
            }
            
            function openCreateScheduleModal() {
                var content = `
                    <form class="modal-form" onsubmit="createSchedule(event)">
                        <input type="text" id="newScheduleTid" name="scheduleTid" placeholder="Schedule ID" required />
                        <input type="text" id="newTrainTid" name="trainTid" placeholder="Train ID" required />
                        <input type="text" id="newLinename" name="linename" placeholder="Line Name" required />
                        <input type="text" id="newTotalFare" name="totalFare" placeholder="Total Fare" required />
                        <button type="submit" class="modal-form-button">Create</button>
                    </form>`;
                openModal(content);
            }

            function createSchedule(event) {
                event.preventDefault();
                var scheduleTid = document.getElementById('newScheduleTid').value;
                var trainTid = document.getElementById('newTrainTid').value;
                var linename = document.getElementById('newLinename').value;
                var totalFare = document.getElementById('newTotalFare').value;
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "AddNewSchedule.jsp", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        closeModal();
                        location.reload();
                    }
                };
                xhr.send("scheduleTid=" + scheduleTid + "&trainTid=" + trainTid + "&linename=" + linename + "&totalFare=" + totalFare);
            }
            
            function openSearchModal() {
                var content = `
                    <form class="modal-form" onsubmit="searchQuestions(event)">
                        <input type="text" id="searchKeyword" name="keyword" placeholder="Enter search keyword" required />
                        <button type="submit" class="modal-form-button">Search</button>
                    </form>`;
                openModal(content);
            }
    		
    		function searchQuestions(event) {
                event.preventDefault();
                var keyword = document.getElementById('searchKeyword').value.toLowerCase();
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
                document.getElementById('exitSearchButton').style.display = 'block';
                document.getElementById('openCreateModalButton').style.display = 'none';
                document.getElementById('searchButton').style.display = 'none';
                document.getElementById('boxTitle').innerText = 'Search Results';
            }
    		
    		function exitSearchResults() {
                var blocks = document.getElementsByClassName('block');
                for (var i = 0; i < blocks.length; i++) {
                    blocks[i].style.display = 'flex';
                }
                document.getElementById('exitSearchButton').style.display = 'none';
                document.getElementById('openCreateModalButton').style.display = 'block';
                document.getElementById('searchButton').style.display = 'block';
                document.getElementById('boxTitle').innerText = 'Question Box';
            }

    		function fetchScheduleDetails(scheduleTid) {
    	        var xhr = new XMLHttpRequest();
    	        xhr.open("POST", "FetchScheduleDetails.jsp", true);
    	        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    	        xhr.onreadystatechange = function() {
    	            if (xhr.readyState === 4 && xhr.status === 200) {
    	                openModal(xhr.responseText);
    	            }
    	        };
    	        xhr.send("scheduleTid=" + scheduleTid);
    	    }

    	    function closeReservationModal() {
    	        closeModal();
    	    }

    	    function fetchReservationDetails(rn) {
    	        var xhr = new XMLHttpRequest();
    	        xhr.open("POST", "FetchReservationDetails.jsp", true);
    	        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    	        xhr.onreadystatechange = function() {
    	            if (xhr.readyState === 4 && xhr.status === 200) {
    	                openModal(xhr.responseText);
    	            }
    	        };
    	        xhr.send("rn=" + rn);
    	    }

    	    function submitResponse(qid) {
    	        var response = document.getElementById("responseTextarea").value;
    	        var xhr = new XMLHttpRequest();
    	        xhr.open("POST", "SubmitResponse.jsp", true);
    	        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    	        xhr.onreadystatechange = function() {
    	            if (xhr.readyState === 4 && xhr.status === 200) {
    	                closeModal();
    	                location.reload();
    	            }
    	        };
    	        xhr.send("qid=" + qid + "&response=" + response);
    	    }
    		
    	</script>
	</head>
	<body>
    	<div class="top-part">
        	<h1>Admin</h1>
    	</div>
    	<div class="bottom-part">
    		<div class="rectangle">
            	<div class="title-container">
                	<h2 id="boxTitle">Question Box</h2>
                	<button id="openCreateModalButton" class="button" onclick="openCreateTrainModal()">Create</button>
                	<button id="searchButton" class="button" onclick="openSearchModal()">Search</button>
                	<button id="exitSearchButton" class="button" style="display:none;" onclick="exitSearchResults()">Exit Search</button>
            	</div>
            	<div class="scrollable-area">
            	
            	
                	<!-- Question blocks go here?? -->
                	
                	
                	<%
                    DatabaseConnections dbc = new DatabaseConnections();
                    List<Question> questionList = dbc.getAllQuestions();
                    for (Question q : questionList) {
                    %>
                    <div class="block">
                        <div class="block-title"><%= q.getQid() %>: <%= q.getQuestion() %></div>
                        <button class="button" onclick="openCreateTrainModal()">Create</button>
                    </div>
                    <% } %>
            	</div>
        	</div>
    		
        	<div class="rectangle">
            	<div class="title-container">
                	<h2>Train Box</h2>
                	<button id="openCreateModalButton" class="button" onclick="openCreateTrainModal()">Create</button>
                	<button id="searchButton" class="button" onclick="openSearchModal()">Search</button>
                	<button id="exitSearchButton" class="button" style="display:none;" onclick="exitSearchResults()">Exit Search</button>
            	</div>
            	<div class="scrollable-area">
                	
                	
                	
                	<!-- Train blocks go here? -->
                	
                	
                	
                	<%
                    List<Train> trainList = dbc.getAllTrains();
                    for (Train t : trainList) {
                    %>
                    <div class="block">
                        <div class="block-title"><%= t.getTid() %>: <%= t.getLinename() %></div>
                        <button class="button" onclick="fetchScheduleDetails('<%= t.getTid() %>')">Details</button>
                    </div>
                    <% } %>
            	</div>
        	</div>
    		
        	<div class="rectangle">
            	<div class="title-container">
                	<h2>Reservation Box</h2>
                	<button id="openCreateModalButton" class="button" onclick="openCreateScheduleModal()">Create</button>
                	<button id="searchButton" class="button" onclick="openSearchModal()">Search</button>
                	<button id="exitSearchButton" class="button" style="display:none;" onclick="exitSearchResults()">Exit Search</button>
            	</div>
            	<div class="scrollable-area">
            	
            	
                	<!-- Reservation blocks go here?? -->
                	
                	
                	<%
                    List<Reservation> reservationList = dbc.getAllReservations();
                    for (Reservation r : reservationList) {
                    %>
                    <div class="block">
                        <div class="block-title"><%= r.getRn() %>: <%= r.getName() %></div>
                        <button class="button" onclick="fetchReservationDetails('<%= r.getRn() %>')">Details</button>
                    </div>
                    <% } %>
            	</div>
        	</div>
    	</div>

    	<div id="modal" class="modal">
        	<div id="modal-content" class="modal-content"></div>
    	</div>
	</body>
</html>
