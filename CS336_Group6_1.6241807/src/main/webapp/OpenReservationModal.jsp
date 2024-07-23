<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<form class="modal-form" action="MakeReservation.jsp" method="post">
    <label for="tripType">Trip Type:</label>
    <select id="tripType" name="tripType" required>
        <option value="oneway">One-way</option>
        <option value="roundtrip">Round-trip</option>
    </select>
    <label for="passengerType">Passenger Type:</label>
    <select id="passengerType" name="passengerType" required>
        <option value="normal">Normal</option>
        <option value="child">Child</option>
        <option value="disabled">Disabled</option>
        <option value="senior">Senior</option>
    </select>
    <button type="submit">Confirm Reservation</button>
</form>