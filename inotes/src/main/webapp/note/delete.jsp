<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác Nhận Xoá Ghi Chú - iNotes</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: "Segoe UI", Arial, sans-serif; margin: 0; background-color: #f4f6f9; color: #333; }
        .header { background: #b91c1c; color: white; padding: 20px 40px; }
        .header h1 { margin: 0; font-size: 20px; }
        .container { max-width: 600px; margin: 40px auto; background: white; padding: 30px 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.06); }
        h2 { margin-top: 0; color: #b91c1c; border-bottom: 2px solid #fee2e2; padding-bottom: 12px; }
        .warning-msg { color: #dc2626; margin-bottom: 20px; font-weight: 500; font-size: 15px; }
        .info-card { background: #f8fafc; border-left: 4px solid #b91c1c; padding: 15px 20px; border-radius: 4px; margin-bottom: 25px; }
        .info-row { margin-bottom: 10px; font-size: 14px; }
        .info-label { font-weight: 600; color: #475569; display: inline-block; width: 90px; }
        .btn-group { display: flex; gap: 12px; margin-top: 25px; }
        .btn-delete { background-color: #dc2626; color: white; border: none; padding: 10px 24px; border-radius: 6px; font-weight: bold; cursor: pointer; font-size: 14px; }
        .btn-delete:hover { background-color: #b91c1c; }
        .btn-cancel { background-color: #94a3b8; color: white; text-decoration: none; padding: 10px 20px; border-radius: 6px; font-weight: bold; font-size: 14px; display: inline-block; }
        .btn-cancel:hover { background-color: #64748b; }
    </style>
</head>
<body>

<div class="header">
    <h1>iNotes - Xác Nhận Xoá Ghi Chú</h1>
</div>

<div class="container">
    <h2>Bạn có chắc chắn muốn xoá ghi chú này?</h2>
    <p class="warning-msg">Hành động này sẽ xoá vĩnh viễn ghi chú khỏi tầng lưu trữ (${requestScope.currentStorageName}) và không thể hoàn tác.</p>

    <div class="info-card">
        <div class="info-row"><span class="info-label">Mã ID:</span> #${requestScope.note.id}</div>
        <div class="info-row"><span class="info-label">Tiêu đề:</span> <strong><c:out value="${requestScope.note.title}" /></strong></div>
        <div class="info-row"><span class="info-label">Phân loại:</span> <c:out value="${requestScope.note.noteType.name}" /></div>
    </div>

    <form action="${pageContext.request.contextPath}/notes?action=delete" method="post">
        <input type="hidden" name="id" value="${requestScope.note.id}">
        <div class="btn-group">
            <button type="submit" class="btn-delete">Đồng ý Xoá</button>
            <a href="${pageContext.request.contextPath}/notes" class="btn-cancel">Hủy bỏ</a>
        </div>
    </form>
</div>

</body>
</html>
