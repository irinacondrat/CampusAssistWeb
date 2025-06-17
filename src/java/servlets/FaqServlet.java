package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class FaqServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");

        try {
            Class.forName("org.sqlite.JDBC");
            Connection conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");

            if ("add".equals(action)) {
                String question = request.getParameter("question");
                String answer = request.getParameter("answer");

                PreparedStatement ps = conn.prepareStatement("INSERT INTO faq (question, answer) VALUES (?, ?)");
                ps.setString(1, question);
                ps.setString(2, answer);
                ps.executeUpdate();

            } else if ("update".equals(action)) {
                String question = request.getParameter("question");
                String answer = request.getParameter("answer");

                PreparedStatement ps = conn.prepareStatement("UPDATE faq SET question = ?, answer = ? WHERE id = ?");
                ps.setString(1, question);
                ps.setString(2, answer);
                ps.setInt(3, Integer.parseInt(id));
                ps.executeUpdate();

            } else if ("delete".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM faq WHERE id = ?");
                ps.setInt(1, Integer.parseInt(id));
                ps.executeUpdate();
            }

            conn.close();
            response.sendRedirect("adminFaq.jsp");

        } catch (Exception e) {
            throw new ServletException("FAQ management error", e);
        }
    }
}
