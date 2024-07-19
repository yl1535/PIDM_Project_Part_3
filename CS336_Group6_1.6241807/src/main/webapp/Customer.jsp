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
        	
        	.book {
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

    		function openSearchBookModal() {
    	        var content = `
    	            <form class="modal-form" onsubmit="searchBooks(event)">
    	                <input type="text" id="origin" name="origin" placeholder="Enter origin station ID" required />
    	                <input type="text" id="destination" name="destination" placeholder="Enter destination station ID" required />
    	                <input type="text" id="travelDate" name="travelDate" placeholder="Enter travel date (YYYY-MM-DD)" required />
    	                <button type="submit" class="modal-form-button">Search</button>
    	            </form>`;
    	        openModal(content);
    	    }

    	    function searchBooks(event) {
    	        event.preventDefault();
    	        var origin = document.getElementById('origin').value;
    	        var destination = document.getElementById('destination').value;
    	        var travelDate = document.getElementById('travelDate').value;
    	        var xhr = new XMLHttpRequest();
    	        xhr.open("POST", "SearchBooks.jsp", true);
    	        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    	        xhr.onreadystatechange = function() {
    	            if (xhr.readyState === 4 && xhr.status === 200) {
    	                document.getElementById('bookResults').innerHTML = xhr.responseText;
    	                closeModal();
    	                document.getElementById('exitSearchBookButton').style.display = 'block';
    	                document.getElementById('searchbookButton').style.display = 'none';
    	                document.getElementById('sortButton').style.display = 'block';
    	                document.getElementById('exitSortBookButton').style.display = 'none';
    	                document.getElementById('bookTitle').innerText = 'Search Results';
    	            }
    	        };
    	        xhr.send("origin=" + origin + "&destination=" + destination + "&travelDate=" + travelDate);
    	    }

    	    function exitSearchBookResults() {
    	        var xhr = new XMLHttpRequest();
    	        xhr.open("POST", "ClearSearchResults.jsp", true);
    	        xhr.onreadystatechange = function() {
    	            if (xhr.readyState === 4 && xhr.status === 200) {
    	                location.reload();
    	            }
    	        };
    	        xhr.send();
    	    }

    	    function openSortBookModal() {
    	        var content = `
    	            <form class="modal-form" onsubmit="sortBooks(event)">
    	                <select id="sortCriteria" name="sortCriteria" required>
    	                    <option value="Dtime">Arrival Time</option>
    	                    <option value="Otime">Departure Time</option>
    	                    <option value="Fare">Fare</option>
    	                </select>
    	                <button type="submit" class="modal-form-button">Sort</button>
    	            </form>`;
    	        openModal(content);
    	    }

    	    function sortBooks(event) {
    	        event.preventDefault();
    	        var sortCriteria = document.getElementById('sortCriteria').value;
    	        var xhr = new XMLHttpRequest();
    	        xhr.open("POST", "SortSearchResults.jsp", true);
    	        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    	        xhr.onreadystatechange = function() {
    	            if (xhr.readyState === 4 && xhr.status === 200) {
    	                document.getElementById('bookResults').innerHTML = xhr.responseText;
    	                closeModal();
    	                document.getElementById('exitSortBookButton').style.display = 'block';
    	                document.getElementById('sortButton').style.display = 'none';
    	                document.getElementById('searchbookButton').style.display = 'none';
    	                document.getElementById('exitSearchBookButton').style.display = 'none';
    	                document.getElementById('bookTitle').innerText = 'Sorted Results';
    	            }
    	        };
    	        xhr.send("sortCriteria=" + sortCriteria);
    	    }

    	    function exitSortBookResults() {
    	        var xhr = new XMLHttpRequest();
    	        xhr.open("POST", "LoadSearchResults.jsp", true);
    	        xhr.onreadystatechange = function() {
    	            if (xhr.readyState === 4 && xhr.status === 200) {
    	                document.getElementById('bookResults').innerHTML = xhr.responseText;
    	                document.getElementById('exitSortBookButton').style.display = 'none';
    	                document.getElementById('sortButton').style.display = 'block';
    	                document.getElementById('searchbookButton').style.display = 'none';
    	                document.getElementById('exitSearchBookButton').style.display = 'block';
    	                document.getElementById('bookTitle').innerText = 'Search Results';
    	            }
    	        };
    	        xhr.send();
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
		%>
    	<div class="top-part">
        	<%
        		String Username = (String) session.getAttribute("Username");
			
				out.print("<h1>");
				out.print("Welcome Back, " + Username);
				out.print("</h1>");
			%>
			<form action="HelloWorld.jsp">
				<input type="submit" value="logout"/>
			</form>
    	</div>
    	<div class="bottom-part">
        	<div class="rectangle">
    <div class="title-container">
        <div id="bookTitle" class="book-title">Book The Trains</div>
        <button id="searchbookButton" onclick="openSearchBookModal()">Search For Trains</button>
        <button id="sortButton" onclick="openSortBookModal()" style="display: none;">Sort</button>
        <button id="exitSearchBookButton" onclick="exitSearchBookResults()" style="display: none;">Exit Search Results</button>
        <button id="exitSortBookButton" onclick="exitSortBookResults()" style="display: none;">Exit Sort Results</button>
    </div>
    <div class="scrollable-area" id="bookResults">
        <% 
            String BookRequest = "SELECT TrainTid, ScheduleTid, Linename, TotalFare FROM TrainSchedule";
            pstm = con.prepareStatement(BookRequest);
            rs = pstm.executeQuery();
            int bookId = 0;
            while (rs.next()) {
                String ScheduleTid = rs.getString("ScheduleTid");
                String TrainTid = rs.getString("TrainTid");
                String Linename = rs.getString("Linename");
                int TotalFare = rs.getInt("TotalFare");
                String StationRequest = "SELECT ScheduleTid, Deptime, Arrtime, Sid FROM Stops WHERE ScheduleTid = ?";
                pstm2 = con.prepareStatement(StationRequest);
                pstm2.setString(1, ScheduleTid);
                rs2 = pstm2.executeQuery();
                String Origin = "";
                Timestamp StartTime = null;
                String Destination = "";
                Timestamp EndTime = null;
                while (rs2.next()){
                    String Sid = rs2.getString("Sid");
                    Timestamp Arrtime = rs2.getTimestamp("Arrtime");
                    Timestamp Deptime = rs2.getTimestamp("Deptime");
                    if(Arrtime == null){
                        Origin = Sid;
                        StartTime = Deptime;
                    }
                    if(Deptime == null){
                        Destination = Sid;
                        EndTime = Arrtime;
                    }
                }
                bookId++;
        %>
        <div class="book" id="book<%=bookId%>" onclick="">
            <span class="book-title"><%=ScheduleTid%> <%=TrainTid%> <%=Linename%> <%=Origin%> <%=StartTime%> <%=Destination%> <%=EndTime%> Fare: <%=TotalFare%></span>
        </div>
        <% 
            } 
        %>
    </div>
</div>
        	<div class="rectangle">
            	<div class="title">History Reservation Check</div>
        	</div>
        	<div class="rectangle">
        		<div class="title-container">
            		<div id="boxTitle" class="box-title">Question Box</div>
            		<button id="searchButton" onclick="openSearchModal()">Search Questions</button>
            		<button id="openCreateModalButton" onclick="openCreateModal()">Post A New Question</button>
            		<button id="exitSearchButton" onclick="exitSearchResults()" style="display: none;">Exit Search Results</button>
            	</div>
            	<div class="scrollable-area">
            		<%
            			String BlockRequest = "SELECT QTitle, Question, QCode, Reply, ReplyUsr FROM QuestionBox";
            			pstm = con.prepareStatement(BlockRequest);
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
				try { if (rs2 != null) rs2.close(); } catch (Exception e) { e.printStackTrace(); }
	            try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
	            try { if (pstm2 != null) pstm2.close(); } catch (Exception e) { e.printStackTrace(); }
	            try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
	            try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
	        }
    	%>
	</body>
</html>