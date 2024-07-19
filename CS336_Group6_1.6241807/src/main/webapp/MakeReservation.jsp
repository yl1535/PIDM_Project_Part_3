<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    String scheduleTid = (String) session.getAttribute("scheduleTid");
    String trainTid = (String) session.getAttribute("trainTid");
    boolean ifRound = Boolean.parseBoolean(request.getParameter("ifRound"));
    boolean ifChild = Boolean.parseBoolean(request.getParameter("ifChild"));
    boolean ifDisabled = Boolean.parseBoolean(request.getParameter("ifDisabled"));
    boolean ifSenior = Boolean.parseBoolean(request.getParameter("ifSenior"));

    String usr = (String) session.getAttribute("Username");

    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;

    try {
        con = db.getConnection();

        String reservationSQL = "INSERT INTO Reservations (RN, ReservateDate, IfChild, IfSenior, IfDisabled, IfRound, Usr, TrainTid, ScheduleTid) " +
                                "VALUES (?, CURRENT_DATE, ?, ?, ?, ?, ?, ?, ?)";
        pstm = con.prepareStatement(reservationSQL);
        
        int RN = new Random().nextInt(1535);

        pstm.setInt(1, RN);
        pstm.setBoolean(2, ifChild);
        pstm.setBoolean(3, ifSenior);
        pstm.setBoolean(4, ifDisabled);
        pstm.setBoolean(5, ifRound);
        pstm.setString(6, usr);
        pstm.setString(7, trainTid);
        pstm.setString(8, scheduleTid);
        pstm.executeUpdate();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
