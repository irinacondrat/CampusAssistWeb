<%@ page import="java.sql.*" %>
<%
    // Security check (optional, depends if admin login exists)
    // Assume admin session exists for now
%>
<html>
<head>
    <title>Admin Review Feedback</title>
</head>
<body>
    <h2>Student Feedback Review</h2>

    <ul>
    <%
        try {
            Class.forName("org.sqlite.JDBC");
            Connection conn = DriverManager.getConnection("jdbc:sqlite:C:/CampusAssist/campusassist.db");

            String sql = "SELECT id, studentId, type, date, details, feedback, adminResponse FROM appointments WHERE feedback IS NOT NULL";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int appointmentId = rs.getInt("id");
                String studentId = rs.getString("studentId");
                String type = rs.getString("type");
                String date = rs.getString("date");
                String details = rs.getString("details");
                String feedback = rs.getString("feedback");
                String adminResponse = rs.getString("adminResponse");
    %>
        <li>
            <strong>Student ID:</strong> <%= studentId %><br>
            <strong>Type:</strong> <%= type %><br>
            <strong>Date:</strong> <%= date %><br>
            <strong>Details:</strong> <%= details %><br>
            <strong>Feedback:</strong> <%= feedback %><br>

            <form action="AdminResponseServlet" method="post">
                <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
                <textarea name="adminResponse" rows="3" cols="50" required><%= adminResponse == null ? "" : adminResponse %></textarea><br>
                <input type="submit" value="Submit Response">
            </form>
        </li><br>
    <%
            }

            conn.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
    </ul>
</body>
</html>
