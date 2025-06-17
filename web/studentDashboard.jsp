<%@ page import="java.sql.*, jakarta.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String studentId = (String) session.getAttribute("studentId");
    String role = (String) session.getAttribute("role");

    if (studentId == null || !"student".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard - CampusAssist</title>
    <style>
        body {
            font-family: "Segoe UI", Tahoma, sans-serif;
            background-color: #f0f6fb;
            padding: 40px;
            text-align: center;
        }

        h2 {
            color: #003366;
        }

        h3 {
            color: #004d99;
            margin-top: 30px;
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

        button, input[type=submit] {
            padding: 10px 20px;
            margin: 10px 8px;
            font-size: 15px;
            border: none;
            border-radius: 6px;
            background-color: #007acc;
            color: white;
            cursor: pointer;
        }

        button:hover, input[type=submit]:hover {
            background-color: #005f99;
        }

        .back-link {
            margin-top: 40px;
        }

        .back-link a {
            text-decoration: none;
            color: #004080;
            font-weight: bold;
        }

        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<h2>Welcome, Student <%= studentId %>!</h2>
<h3>Your Appointments:</h3>

<table>
    <tr>
        <th>Type</th>
        <th>Date</th>
        <th>Time</th>
        <th>Details</th>
    </tr>
<%
    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");
        stmt = conn.prepareStatement("SELECT * FROM appointments WHERE studentId = ?");
        stmt.setString(1, studentId);
        rs = stmt.executeQuery();

        while (rs.next()) {
%>
    <tr>
        <td><%= rs.getString("type") %></td>
        <td><%= rs.getString("date") %></td>
        <td><%= rs.getString("time") %></td>
        <td><%= rs.getString("details") %></td>
    </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='4' style='color:red;'>Error loading appointments: " + e.getMessage() + "</td></tr>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
</table>

<form action="bookAppointment.jsp">
    <input type="submit" value="Book a New Appointment">
</form>

<form action="giveFeedback.jsp">
    <input type="submit" value="Give Feedback">
</form>

<form action="viewFeedback.jsp">
    <input type="submit" value="View Feedback">
</form>

<form action="supportServices.jsp">
    <input type="submit" value="Browse Support Services">
</form>

<form action="faq.jsp">
    <input type="submit" value="View FAQs">
</form>

<form action="logout.jsp">
    <input type="submit" value="Logout">
</form>

<div class="back-link">
    <a href="index.html">&larr; Back to Home</a>
</div>

</body>
</html>
