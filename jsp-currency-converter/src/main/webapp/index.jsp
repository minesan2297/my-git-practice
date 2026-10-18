<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chuyển đổi tiền tệ - JSP</title>
        <style>
            body { font-family: 'Arial', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; background-color: #f8fafc; }
            .converter-container { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); text-align: center; width: 350px; }
            input { padding: 12px; margin: 10px 0; width: 100%; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-size: 15px; }
            button { background-color: #1b2a7a; color: white; padding: 12px 20px; border: none; border-radius: 4px; cursor: pointer; width: 100%; font-weight: bold; font-size: 16px; margin-top: 15px; transition: background-color 0.2s; }
            button:hover { background-color: #121c54; }
        </style>
    </head>
    <body>
        <div class="converter-container">
            <h2 style="color: #1b2a7a; margin-bottom: 25px;">USD to VND Converter</h2>
            <!-- Form gửi dữ liệu bằng phương thức POST tới trang converter.jsp -->
            <form action="converter.jsp" method="POST">
                <div style="text-align: left;">
                    <label style="font-weight: bold; color: #333; font-size: 14px;">Tỉ giá (VND/USD):</label>
                </div>
                <input type="number" name="rate" placeholder="Ví dụ: 25000" value="25000" required step="any"/>
                
                <div style="text-align: left; margin-top: 10px;">
                    <label style="font-weight: bold; color: #333; font-size: 14px;">Lượng USD cần đổi:</label>
                </div>
                <input type="number" name="usd" placeholder="Nhập số lượng USD" required step="any" autofocus/>
                
                <button type="submit">Tính toán</button>
            </form>
        </div>
    </body>
</html>
