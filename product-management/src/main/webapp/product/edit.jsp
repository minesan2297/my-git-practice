<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
            background-color: #f7f9fa;
        }
        .container {
            max-width: 600px;
            background: #fff;
            padding: 25px 30px;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            padding: 10px 15px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #495057;
        }
        input[type="text"], input[type="number"], textarea {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        textarea {
            resize: vertical;
            height: 80px;
        }
        .btn-submit {
            background-color: #ffc107;
            color: #212529;
            padding: 9px 18px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }
        .btn-submit:hover {
            background-color: #e0a800;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 15px;
            color: #007bff;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="products" class="back-link">&larr; Back to product list</a>
    <h2>Edit Product</h2>

    <c:if test='${requestScope["message"] != null}'>
        <div class="message">${requestScope["message"]}</div>
    </c:if>

    <form method="post" action="products?action=edit&id=${requestScope['product'].getId()}">
        <div class="form-group">
            <label for="id">Product ID:</label>
            <input type="text" id="id" value="${requestScope['product'].getId()}" readonly disabled style="background-color: #e9ecef;">
        </div>
        <div class="form-group">
            <label for="name">Product Name:</label>
            <input type="text" id="name" name="name" value="${requestScope['product'].getName()}" required>
        </div>
        <div class="form-group">
            <label for="price">Price ($):</label>
            <input type="number" step="0.01" min="0" id="price" name="price" value="${requestScope['product'].getPrice()}" required>
        </div>
        <div class="form-group">
            <label for="description">Description:</label>
            <textarea id="description" name="description">${requestScope['product'].getDescription()}</textarea>
        </div>
        <div class="form-group">
            <label for="manufacturer">Manufacturer:</label>
            <input type="text" id="manufacturer" name="manufacturer" value="${requestScope['product'].getManufacturer()}" required>
        </div>
        <div>
            <button type="submit" class="btn-submit">Update Product</button>
        </div>
    </form>
</div>
</body>
</html>
