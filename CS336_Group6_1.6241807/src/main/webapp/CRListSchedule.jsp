<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	ApplicationDB db = new ApplicationDB();
	Connection con = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	PreparedStatement pstm = null;
	StringBuilder responseText = new StringBuilder();

	try {
		con = db.getConnection();
		String CRLSName = request.getParameter("CRLSName");
		String CRLSType = request.getParameter("CRLSType");
		String CRLSQuery = "SELECT ScheduleTid, TrainTid, Linename FROM TrainSchedule";
		pstm = con.prepareStatement(CRLSQuery);
		rs = pstm.executeQuery();
		while(rs.next()){
			String ScheduleTid = rs.getString("ScheduleTid");
			String TrainTid = rs.getString("TrainTid");
			String Linename = rs.getString("Linename");
			String Origin = "";
			String Destination = "";
			CRLSQuery = "SELECT SO.Deptime, SO.Arrtime, SA.Stationname FROM Stops SO INNER JOIN Station SA ON SO.Sid = SA.Sid WHERE SO.ScheduleTid = ?";
			pstm = con.prepareStatement(CRLSQuery);
			pstm.setString(1, ScheduleTid);
			rs2 = pstm.executeQuery();
			while(rs2.next()){
				String Stationname = rs2.getString("Stationname");
				Timestamp Arrtime = rs2.getTimestamp("Arrtime");
				Timestamp Deptime = rs2.getTimestamp("Deptime");
				if(Arrtime == null) Origin = Stationname;
				if(Deptime == null) Destination = Stationname;
			}
			if(CRLSType.equals("Origin")){
				if(!Origin.equals(CRLSName)) continue;
			}
			else{
				if(!Destination.equals(CRLSName)) continue;
			}
			responseText.append("<span class='block-title'>")
			            .append(ScheduleTid).append(" ").append(TrainTid).append(" ")
			            .append(Linename).append(" ").append(Origin).append(" ~ ")
			            .append(Destination).append("</span><br>");
		}
	} catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }

    out.print(responseText.toString());
%>
