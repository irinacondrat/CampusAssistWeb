<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session == null || session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String query = request.getParameter("query");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<html>
<head>
    <title>Admin - View and Respond to Feedback</title>
</head>
<body>
    <h2>All Student Feedback</h2>

    <!-- ✅ Search Form -->
    <form method="get" action="adminViewFeedback.jsp">
        Search: 
        <input type="text" name="query" placeholder="Student ID, comment, category" value="<%= query != null ? query : "" %>">
        <input type="submit" value="Search">
    </form>
    <br>

    <table border="1">
        <tr>
            <th>ID</th>
            <th>Appointment ID</th>
            <th>Student ID</th>
            <th>Comments</th>
            <th>Category</th>
            <th>Response</th>
            <th>Actions</th>
        </tr>

        <%
            try {
                Class.forName("org.sqlite.JDBC");
                conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");

                String sql = "SELECT * FROM feedback";
                if (query != null && !query.trim().isEmpty()) {
                    sql += " WHERE studentId LIKE ? OR feedbackText LIKE ? OR category LIKE ?";
                    stmt = conn.prepareStatement(sql);
                    String q = "%" + query + "%";
                    stmt.setString(1, q);
                    stmt.setString(2, q);
                    stmt.setString(3, q);
                } else {
                    stmt = conn.prepareStatement(sql);
                }

                rs = stmt.executeQuery();

                while (rs.next()) {
        %>
        <form action="AdminResponseServlet" method="post">
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getInt("appointmentId") %></td>
                <td><%= rs.getString("studentId") %></td>
                <td><%= rs.getString("feedbackText") %></td>
                <td>
                    <input type="text" name="category" value="<%= rs.getString("category") == null ? "" : rs.getString("category") %>" />
                </td>
                <td>
                    <input type="text" name="response" value="<%= rs.getString("response") == null ? "" : rs.getString("response") %>" />
                </td>
                <td>
                    <input type="hidden" name="feedbackId" value="<%= rs.getInt("id") %>"/>
                    <input type="submit" value="Save"/>
                </td>
            </tr>
        </form>
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

    <br><br>
    <a href="adminDashboard.jsp">&larr; Back to Dashboard</a>
</body>
</html>
