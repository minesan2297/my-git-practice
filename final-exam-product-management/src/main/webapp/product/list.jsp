<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hệ Thống Quản Lý Sản Phẩm - Final Exam</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: "Segoe UI", Arial, sans-serif; margin: 0; background-color: #f1f5f9; color: #1e293b; }
        .header { background: linear-gradient(135deg, #1e3a8a, #0f172a); color: white; padding: 25px 40px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        .header h1 { margin: 0; font-size: 24px; font-weight: 700; }
        .header p { margin: 6px 0 0; opacity: 0.85; font-size: 14px; }
        .container { max-width: 1050px; margin: 30px auto; padding: 0 20px; }
        .action-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 22px; flex-wrap: wrap; gap: 12px; }
        .btn-add { background-color: #10b981; color: white; padding: 10px 20px; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 14px; box-shadow: 0 2px 4px rgba(16,185,129,0.2); }
        .btn-add:hover { background-color: #059669; }
        .search-box { display: flex; gap: 8px; }
        .search-input { width: 300px; padding: 9px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; }
        .btn-search { background-color: #1e3a8a; color: white; border: none; padding: 9px 18px; border-radius: 6px; font-weight: 600; cursor: pointer; }
        .btn-search:hover { background-color: #1e40af; }
        .btn-clear { align-self: center; color: #64748b; text-decoration: none; font-size: 13px; margin-left: 4px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
        th, td { padding: 14px 18px; text-align: left; border-bottom: 1px solid #f1f5f9; }
        th { background-color: #f8fafc; color: #475569; font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; }
        tr:hover { background-color: #f8fafc; }
        .price-tag { color: #059669; font-weight: 700; }
        .qty-badge { background-color: #e2e8f0; color: #334155; padding: 4px 10px; border-radius: 12px; font-weight: 600; font-size: 13px; }
        .action-link { text-decoration: none; font-size: 13px; font-weight: 600; margin-right: 10px; }
        .link-edit { color: #f59e0b; }
        .link-edit:hover { color: #d97706; text-decoration: underline; }
        .link-delete { color: #ef4444; }
        .link-delete:hover { color: #dc2626; text-decoration: underline; }
        .empty-row { text-align: center; color: #94a3b8; padding: 35px 20px; font-style: italic; }
    </style>
</head>
<body>

<div class="header">
    <h1>Hệ Thống Quản Lý Sản Phẩm (Product Management)</h1>
    <p>Bài kiểm tra cuối module: Phát triển ứng dụng Web với Java Servlet & JSP</p>
</div>

<div class="container">
    <div class="action-bar">
        <a href="${pageContext.request.contextPath}/products?action=create" class="btn-add">+ Thêm Sản Phẩm Mới</a>
        <form action="${pageContext.request.contextPath}/products" method="get" class="search-box">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="search-input" placeholder="Tìm kiếm theo tên sản phẩm..." value="<c:out value='${requestScope.keyword}' />">
            <button type="submit" class="btn-search">Tìm kiếm</button>
            <c:if test="${requestScope.keyword != null && !requestScope.keyword.isEmpty()}">
                <a href="${pageContext.request.contextPath}/products" class="btn-clear">Xóa lọc</a>
            </c:if>
        </form>
    </div>

    <c:if test="${requestScope.keyword != null && !requestScope.keyword.isEmpty()}">
        <p style="margin-bottom: 15px; color: #64748b; font-size: 14px;">
            Kết quả tìm kiếm cho: <strong>"<c:out value="${requestScope.keyword}" />"</strong>
        </p>
    </c:if>

    <table>
        <thead>
        <tr>
            <th style="width: 70px;">ID</th>
            <th>Tên Sản Phẩm</th>
            <th style="width: 150px;">Giá ($)</th>
            <th style="width: 130px;">Số Lượng</th>
            <th style="width: 160px;">Thao Tác</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty requestScope.products}">
                <c:forEach var="p" items="${requestScope.products}">
                    <tr>
                        <td><strong>#<c:out value="${p.id}" /></strong></td>
                        <td><strong><c:out value="${p.name}" /></strong></td>
                        <td><span class="price-tag">$<c:out value="${p.price}" /></span></td>
                        <td><span class="qty-badge"><c:out value="${p.quantity}" /> sản phẩm</span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/products?action=edit&id=${p.id}" class="action-link link-edit">Sửa</a>
                            <a href="${pageContext.request.contextPath}/products?action=delete&id=${p.id}" class="action-link link-delete">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="5" class="empty-row">Không có sản phẩm nào trong cơ sở dữ liệu.</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>

</body>
</html>
