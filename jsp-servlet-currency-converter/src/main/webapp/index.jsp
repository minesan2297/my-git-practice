<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Currency Converter - Chuyển Đổi Tiền Tệ</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f8fafc;
        }
        .converter-container {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
            width: 350px;
        }
        h2 {
            color: #1b2a7a;
            margin-bottom: 25px;
        }
        .form-group {
            text-align: left;
            margin-bottom: 15px;
        }
        label {
            font-weight: bold;
            color: #334155;
            font-size: 14px;
            display: block;
            margin-bottom: 6px;
        }
        input {
            padding: 12px;
            width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 15px;
        }
        button {
            background-color: #1b2a7a;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-weight: bold;
            font-size: 16px;
            margin-top: 15px;
            transition: background-color 0.2s;
        }
        button:hover {
            background-color: #121c54;
        }
    </style>
</head>
<body>

    <div class="converter-container">
        <h2>Chuyển đổi USD sang VNĐ</h2>
        <!-- Form gửi dữ liệu bằng phương thức POST tới đường dẫn /convert -->
        <form action="convert" method="POST">
            <div class="form-group">
                <label>Tỉ giá (VND/USD):</label>
                <input type="number" name="rate" placeholder="Ví dụ: 25000" value="25000" required step="any"/>
            </div>

            <div class="form-group">
                <label>Lượng USD cần đổi:</label>
                <input type="number" name="usd" placeholder="Nhập số USD" required step="any" autofocus/>
            </div>

            <button type="submit">Chuyển đổi</button>
        </form>
    </div>

</body>
</html>
