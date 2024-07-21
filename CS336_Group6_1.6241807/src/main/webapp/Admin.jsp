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
            	width: calc((100% / 6) - 20px);
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
    		</script>
	</head>
	<body>
		<%
        	ApplicationDB db = new ApplicationDB();
        	Connection con = null;
        	PreparedStatement pstm = null;
        	PreparedStatement pstm2 = null;
        	ResultSet rs = null;
        	try {
            	con = db.getConnection();
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
            	<form method="POST" action="Admin.jsp">
            		<div>
                		<label for="year">Year:</label>
                		<input type="number" id="year" name="year" required>
            		</div>
            		<div>
                		<label for="month">Month:</label>
                		<input type="number" id="month" name="month" min="1" max="12" required>
            		</div>
            		<div>
                		<button type="submit" class="modal-form-button">Get Report</button>
            		</div>
            	</form>
			</div>
			<div class="rectangle">
				<div class="title-container">
            		<div id="LRTitle" class="LR-Title">Produce List of Reservations</div>
            	</div>
            	
			</div>
			<div class="rectangle">
				<div class="title-container">
            		<div id="TRTitle" class="TR-Title">Produce Total Revenue</div>
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
    	<%
        	if (request.getMethod().equalsIgnoreCase("POST")) {
            	int year = Integer.parseInt(request.getParameter("year"));
            	int month = Integer.parseInt(request.getParameter("month"));

            	String sql = "SELECT ts.Linename, " +
                             "SUM(CASE WHEN r.RN IS NOT NULL THEN 1 ELSE 0 END) AS TotalPeople, " +
                             "SUM(CASE WHEN r.RN IS NOT NULL THEN ts.TotalFare ELSE 0 END) AS TotalFare " +
                             "FROM TrainSchedule ts " +
                             "LEFT JOIN Reservations r ON ts.TrainTid = r.TrainTid AND ts.ScheduleTid = r.ScheduleTid " +
                             "LEFT JOIN Stops s ON ts.TrainTid = s.TrainTid AND ts.ScheduleTid = s.ScheduleTid " +
                             "WHERE MONTH(s.Deptime) = ? AND YEAR(s.Deptime) = ? " +
                             "GROUP BY ts.Linename";

            	try {
                	pstm = con.prepareStatement(sql);
                	pstm.setInt(1, month);
                	pstm.setInt(2, year);
                	rs = pstm.executeQuery();

                	StringBuilder report = new StringBuilder();
                	report.append("<h2>Sales Report</h2>");
                	report.append("<table style='width:100%; text-align:center;'>");
                	report.append("<tr><th>Line Name</th><th>Total People</th><th>Total Fare Earned</th></tr>");

                	int totalPeople = 0;
                	int totalFare = 0;

                	while (rs.next()) {
                    	String lineName = rs.getString("Linename");
                    	int people = rs.getInt("TotalPeople");
                    	int fare = rs.getInt("TotalFare");

                    	totalPeople += people;
                    	totalFare += fare;

                    	report.append("<tr><td>").append(lineName).append("</td><td>").append(people).append("</td><td>").append(fare).append("</td></tr>");
                	}

                	report.append("<tr><td>Total</td><td>").append(totalPeople).append("</td><td>").append(totalFare).append("</td></tr>");
                	report.append("</table>");

                	out.println("<script>openModal(`" + report.toString() + "`);</script>");
            	} catch (SQLException e) {
                	e.printStackTrace();
            	} finally {
                	try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
                	try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
            	}	
        	}
    	
        	} catch (Exception e) {
            	e.printStackTrace();
        	} finally {
            	try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
            	try { if (pstm2 != null) pstm2.close(); } catch (Exception e) { e.printStackTrace(); }
            	try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
            	try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
        	}
    	%>
	</body>
</html>
