package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class BookAppointmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String studentId = (session != null) ? (String) session.getAttribute("studentId") : null;

        String type = request.getParameter("type");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String details = request.getParameter("details");

        if (studentId == null || studentId.trim().isEmpty()) {
            response.getWriter().println("Booking failed: No student ID found in session.");
            return;
        }

        try {
            Class.forName("org.sqlite.JDBC");
            Connection conn = DriverManager.getConnection("jdbc:sqlite:C:\\Users\\piricond\\Desktop\\Uni\\OODD projects\\OODD group\\CampusAssist\\campusassist.db");
            PreparedStatement ps = conn.prepareStatement("INSERT INTO appointments(studentID, type, date, time, details) VALUES (?, ?, ?, ?, ?)");

            ps.setString(1, studentId);
            ps.setString(2, type);
            ps.setString(3, date);
            ps.setString(4, time);
            ps.setString(5, details);

            ps.executeUpdate();
            conn.close();

            response.sendRedirect("studentDashboard.jsp?status=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Booking failed: " + e.getMessage());
        }
    }
}
