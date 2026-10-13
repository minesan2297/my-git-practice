<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f8fafc;
        }
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
            width: 320px;
        }
        h2 {
            color: #1b2a7a;
            margin-bottom: 24px;
        }
        input {
            padding: 12px;
            margin: 10px 0;
            width: 100%;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        button {
            background-color: #1b2a7a;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            font-weight: bold;
            margin-top: 15px;
            transition: background-color 0.2s;
        }
        button:hover {
            background-color: #131e57;
        }
    </style>
</head>
<body>

    <div class="login-container">
        <h2>System Login</h2>
        <!-- Form gửi dữ liệu bằng phương thức POST tới endpoint /login -->
        <form action="login" method="POST">
            <input type="text" name="username" placeholder="Enter username" required autofocus />
            <br/>
            <input type="password" name="password" placeholder="Enter password" required />
            <br/>
            <button type="submit">Login</button>
        </form>
    </div>

</body>
</html>
