<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Only allow access if admin
    String role = (String) session.getAttribute("role");
    if (session == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    Map<String, Integer> typeCounts = new HashMap<>();
    Map<String, Integer> categoryCounts = new HashMap<>();
%>

<html>
<head>
    <title>Admin Analytics</title>
</head>
<body>
    <h2>📊 Analytics Dashboard</h2>

    <%
        try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");

            // Count appointments by type
            String typeSql = "SELECT type, COUNT(*) as count FROM appointments GROUP BY type";
            stmt = conn.prepareStatement(typeSql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                typeCounts.put(rs.getString("type"), rs.getInt("count"));
            }
            rs.close();
            stmt.close();

            // Count feedback by category
            String catSql = "SELECT category, COUNT(*) as count FROM feedback GROUP BY category";
            stmt = conn.prepareStatement(catSql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                categoryCounts.put(rs.getString("category"), rs.getInt("count"));
            }

        } catch (Exception e) {
            out.println("<p style='color:red;'>Error loading analytics: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    %>

    <h3>🗂 Appointments by Type</h3>
    <table border="1">
        <tr><th>Support Type</th><th>Total Appointments</th></tr>
        <% for (Map.Entry<String, Integer> entry : typeCounts.entrySet()) { %>
            <tr>
                <td><%= entry.getKey() %></td>
                <td><%= entry.getValue() %></td>
            </tr>
        <% } %>
    </table>

    <br>
    <h3>💬 Feedback Categories</h3>
    <table border="1">
        <tr><th>Category</th><th>Number of Feedback Entries</th></tr>
        <% for (Map.Entry<String, Integer> entry : categoryCounts.entrySet()) { %>
            <tr>
                <td><%= entry.getKey() %></td>
                <td><%= entry.getValue() %></td>
            </tr>
        <% } %>
    </table>

    <br><br>
    <a href="adminDashboard.jsp">← Back to Dashboard</a>
</body>
</html>
