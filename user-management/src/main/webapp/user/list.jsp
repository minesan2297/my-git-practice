<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý User</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; background-color: #f8fafc; }
        h2 { color: #1b2a7a; text-align: center; }
        .toolbar { width: 80%; margin: 20px auto; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; }
        table { width: 80%; margin: 20px auto; border-collapse: collapse; background: white; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #1b2a7a; color: white; }
        tr:hover { background-color: #f1f5f9; }
        .btn { padding: 8px 12px; text-decoration: none; border-radius: 4px; color: white; font-weight: bold; font-size: 14px; }
        .btn-add { background-color: #27ae60; display: inline-block; }
        .btn-add:hover { background-color: #219150; }
        .btn-edit { background-color: #2980b9; margin-right: 5px; }
        .btn-delete { background-color: #c0392b; }
        .search-box { display: flex; gap: 6px; }
        .search-input { padding: 7px 10px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-search { padding: 7px 14px; background-color: #34495e; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-search:hover { background-color: #2c3e50; }
        .btn-reset { padding: 7px 10px; color: #555; text-decoration: none; align-self: center; }
        .sort-links { color: white; text-decoration: none; font-size: 12px; margin-left: 6px; }
        .sort-links:hover { text-decoration: underline; }
        .status-msg { width: 80%; margin: 10px auto; font-style: italic; color: #555; }
    </style>
</head>
<body>
    <h2>Danh Sách Người Dùng (Users)</h2>

    <div class="toolbar">
        <div>
            <a href="${pageContext.request.contextPath}/users?action=create" class="btn btn-add">+ Thêm mới User</a>
            <a href="${pageContext.request.contextPath}/users" class="btn btn-search" style="margin-left: 5px;">Tất cả Users</a>
        </div>
        <form action="${pageContext.request.contextPath}/users" method="get" class="search-box">
            <input type="hidden" name="action" value="search" />
            <input type="text" name="country" class="search-input" placeholder="Tìm kiếm theo quốc gia..." value="${requestScope.searchCountry}" />
            <button type="submit" class="btn-search">Tìm kiếm</button>
            <c:if test="${requestScope.searchCountry != null && !requestScope.searchCountry.isEmpty()}">
                <a href="${pageContext.request.contextPath}/users" class="btn-reset">Xóa lọc</a>
            </c:if>
        </form>
    </div>

    <c:if test="${requestScope.searchCountry != null && !requestScope.searchCountry.isEmpty()}">
        <div class="status-msg">
            Kết quả tìm kiếm cho quốc gia: <strong>"${requestScope.searchCountry}"</strong>
        </div>
    </c:if>

    <c:if test="${requestScope.currentOrder != null}">
        <div class="status-msg">
            Đang sắp xếp theo tên: <strong>${requestScope.currentOrder == 'asc' ? 'A → Z (Tăng dần)' : 'Z → A (Giảm dần)'}</strong>
        </div>
    </c:if>

    <table>
        <tr>
            <th>ID</th>
            <th>
                Tên User
                <a href="${pageContext.request.contextPath}/users?action=sort&order=asc" class="sort-links" title="Sắp xếp A-Z">▲ A-Z</a>
                <a href="${pageContext.request.contextPath}/users?action=sort&order=desc" class="sort-links" title="Sắp xếp Z-A">▼ Z-A</a>
            </th>
            <th>Email</th>
            <th>Quốc gia</th>
            <th>Hành động</th>
        </tr>
        <c:choose>
            <c:when test="${not empty requestScope.listUser}">
                <c:forEach var="user" items="${requestScope.listUser}">
                    <tr>
                        <td><c:out value="${user.id}" /></td>
                        <td><c:out value="${user.name}" /></td>
                        <td><c:out value="${user.email}" /></td>
                        <td><c:out value="${user.country}" /></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/users?action=edit&id=${user.id}" class="btn btn-edit">Sửa</a>
                            <a href="${pageContext.request.contextPath}/users?action=delete&id=${user.id}" class="btn btn-delete">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="5" style="text-align: center; color: #888; padding: 20px;">Không tìm thấy người dùng nào.</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </table>
</body>
</html>
