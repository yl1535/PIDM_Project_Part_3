<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.io.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Representative Portal</title>
</head>
<body>
    <h1>Welcome, Customer Representative!</h1>
    <form action="HelloWorld.jsp">
		<input type="submit" value="logout"/>
	</form>
    <h2>Edit Train Schedules</h2>
    <form method="post" action="editSchedule.jsp">
        Train ID: <input type="text" name="trainId" required>
        Schedule ID: <input type="text" name="scheduleId" required>
        Departure Time: <input type="datetime-local" name="departureTime" required>
        Arrival Time: <input type="datetime-local" name="arrivalTime" required>
        <button type="submit">Edit Schedule</button>
    </form>
    
    <h2>Customer Reservations</h2>
    <form method="get" action="viewReservations.jsp">
        Customer Username: <input type="text" name="username" required>
        <button type="submit">View Reservations</button>
    </form>
</body>
</html>
