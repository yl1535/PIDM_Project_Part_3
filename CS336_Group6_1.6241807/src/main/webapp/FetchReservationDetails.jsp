<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    int rn = Integer.parseInt(request.getParameter("rn"));
    String usr = (String) session.getAttribute("Username");

    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;
    ResultSet rs = null;

    try {
        con = db.getConnection();

        String resDetailsSQL = "SELECT R.ReservateDate, R.TrainTid, R.ScheduleTid, R.IfChild, R.IfSenior, R.IfDisabled, R.IfRound, TS.TotalFare, TS.Linename, " +
                               "(SELECT Deptime FROM Stops WHERE TrainTid = R.TrainTid AND ScheduleTid = R.ScheduleTid AND Arrtime IS NULL) AS StartTime, " +
                               "(SELECT Arrtime FROM Stops WHERE TrainTid = R.TrainTid AND ScheduleTid = R.ScheduleTid AND Deptime IS NULL) AS EndTime " +
                               "FROM Reservations R " +
                               "JOIN TrainSchedule TS ON R.TrainTid = TS.TrainTid AND R.ScheduleTid = TS.ScheduleTid " +
                               "WHERE R.RN = ? AND R.Usr = ?";
        pstm = con.prepareStatement(resDetailsSQL);
        pstm.setInt(1, rn);
        pstm.setString(2, usr);
        rs = pstm.executeQuery();

        if (rs.next()) {
            java.sql.Date reservateDate = rs.getDate("ReservateDate");
            String trainTid = rs.getString("TrainTid");
            String scheduleTid = rs.getString("ScheduleTid");
            int totalFare = rs.getInt("TotalFare");
            Timestamp startTime = rs.getTimestamp("StartTime");
            Timestamp endTime = rs.getTimestamp("EndTime");
            String Linename = rs.getString("Linename");
            boolean IfChild = rs.getBoolean("IfChild");
            boolean IfSenior = rs.getBoolean("IfSenior");
            boolean IfDisabled = rs.getBoolean("IfDisabled");
            boolean IfRound = rs.getBoolean("IfRound");

            boolean ifNotHistory = LocalDateTime.now().isBefore(startTime.toLocalDateTime());
            
            if(IfChild) totalFare*=0.75;
            if(IfSenior) totalFare*=0.65;
            if(IfDisabled) totalFare*=0.5;
            if(IfRound) totalFare*=2;

            StringBuilder modalContent = new StringBuilder();
            modalContent.append("<div style='text-align: center;'>");
            modalContent.append("<h3>Reservation No: ").append(rn).append("</h3>");
            modalContent.append("<p>Made at: ").append(reservateDate).append("</p>");
            modalContent.append("<p>Train: ").append(trainTid).append(", Transit Line: ").append(Linename).append(", ID: ").append(scheduleTid).append("</p>");
            modalContent.append("<p>Time: ").append(startTime).append(" ~ ").append(endTime).append("</p>");
            modalContent.append("<p>Cost: ").append(totalFare).append("</p>");

            if (ifNotHistory) {
                modalContent.append("<hr>");
                modalContent.append("<p>Do you want to cancel this reservation?</p>");
                modalContent.append("<button onclick='cancelReservation(").append(rn).append(")'>Yes</button>");
                modalContent.append("<button onclick='closeModal()'>No</button>");
            }

            modalContent.append("</div>");
            out.print(modalContent.toString());
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
