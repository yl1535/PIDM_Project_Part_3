<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.io.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Portal</title>
</head>
<body>
    <h1>Welcome, Admin</h1>
    <form action="HelloWorld.jsp">
		<input type="submit" value="logout"/>
	</form>
    <h2>Manage Customer Representatives</h2>
    <form method="post" action="manageReps.jsp">
        Username: <input type="text" name="username" required>
        Action: 
        <select name="action" required>
            <option value="add">Add</option>
            <option value="edit">Edit</option>
            <option value="delete">Delete</option>
        </select>
        <button type="submit">Submit</button>
    </form>
    
    <h2>Generate Reports</h2>
    <form method="get" action="generateReport.jsp">
        Report Type: 
        <select name="reportType" required>
            <option value="monthlyRevenue">Monthly Revenue</option>
            <option value="reservationsByLine">Reservations by Line</option>
            <option value="totalRevenueByCustomer">Total Revenue by Customer</option>
            <option value="mostActiveLines">Most Active Lines</option>
        </select>
        <button type="submit">Generate</button>
    </form>
</body>
</html>
