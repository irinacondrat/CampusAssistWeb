<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String studentId = (String) session.getAttribute("studentId");
    if (studentId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Support Services</title>
</head>
<body>
    <h2>Explore Our Support Services</h2>

    <ul>
        <li>
            <strong>Mental Health Support</strong><br>
            Our counselors are here to listen and help you manage anxiety, stress, and other personal challenges.
        </li><br>

        <li>
            <strong>Academic Support</strong><br>
            Get help with time management, study strategies, and course-specific tutoring.
        </li><br>

        <li>
            <strong>Financial Support</strong><br>
            We offer guidance on managing student finances and can connect you to emergency funding options.
        </li>
    </ul>

    <br><br>
    <a href="studentDashboard.jsp">&larr; Back to Dashboard</a>
</body>
</html>
