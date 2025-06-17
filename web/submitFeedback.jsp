<%@ page import="java.sql.*" %>
<%
    if (session == null || session.getAttribute("studentId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String studentId = (String) session.getAttribute("studentId");
%>
<html>
<head><title>Submit Feedback</title></head>
<body>
    <h2>Submit Feedback for Appointments</h2>
    <ul>
    <%
        try {
            Class.forName("org.sqlite.JDBC");
            Connection conn = DriverManager.getConnection("jdbc:sqlite:C:/CampusAssist/campusassist.db");

            String sql = "SELECT * FROM appointments WHERE studentId = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, studentId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int appointmentId = rs.getInt("id");
                String date = rs.getString("date");
                String details = rs.getString("details");
                String feedback = rs.getString("feedback");
    %>
        <li>
            <strong><%= date %></strong> - <%= details %>
            <form action="SubmitFeedbackServlet" method="post">
                <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
                <textarea name="feedback" rows="3" cols="40" required><%= feedback == null ? "" : feedback %></textarea><br>
                <input type="submit" value="Submit Feedback">
            </form>
        </li>
        <br>
    <%
            }

            conn.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
    </ul>

    <br><a href="studentDashboard.jsp">Back to Dashboard</a>
</body>
</html>
