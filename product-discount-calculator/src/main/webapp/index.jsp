<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Product Discount Calculator</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background-color: #f8fafc;
        }
        .calculator-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: left;
            width: 380px;
        }
        h2 {
            color: #1b2a7a;
            text-align: center;
            margin-bottom: 25px;
        }
        .form-group {
            margin-bottom: 18px;
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
            padding: 14px 20px;
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

    <div class="calculator-container">
        <h2>Product Discount Calculator</h2>
        
        <!-- Form gửi dữ liệu bằng phương thức POST tới endpoint /display-discount -->
        <form action="display-discount" method="POST">
            <div class="form-group">
                <label>Product Description:</label>
                <input type="text" name="description" placeholder="Ví dụ: Laptop Dell XPS 15" required autofocus />
            </div>

            <div class="form-group">
                <label>List Price ($):</label>
                <input type="number" name="price" placeholder="Nhập giá niêm yết" step="any" min="0" required />
            </div>

            <div class="form-group">
                <label>Discount Percent (%):</label>
                <input type="number" name="discount" placeholder="Ví dụ: 10" step="any" min="0" max="100" required />
            </div>

            <button type="submit">Calculate Discount</button>
        </form>
    </div>

</body>
</html>
