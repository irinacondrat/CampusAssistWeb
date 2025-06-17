<%@ page import="java.sql.*, jakarta.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    public String getColorForStatus(String status) {
        if ("Approved".equalsIgnoreCase(status)) return "green";
        if ("Rescheduled".equalsIgnoreCase(status)) return "orange";
        if ("Cancelled".equalsIgnoreCase(status)) return "red";
        return "black"; // Pending or null
    }
%>
<%
    if (session == null || session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String selectedFilter = request.getParameter("statusFilter");
    if (selectedFilter == null) selectedFilter = "All";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>
<html>
<head>
    <title>Manage Appointments</title>
</head>
<body>
<h2>Admin - Manage Appointments</h2>

<!-- 🔍 Filter Form -->
<form method="get" action="adminAppointments.jsp">
    <label for="statusFilter">Filter by Status:</label>
    <select name="statusFilter" onchange="this.form.submit()">
        <option value="All" <%= "All".equals(selectedFilter) ? "selected" : "" %>>All</option>
        <option value="Pending" <%= "Pending".equals(selectedFilter) ? "selected" : "" %>>Pending</option>
        <option value="Approved" <%= "Approved".equals(selectedFilter) ? "selected" : "" %>>Approved</option>
        <option value="Rescheduled" <%= "Rescheduled".equals(selectedFilter) ? "selected" : "" %>>Rescheduled</option>
        <option value="Cancelled" <%= "Cancelled".equals(selectedFilter) ? "selected" : "" %>>Cancelled</option>
    </select>
</form>

<br>

<table border="1">
    <tr>
        <th>Appointment ID</th>
        <th>Student ID</th>
        <th>Type</th>
        <th>Date</th>
        <th>Time</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
<%
    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");

        String sql;
        if ("All".equalsIgnoreCase(selectedFilter)) {
            sql = "SELECT * FROM appointments";
            stmt = conn.prepareStatement(sql);
        } else {
            sql = "SELECT * FROM appointments WHERE status = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, selectedFilter);
        }

        rs = stmt.executeQuery();

        while (rs.next()) {
            String status = rs.getString("status");
            if (status == null) status = "Pending";
%>
    <form action="AppointmentActionServlet" method="post">
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("studentId") %></td>
            <td><%= rs.getString("type") %></td>
            <td><input type="date" name="date" value="<%= rs.getString("date") %>" required></td>
            <td><input type="time" name="time" value="<%= rs.getString("time") %>" required></td>
            <td style="color:<%= getColorForStatus(status) %>;">
                <%= status %>
            </td>
            <td>
                <input type="hidden" name="appointmentId" value="<%= rs.getInt("id") %>">
                <input type="submit" name="action" value="Approve">
                <input type="submit" name="action" value="Reschedule">
                <input type="submit" name="action" value="Cancel">
            </td>
        </tr>
    </form>
<%
        }

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
</table>

<br>
<a href="adminDashboard.jsp">&larr; Back to Dashboard</a>
</body>
</html>
