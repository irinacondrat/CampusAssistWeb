package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class SubmitFeedbackServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String studentId = (session != null) ? (String) session.getAttribute("studentId") : null;

        String appointmentId = request.getParameter("appointmentId");
        String feedbackText = request.getParameter("feedbackText");

        if (studentId == null || appointmentId == null || feedbackText == null) {
            response.getWriter().println("Missing required information.");
            return;
        }

        try {
            Class.forName("org.sqlite.JDBC");
            Connection conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");

            String sql = "INSERT INTO feedback (appointmentID, studentID, feedbackText) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(appointmentId));
            stmt.setString(2, studentId);
            stmt.setString(3, feedbackText);
            stmt.executeUpdate();

            conn.close();
            response.sendRedirect("studentDashboard.jsp?feedbackStatus=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error submitting feedback: " + e.getMessage());
        }
    }
}
