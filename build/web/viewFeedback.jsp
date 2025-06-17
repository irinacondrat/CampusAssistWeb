<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String studentId = (session != null) ? (String) session.getAttribute("studentId") : null;

    if (studentId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>
<html>
<head>
    <title>View Feedback</title>
    <style>
        body {
            font-family: "Segoe UI", Tahoma, sans-serif;
            background-color: #f0f6fb;
            text-align: center;
            padding: 40px;
        }

        h2 {
            color: #003366;
        }

        table {
            margin: 0 auto;
            border-collapse: collapse;
            width: 80%;
            background-color: #fff;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ccc;
        }

        th {
            background-color: #e6f0ff;
            color: #003366;
        }

        input[type=submit] {
            padding: 10px 20px;
            margin-top: 30px;
            font-size: 15px;
            border: none;
            border-radius: 6px;
            background-color: #007acc;
            color: white;
            cursor: pointer;
        }

        input[type=submit]:hover {
            background-color: #005f99;
        }
    </style>
</head>
<body>
    <h2>Feedback for Your Appointments</h2>

    <%
        try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");
            String sql = "SELECT a.type, a.date, a.time, f.feedbackText FROM feedback f JOIN appointments a ON f.appointmentID = a.id WHERE f.studentID=?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, studentId);
            rs = stmt.executeQuery();

            boolean hasFeedback = false;
    %>
    <table>
        <tr>
            <th>Support Type</th>
            <th>Date</th>
            <th>Time</th>
            <th>Feedback</th>
        </tr>
        <%
            while (rs.next()) {
                hasFeedback = true;
        %>
            <tr>
                <td><%= rs.getString("type") %></td>
                <td><%= rs.getString("date") %></td>
                <td><%= rs.getString("time") %></td>
                <td><%= rs.getString("feedbackText") %></td>
            </tr>
        <%
            }

            if (!hasFeedback) {
        %>
            <tr>
                <td colspan="4">You have not submitted any feedback yet.</td>
            </tr>
        <%
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error loading feedback: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
        %>
    </table>

    <form action="studentDashboard.jsp">
        <input type="submit" value="Back to Dashboard">
    </form>
</body>
</html>
