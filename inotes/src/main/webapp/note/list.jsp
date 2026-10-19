<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>iNotes - Danh Sách Ghi Chú</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: "Segoe UI", Arial, sans-serif; margin: 0; background-color: #f4f6f9; color: #333; }
        .header { background: linear-gradient(135deg, #1b2a7a, #34495e); color: white; padding: 20px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.15); }
        .header h1 { margin: 0; font-size: 24px; font-weight: 600; }
        .header .subtitle { font-size: 13px; opacity: 0.85; margin-top: 4px; }
        .storage-switcher { background: rgba(255,255,255,0.15); padding: 8px 16px; border-radius: 6px; font-size: 14px; display: flex; align-items: center; gap: 12px; }
        .storage-pill { background: #27ae60; color: white; padding: 4px 10px; border-radius: 12px; font-weight: bold; font-size: 12px; }
        .switch-link { color: #ffd166; font-weight: bold; text-decoration: none; border-bottom: 1px dashed #ffd166; }
        .switch-link:hover { color: #fff; border-bottom-color: #fff; }
        .container { max-width: 1100px; margin: 30px auto; padding: 0 20px; }
        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 15px; }
        .btn-add { background-color: #27ae60; color: white; padding: 10px 20px; border-radius: 6px; text-decoration: none; font-weight: bold; font-size: 14px; box-shadow: 0 2px 4px rgba(39,174,96,0.25); }
        .btn-add:hover { background-color: #219150; }
        .search-form { display: flex; gap: 8px; }
        .search-input { width: 320px; padding: 9px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; }
        .search-btn { background-color: #1b2a7a; color: white; border: none; padding: 9px 18px; border-radius: 6px; font-weight: bold; cursor: pointer; }
        .search-btn:hover { background-color: #14205c; }
        .clear-btn { align-self: center; color: #7f8c8d; text-decoration: none; font-size: 13px; margin-left: 4px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.06); }
        th, td { padding: 14px 18px; text-align: left; border-bottom: 1px solid #edf2f7; }
        th { background-color: #f8fafc; color: #475569; font-weight: 600; text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px; }
        tr:hover { background-color: #fbfcfe; }
        .badge { display: inline-block; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; }
        .badge-1 { background-color: #e0f2fe; color: #0284c7; } /* Cá nhân */
        .badge-2 { background-color: #fef3c7; color: #d97706; } /* Công việc */
        .badge-3 { background-color: #dcfce7; color: #16a34a; } /* Học tập */
        .badge-other { background-color: #f1f5f9; color: #64748b; }
        .action-link { text-decoration: none; font-size: 13px; font-weight: 600; margin: 0 4px; }
        .link-view { color: #0284c7; }
        .link-edit { color: #f59e0b; }
        .link-delete { color: #ef4444; }
        .note-title-link { color: #1e293b; font-weight: 600; text-decoration: none; }
        .note-title-link:hover { color: #1b2a7a; text-decoration: underline; }
        .empty-state { text-align: center; padding: 40px 20px; color: #94a3b8; }
    </style>
</head>
<body>

<div class="header">
    <div>
        <h1>iNotes Dashboard</h1>
        <div class="subtitle">Ứng dụng Quản lý Ghi chú Cá nhân • Áp dụng Strategy Pattern</div>
    </div>
    <div class="storage-switcher">
        <span>Tầng lưu trữ hiện tại:</span>
        <span class="storage-pill">${requestScope.currentStorageName}</span>
        <c:choose>
            <c:when test="${requestScope.currentStorageType == 'db'}">
                <a href="${pageContext.request.contextPath}/notes?action=switch-storage&type=file" class="switch-link" title="Đổi sang lưu file text">Chuyển sang File (.txt)</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/notes?action=switch-storage&type=db" class="switch-link" title="Đổi sang lưu database">Chuyển sang MySQL</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div class="container">
    <div class="toolbar">
        <div>
            <a href="${pageContext.request.contextPath}/notes?action=create" class="btn-add">+ Thêm Mới Ghi Chú</a>
        </div>
        <form action="${pageContext.request.contextPath}/notes" method="get" class="search-form">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="search-input" placeholder="Tìm kiếm theo tiêu đề hoặc nội dung..." value="<c:out value='${requestScope.keyword}' />">
            <button type="submit" class="search-btn">Tìm kiếm</button>
            <c:if test="${requestScope.keyword != null && !requestScope.keyword.isEmpty()}">
                <a href="${pageContext.request.contextPath}/notes" class="clear-btn">Xóa lọc</a>
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
            <th style="width: 60px;">#</th>
            <th>Tiêu đề</th>
            <th style="width: 150px;">Phân loại</th>
            <th style="width: 180px;">Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty requestScope.notes}">
                <c:forEach var="note" items="${requestScope.notes}">
                    <tr>
                        <td><strong><c:out value="${note.id}" /></strong></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/notes?action=view&id=${note.id}" class="note-title-link">
                                <c:out value="${note.title}" />
                            </a>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${note.typeId == 1}">
                                    <span class="badge badge-1"><c:out value="${note.noteType.name}" /></span>
                                </c:when>
                                <c:when test="${note.typeId == 2}">
                                    <span class="badge badge-2"><c:out value="${note.noteType.name}" /></span>
                                </c:when>
                                <c:when test="${note.typeId == 3}">
                                    <span class="badge badge-3"><c:out value="${note.noteType.name}" /></span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-other"><c:out value="${note.noteType.name}" /></span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/notes?action=view&id=${note.id}" class="action-link link-view">Xem</a> |
                            <a href="${pageContext.request.contextPath}/notes?action=edit&id=${note.id}" class="action-link link-edit">Sửa</a> |
                            <a href="${pageContext.request.contextPath}/notes?action=delete&id=${note.id}" class="action-link link-delete">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="4" class="empty-state">
                        Chưa có ghi chú nào trong hệ thống hoặc không khớp với từ khóa tìm kiếm.
                    </td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>

</body>
</html>
