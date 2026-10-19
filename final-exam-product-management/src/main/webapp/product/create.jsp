<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Sản Phẩm Mới - Final Exam</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: "Segoe UI", Arial, sans-serif; margin: 0; background-color: #f1f5f9; color: #1e293b; }
        .header { background: #1e3a8a; color: white; padding: 20px 40px; }
        .header h1 { margin: 0; font-size: 20px; font-weight: 700; }
        .container { max-width: 600px; margin: 40px auto; background: white; padding: 30px 40px; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
        h2 { margin-top: 0; color: #1e3a8a; border-bottom: 2px solid #e2e8f0; padding-bottom: 12px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #475569; font-size: 14px; }
        input[type="text"], input[type="number"] { width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; }
        input:focus { outline: none; border-color: #1e3a8a; box-shadow: 0 0 0 3px rgba(30,58,138,0.1); }
        .btn-group { display: flex; gap: 12px; margin-top: 25px; }
        .btn-save { background-color: #10b981; color: white; border: none; padding: 10px 24px; border-radius: 6px; font-weight: 600; cursor: pointer; font-size: 14px; }
        .btn-save:hover { background-color: #059669; }
        .btn-cancel { background-color: #94a3b8; color: white; text-decoration: none; padding: 10px 20px; border-radius: 6px; font-weight: 600; font-size: 14px; display: inline-block; }
        .btn-cancel:hover { background-color: #64748b; }
    </style>
</head>
<body>

<div class="header">
    <h1>Hệ Thống Quản Lý Sản Phẩm</h1>
</div>

<div class="container">
    <h2>Thêm Sản Phẩm Mới</h2>
    <form action="${pageContext.request.contextPath}/products?action=create" method="post">
        <div class="form-group">
            <label for="name">Tên sản phẩm: <span style="color:red">*</span></label>
            <input type="text" id="name" name="name" required placeholder="Ví dụ: iPhone 15 Pro Max" autofocus>
        </div>

        <div class="form-group">
            <label for="price">Giá sản phẩm ($): <span style="color:red">*</span></label>
            <input type="number" step="0.01" min="0" id="price" name="price" required placeholder="Ví dụ: 1199.99">
        </div>

        <div class="form-group">
            <label for="quantity">Số lượng tồn kho: <span style="color:red">*</span></label>
            <input type="number" min="0" id="quantity" name="quantity" required placeholder="Ví dụ: 50">
        </div>

        <div class="btn-group">
            <button type="submit" class="btn-save">Lưu Sản Phẩm</button>
            <a href="${pageContext.request.contextPath}/products" class="btn-cancel">Hủy bỏ</a>
        </div>
    </form>
</div>

</body>
</html>
