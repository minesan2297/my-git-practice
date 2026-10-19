<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác Nhận Xoá Sản Phẩm - Final Exam</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: "Segoe UI", Arial, sans-serif; margin: 0; background-color: #f1f5f9; color: #1e293b; }
        .header { background: #b91c1c; color: white; padding: 20px 40px; }
        .header h1 { margin: 0; font-size: 20px; font-weight: 700; }
        .container { max-width: 550px; margin: 40px auto; background: white; padding: 30px 40px; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
        h2 { margin-top: 0; color: #b91c1c; border-bottom: 2px solid #fee2e2; padding-bottom: 12px; }
        .warning-text { color: #dc2626; font-size: 15px; margin-bottom: 20px; }
        .product-card { background: #f8fafc; border-left: 4px solid #b91c1c; padding: 16px 20px; border-radius: 4px; margin-bottom: 25px; }
        .product-card p { margin: 8px 0; font-size: 14px; }
        .label { font-weight: 600; color: #475569; display: inline-block; width: 120px; }
        .btn-group { display: flex; gap: 12px; margin-top: 25px; }
        .btn-delete { background-color: #dc2626; color: white; border: none; padding: 10px 24px; border-radius: 6px; font-weight: 600; cursor: pointer; font-size: 14px; }
        .btn-delete:hover { background-color: #b91c1c; }
        .btn-cancel { background-color: #94a3b8; color: white; text-decoration: none; padding: 10px 20px; border-radius: 6px; font-weight: 600; font-size: 14px; display: inline-block; }
        .btn-cancel:hover { background-color: #64748b; }
    </style>
</head>
<body>

<div class="header">
    <h1>Hệ Thống Quản Lý Sản Phẩm</h1>
</div>

<div class="container">
    <h2>Xác Nhận Xoá Sản Phẩm</h2>
    <p class="warning-text">Bạn có chắc chắn muốn xoá sản phẩm này khỏi cơ sở dữ liệu không?</p>

    <div class="product-card">
        <p><span class="label">Mã sản phẩm:</span> #${requestScope.product.id}</p>
        <p><span class="label">Tên sản phẩm:</span> <strong><c:out value="${requestScope.product.name}" /></strong></p>
        <p><span class="label">Giá bán:</span> $<c:out value="${requestScope.product.price}" /></p>
        <p><span class="label">Số lượng tồn:</span> <c:out value="${requestScope.product.quantity}" /> sản phẩm</p>
    </div>

    <form action="${pageContext.request.contextPath}/products?action=delete" method="post">
        <input type="hidden" name="id" value="${requestScope.product.id}">
        <div class="btn-group">
            <button type="submit" class="btn-delete">Xác Nhận Xoá</button>
            <a href="${pageContext.request.contextPath}/products" class="btn-cancel">Hủy bỏ</a>
        </div>
    </form>
</div>

</body>
</html>
