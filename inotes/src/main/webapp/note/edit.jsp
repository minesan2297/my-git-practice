<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Ghi Chú - iNotes</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: "Segoe UI", Arial, sans-serif; margin: 0; background-color: #f4f6f9; color: #333; }
        .header { background: #1b2a7a; color: white; padding: 20px 40px; }
        .header h1 { margin: 0; font-size: 20px; }
        .container { max-width: 700px; margin: 40px auto; background: white; padding: 30px 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.06); }
        h2 { margin-top: 0; color: #1b2a7a; border-bottom: 2px solid #e2e8f0; padding-bottom: 12px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #475569; }
        input[type="text"], select, textarea { width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; font-family: inherit; }
        textarea { height: 160px; resize: vertical; line-height: 1.5; }
        .btn-group { display: flex; gap: 12px; margin-top: 25px; }
        .btn-update { background-color: #f59e0b; color: white; border: none; padding: 10px 24px; border-radius: 6px; font-weight: bold; cursor: pointer; font-size: 14px; }
        .btn-update:hover { background-color: #d97706; }
        .btn-cancel { background-color: #94a3b8; color: white; text-decoration: none; padding: 10px 20px; border-radius: 6px; font-weight: bold; font-size: 14px; display: inline-block; }
        .btn-cancel:hover { background-color: #64748b; }
        .storage-indicator { font-size: 12px; color: #64748b; margin-top: 5px; }
    </style>
</head>
<body>

<div class="header">
    <h1>iNotes - Cập Nhật Ghi Chú</h1>
</div>

<div class="container">
    <h2>Chỉnh Sửa Ghi Chú #${requestScope.note.id}</h2>
    <div class="storage-indicator">Đang lưu trữ vào: <strong>${requestScope.currentStorageName}</strong></div>
    <br>

    <form action="${pageContext.request.contextPath}/notes?action=edit" method="post">
        <input type="hidden" name="id" value="${requestScope.note.id}">

        <div class="form-group">
            <label for="title">Tiêu đề: <span style="color:red">*</span></label>
            <input type="text" id="title" name="title" required value="<c:out value='${requestScope.note.title}' />">
        </div>

        <div class="form-group">
            <label for="typeId">Phân loại: <span style="color:red">*</span></label>
            <select id="typeId" name="typeId" required>
                <c:forEach var="t" items="${requestScope.noteTypes}">
                    <option value="${t.id}" ${t.id == requestScope.note.typeId ? 'selected' : ''}>
                        ${t.name} - ${t.description}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="content">Nội dung chi tiết: <span style="color:red">*</span></label>
            <textarea id="content" name="content" required><c:out value='${requestScope.note.content}' /></textarea>
        </div>

        <div class="btn-group">
            <button type="submit" class="btn-update">Cập Nhật Ghi Chú</button>
            <a href="${pageContext.request.contextPath}/notes" class="btn-cancel">Hủy bỏ</a>
        </div>
    </form>
</div>

</body>
</html>
