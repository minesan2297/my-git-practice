<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Ghi Chú - iNotes</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: "Segoe UI", Arial, sans-serif; margin: 0; background-color: #f4f6f9; color: #333; }
        .header { background: #1b2a7a; color: white; padding: 20px 40px; }
        .header h1 { margin: 0; font-size: 20px; }
        .container { max-width: 750px; margin: 40px auto; background: white; padding: 35px 45px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.06); }
        .top-meta { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .badge { display: inline-block; padding: 5px 12px; border-radius: 12px; font-size: 13px; font-weight: 600; }
        .badge-1 { background-color: #e0f2fe; color: #0284c7; }
        .badge-2 { background-color: #fef3c7; color: #d97706; }
        .badge-3 { background-color: #dcfce7; color: #16a34a; }
        .badge-other { background-color: #f1f5f9; color: #64748b; }
        h1.note-title { margin-top: 0; color: #0f172a; font-size: 26px; line-height: 1.3; border-bottom: 2px solid #f1f5f9; padding-bottom: 15px; }
        .note-content-box { margin: 25px 0; line-height: 1.7; font-size: 15px; white-space: pre-wrap; background: #f8fafc; padding: 20px; border-radius: 6px; border: 1px solid #e2e8f0; }
        .btn-group { display: flex; gap: 12px; margin-top: 30px; }
        .btn { padding: 9px 18px; border-radius: 6px; font-weight: bold; font-size: 14px; text-decoration: none; display: inline-block; }
        .btn-edit { background-color: #f59e0b; color: white; }
        .btn-edit:hover { background-color: #d97706; }
        .btn-delete { background-color: #ef4444; color: white; }
        .btn-delete:hover { background-color: #dc2626; }
        .btn-back { background-color: #64748b; color: white; }
        .btn-back:hover { background-color: #475569; }
        .storage-tag { font-size: 12px; color: #94a3b8; }
    </style>
</head>
<body>

<div class="header">
    <h1>iNotes - Chi Tiết Ghi Chú</h1>
</div>

<div class="container">
    <div class="top-meta">
        <div>
            <c:choose>
                <c:when test="${requestScope.note.typeId == 1}">
                    <span class="badge badge-1"><c:out value="${requestScope.note.noteType.name}" /></span>
                </c:when>
                <c:when test="${requestScope.note.typeId == 2}">
                    <span class="badge badge-2"><c:out value="${requestScope.note.noteType.name}" /></span>
                </c:when>
                <c:when test="${requestScope.note.typeId == 3}">
                    <span class="badge badge-3"><c:out value="${requestScope.note.noteType.name}" /></span>
                </c:when>
                <c:otherwise>
                    <span class="badge badge-other"><c:out value="${requestScope.note.noteType.name}" /></span>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="storage-tag">Lưu trữ: ${requestScope.currentStorageName}</div>
    </div>

    <h1 class="note-title"><c:out value="${requestScope.note.title}" /></h1>

    <div class="note-content-box"><c:out value="${requestScope.note.content}" /></div>

    <div class="btn-group">
        <a href="${pageContext.request.contextPath}/notes?action=edit&id=${requestScope.note.id}" class="btn btn-edit">Sửa Ghi Chú</a>
        <a href="${pageContext.request.contextPath}/notes?action=delete&id=${requestScope.note.id}" class="btn btn-delete">Xoá Ghi Chú</a>
        <a href="${pageContext.request.contextPath}/notes" class="btn btn-back">&larr; Quay lại danh sách</a>
    </div>
</div>

</body>
</html>
