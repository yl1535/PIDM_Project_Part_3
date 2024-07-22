<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.sql.*"%>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement pstm = null;
    ResultSet rs = null;
    String mode = request.getParameter("mode");
    String username = request.getParameter("username");
    String newUsername = request.getParameter("newUsername");
    String password = request.getParameter("password");

    try {
        con = db.getConnection();

        if ("add".equalsIgnoreCase(mode)) {
            
            String checkUserSql = "SELECT * FROM Users WHERE Usr = ?";
            pstm = con.prepareStatement(checkUserSql);
            pstm.setString(1, newUsername);
            rs = pstm.executeQuery();

            if (rs.next()) {
                out.println("<p>New username already exists.</p>");
            } else {
                String addUserSql = "INSERT INTO Users (Firstname, Lastname, Usr, Pwd, UsrType) VALUES ('CR', 'User', ?, ?, 'Representative')";
                pstm = con.prepareStatement(addUserSql);
                pstm.setString(1, newUsername);
                pstm.setString(2, password);
                pstm.executeUpdate();

                String addEmployeeSql = "INSERT INTO Employees (Usr, SSN) VALUES (?, '0000000000')";
                pstm = con.prepareStatement(addEmployeeSql);
                pstm.setString(1, newUsername);
                pstm.executeUpdate();

                out.println("<p>Customer Representative added successfully.</p>");
            }
        } else if ("edit".equalsIgnoreCase(mode)) {
            
            String findUserSql = "SELECT * FROM Users WHERE Usr = ?";
            pstm = con.prepareStatement(findUserSql);
            pstm.setString(1, username);
            rs = pstm.executeQuery();

            if (!rs.next()) {
                out.println("<p>Username not found.</p>");
            } else {
                String checkNewUserSql = "SELECT * FROM Users WHERE Usr = ?";
                pstm = con.prepareStatement(checkNewUserSql);
                pstm.setString(1, newUsername);
                rs = pstm.executeQuery();

                if (rs.next()) {
                    out.println("<p>New username already exists.</p>");
                } else {
                    String updateUserSql = "UPDATE Users SET Usr = ?, Pwd = ? WHERE Usr = ?";
                    pstm = con.prepareStatement(updateUserSql);
                    pstm.setString(1, newUsername);
                    pstm.setString(2, password);
                    pstm.setString(3, username);
                    pstm.executeUpdate();

                    String updateEmployeeSql = "UPDATE Employees SET Usr = ? WHERE Usr = ?";
                    pstm = con.prepareStatement(updateEmployeeSql);
                    pstm.setString(1, newUsername);
                    pstm.setString(2, username);
                    pstm.executeUpdate();

                    String updateQuestionBoxSql = "UPDATE QuestionBox SET ReplyUsr = ? WHERE ReplyUsr = ?";
                    pstm = con.prepareStatement(updateQuestionBoxSql);
                    pstm.setString(1, newUsername);
                    pstm.setString(2, username);
                    pstm.executeUpdate();

                    out.println("<p>Customer Representative edited successfully.</p>");
                }
            }
        } else if ("delete".equalsIgnoreCase(mode)) {
            
            String findUserSql = "SELECT * FROM Users WHERE Usr = ?";
            pstm = con.prepareStatement(findUserSql);
            pstm.setString(1, username);
            rs = pstm.executeQuery();

            if (!rs.next()) {
                out.println("<p>Username not found.</p>");
            } else {

                String deleteEmployeeSql = "DELETE FROM Employees WHERE Usr = ?";
                pstm = con.prepareStatement(deleteEmployeeSql);
                pstm.setString(1, username);
                pstm.executeUpdate();
                
                String deleteUserSql = "DELETE FROM Users WHERE Usr = ?";
                pstm = con.prepareStatement(deleteUserSql);
                pstm.setString(1, username);
                pstm.executeUpdate();

                String updateQuestionBoxSql = "UPDATE QuestionBox SET ReplyUsr = 'An already deleted account' WHERE ReplyUsr = ?";
                pstm = con.prepareStatement(updateQuestionBoxSql);
                pstm.setString(1, username);
                pstm.executeUpdate();

                out.println("<p>Customer Representative deleted successfully.</p>");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>An error occurred: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstm != null) pstm.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
