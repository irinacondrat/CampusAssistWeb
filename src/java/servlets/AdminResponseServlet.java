package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class AdminResponseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String feedbackId = request.getParameter("feedbackId");
        String category = request.getParameter("category");
        String feedbackResponse = request.getParameter("response");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");

            String sql = "UPDATE feedback SET category = ?, response = ? WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, category);
            stmt.setString(2, feedbackResponse);
            stmt.setInt(3, Integer.parseInt(feedbackId));
            stmt.executeUpdate();

            response.sendRedirect("adminViewFeedback.jsp?status=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error saving response: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
