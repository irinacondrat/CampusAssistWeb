<%@ page import="java.sql.*, jakarta.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String studentId = (String) session.getAttribute("studentId");
    String role = (String) session.getAttribute("role");

    if (studentId == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }

        h2 {
            color: #333;
        }

        .menu-container {
            margin-top: 40px;
            padding: 20px;
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            max-width: 700px;
            margin: 0 auto;
        }

        .menu-grid form {
            margin: 0;
        }

        .menu-button {
            padding: 12px 20px;
            font-size: 15px;
            background-color: #0066cc;
            color: white;
            border: none;
            border-radius: 8px;
            box-shadow: 0 3px 6px rgba(0,0,0,0.1);
            transition: background-color 0.3s ease;
            cursor: pointer;
            width: 100%;
        }

        .menu-button:hover {
            background-color: #004c99;
        }

        .back-home {
            margin: 30px auto;
            text-align: center;
        }

        .back-home a {
            font-size: 15px;
            color: #663399;
            text-decoration: none;
        }

        .back-home a:hover {
            text-decoration: underline;
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            padding: 8px;
            border: 1px solid #aaa;
        }
    </style>
</head>
<body>
    <h2>Welcome, Admin <%= studentId %>!</h2>
    <h3>Student Feedback Management</h3>

    <%
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");

            String sql = "SELECT feedback.id, students.id AS studentId, appointments.type, appointments.date, appointments.time, feedback.feedbackText, feedback.response, feedback.category " +
                         "FROM feedback " +
                         "JOIN appointments ON feedback.appointmentID = appointments.id " +
                         "JOIN students ON feedback.studentID = students.id";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            boolean hasFeedback = false;
    %>

    <table>
        <tr>
            <th>Student ID</th>
            <th>Support Type</th>
            <th>Date</th>
            <th>Time</th>
            <th>Feedback</th>
            <th>Response</th>
            <th>Category</th>
            <th>Admin Action</th>
        </tr>

    <%
        while (rs.next()) {
            hasFeedback = true;
    %>
        <form method="post" action="AdminResponseServlet">
        <tr>
            <td><%= rs.getString("studentId") %></td>
            <td><%= rs.getString("type") %></td>
            <td><%= rs.getString("date") %></td>
            <td><%= rs.getString("time") %></td>
            <td><%= rs.getString("feedbackText") %></td>
            <td><%= rs.getString("response") != null ? rs.getString("response") : "" %></td>
            <td><%= rs.getString("category") != null ? rs.getString("category") : "" %></td>
            <td>
                <input type="hidden" name="feedbackId" value="<%= rs.getInt("id") %>">
                <input type="text" name="response" placeholder="Write response" required><br>
                <select name="category" required>
                    <option value="">--Category--</option>
                    <option value="Positive">Positive</option>
                    <option value="Neutral">Neutral</option>
                    <option value="Negative">Negative</option>
                </select><br>
                <input type="submit" value="Submit">
            </td>
        </tr>
        </form>
    <%
        }

        if (!hasFeedback) {
    %>
        <tr><td colspan="8">No feedback entries yet.</td></tr>
    <%
        }

        } catch (Exception e) {
    %>
        <p style="color:red;">Error loading feedback: <%= e.getMessage() %></p>
    <%
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    %>
    </table>

    <div class="menu-container">
        <div class="menu-grid">
            <form action="adminFaq.jsp"><input type="submit" class="menu-button" value="Manage FAQs"></form>
            <form action="adminAnalytics.jsp"><input type="submit" class="menu-button" value="View Analytics"></form>
            <form action="adminAppointments.jsp"><input type="submit" class="menu-button" value="Manage Appointments"></form>
            <form action="adminViewFeedback.jsp"><input type="submit" class="menu-button" value="Manage Feedback"></form>
            <form action="feedbackChart.jsp"><input type="submit" class="menu-button" value="View Feedback Chart"></form>
            <form action="logout.jsp"><input type="submit" class="menu-button" value="Logout"></form>
        </div>
    </div>

    <div class="back-home">
        <a href="index.html">&larr; Back to Home</a>
    </div>
</body>
</html>
