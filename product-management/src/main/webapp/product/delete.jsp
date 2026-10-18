<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Product</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
            background-color: #f7f9fa;
        }
        .container {
            max-width: 550px;
            background: #fff;
            padding: 25px 30px;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .warning-text {
            color: #dc3545;
            font-size: 16px;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        td {
            padding: 8px;
            border-bottom: 1px solid #eee;
        }
        td.label {
            font-weight: bold;
            color: #495057;
            width: 35%;
        }
        .btn-delete {
            background-color: #dc3545;
            color: white;
            padding: 9px 18px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }
        .btn-delete:hover {
            background-color: #c82333;
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
        .cancel-btn {
            margin-left: 10px;
            color: #6c757d;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="products" class="back-link">&larr; Back to product list</a>
    <h2>Delete Product</h2>
    <p class="warning-text">Are you sure you want to permanently delete this product?</p>

    <table>
        <tr>
            <td class="label">Product ID:</td>
            <td>${requestScope["product"].getId()}</td>
        </tr>
        <tr>
            <td class="label">Product Name:</td>
            <td><strong>${requestScope["product"].getName()}</strong></td>
        </tr>
        <tr>
            <td class="label">Price:</td>
            <td>$${requestScope["product"].getPrice()}</td>
        </tr>
        <tr>
            <td class="label">Description:</td>
            <td>${requestScope["product"].getDescription()}</td>
        </tr>
        <tr>
            <td class="label">Manufacturer:</td>
            <td>${requestScope["product"].getManufacturer()}</td>
        </tr>
    </table>

    <form method="post" action="products?action=delete&id=${requestScope['product'].getId()}">
        <button type="submit" class="btn-delete">Yes, Delete Product</button>
        <a href="products" class="cancel-btn">Cancel</a>
    </form>
</div>
</body>
</html>
