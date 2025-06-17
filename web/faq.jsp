<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Frequently Asked Questions</title>
</head>
<body>
    <h2>Frequently Asked Questions</h2>
    <ul>
    <%
        try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");
            stmt = conn.prepareStatement("SELECT * FROM faq");
            rs = stmt.executeQuery();

            while (rs.next()) {
    %>
                <li>
                    <strong><%= rs.getString("question") %></strong><br>
                    <%= rs.getString("answer") %>
                </li><br>
    <%
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error loading FAQs: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    %>
    </ul>

    <br>
    <a href="studentDashboard.jsp">← Back to Dashboard</a>
</body>
</html>
