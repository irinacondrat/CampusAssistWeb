package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class AppointmentActionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        String action = request.getParameter("action");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        String newStatus = "";
        if ("Approve".equals(action)) newStatus = "Approved";
        else if ("Reschedule".equals(action)) newStatus = "Rescheduled";
        else if ("Cancel".equals(action)) newStatus = "Cancelled";

        try {
            Class.forName("org.sqlite.JDBC");
            Connection conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");

            String sql = "UPDATE appointments SET date = ?, time = ?, status = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, date);
            stmt.setString(2, time);
            stmt.setString(3, newStatus);
            stmt.setInt(4, appointmentId);

            stmt.executeUpdate();
            stmt.close();
            conn.close();

            response.sendRedirect("adminAppointments.jsp?statusFilter=" + newStatus);  // Optional
        } catch (Exception e) {
            throw new ServletException("Database update failed", e);
        }
    }
}
