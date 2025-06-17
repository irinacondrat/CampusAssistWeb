<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Feedback Category Report</title>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<%
    int suggestionCount = 0;
    int complaintCount = 0;
    int praiseCount = 0;

    try {
        Class.forName("org.sqlite.JDBC");
        Connection conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/piricond/Desktop/Uni/OODD projects/OODD group/CampusAssist/campusassist.db");
        PreparedStatement stmt = conn.prepareStatement("SELECT category, COUNT(*) as total FROM feedback GROUP BY category");
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            String category = rs.getString("category");
            int total = rs.getInt("total");

            if ("Suggestion".equalsIgnoreCase(category)) suggestionCount = total;
            else if ("Complaint".equalsIgnoreCase(category)) complaintCount = total;
            else if ("Praise".equalsIgnoreCase(category)) praiseCount = total;
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<script type="text/javascript">
    google.charts.load("current", {packages:["corechart"]});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
        var data = google.visualization.arrayToDataTable([
            ["Category", "Count"],
            ["Suggestion", <%= suggestionCount %>],
            ["Complaint", <%= complaintCount %>],
            ["Praise", <%= praiseCount %>]
        ]);

        var options = {
            title: "Feedback Categories",
            legend: { position: "none" },
            colors: ['#3366cc'],
            hAxis: {
                title: 'Category'
            },
            vAxis: {
                title: 'Number of Feedback'
            }
        };

        var chart = new google.visualization.ColumnChart(document.getElementById("chart_div"));
        chart.draw(data, options);
    }
</script>
</head>

<body>
    <h2>Feedback Category Statistics</h2>
    <div id="chart_div" style="width: 700px; height: 400px;"></div>
    <br>
    <a href="adminDashboard.jsp">&larr; Back to Dashboard</a>
</body>
</html>
