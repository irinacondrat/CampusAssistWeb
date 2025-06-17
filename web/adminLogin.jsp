<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login - CampusAssist</title>
    <style>
        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f6ff;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 60px;
        }

        h2 {
            color: #004080;
            margin-bottom: 30px;
            font-size: 2em;
        }

        form {
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 320px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        input[type="submit"] {
            width: 100%;
            padding: 12px;
            background-color: #0066cc;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #004c99;
        }

        .back-link {
            margin-top: 20px;
        }

        .back-link a {
            text-decoration: none;
            color: #004080;
            font-weight: bold;
        }

        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <h2>Admin Login</h2>

    <form action="LoginServlet" method="post">
        <label for="id">Admin ID:</label>
        <input type="text" name="id" id="id" required>

        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required>

        <!-- Hidden role detection -->
        <input type="hidden" name="loginType" value="admin">

        <input type="submit" value="Login">
    </form>

    <div class="back-link">
        <a href="index.html">&larr; Back to Home</a>
    </div>

</body>
</html>
