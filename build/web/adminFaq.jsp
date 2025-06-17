<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>
<html>
<head>
    <title>Admin - Manage FAQs</title>
</head>
<body>
    <h2>Manage FAQs</h2>

    <form action="FaqServlet" method="post">
        <input type="hidden" name="action" value="add">
        Question: <input type="text" name="question" required><br>
        Answer: <input type="text" name="answer" required><br>
        <input type="submit" value="Add FAQ">
    </form>

    <hr>

    <table border="1">
        <tr><th>ID</th><th>Question</th><th>Answer</th><th>Actions</th></tr>
        <%
            try {
                Class.forName("org.sqlite.JDBC");
                conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");
                stmt = conn.prepareStatement("SELECT * FROM faq");
                rs = stmt.executeQuery();

                while (rs.next()) {
        %>
            <form action="FaqServlet" method="post">
                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><input type="text" name="question" value="<%= rs.getString("question") %>"></td>
                    <td><input type="text" name="answer" value="<%= rs.getString("answer") %>"></td>
                    <td>
                        <button type="submit" name="action" value="update">Update</button>
                        <button type="submit" name="action" value="delete" onclick="return confirm('Delete this FAQ?')">Delete</button>
                    </td>
                </tr>
            </form>
        <%
                }
            } catch (Exception e) {
                out.println("Error loading FAQs: " + e.getMessage());
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
