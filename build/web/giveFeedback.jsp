<%@ page import="java.sql.*, jakarta.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String studentId = (session != null) ? (String) session.getAttribute("studentId") : null;

    if (studentId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Connect to DB and get student's appointments
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>
<html>
<head><title>Give Feedback</title></head>
<body>
<h2>Give Feedback for Your Appointments</h2>

<form method="post" action="SubmitFeedbackServlet">
    <label for="appointmentId">Select Appointment:</label>
    <select name="appointmentId" required>
        <%
            try {
                Class.forName("org.sqlite.JDBC");
                conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");
                String sql = "SELECT id, type, date, time FROM appointments WHERE studentID=?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, studentId);
                rs = stmt.executeQuery();

                while (rs.next()) {
        %>
                    <option value="<%= rs.getInt("id") %>">
                        <%= rs.getString("type") %> on <%= rs.getString("date") %> at <%= rs.getString("time") %>
                    </option>
        <%
                }
            } catch (Exception e) {
                out.println("Error loading appointments: " + e.getMessage());
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
                if (conn != null) try { conn.close(); } catch (Exception ignored) {}
            }
        %>
    </select>
    <br><br>

    <label for="feedback">Feedback:</label><br>
  <textarea name="feedbackText" rows="5" cols="40"></textarea><br><br>

    <input type="submit" value="Submit Feedback">
</form>

<br>
<a href="studentDashboard.jsp">Back to Dashboard</a>
</body>
</html>
