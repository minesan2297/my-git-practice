<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product Details</title>
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
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            margin-bottom: 25px;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #eee;
        }
        td.label {
            font-weight: bold;
            color: #495057;
            width: 35%;
        }
        .price-highlight {
            color: #28a745;
            font-size: 18px;
            font-weight: bold;
        }
        .actions {
            display: flex;
            gap: 10px;
        }
        .btn {
            display: inline-block;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
            font-size: 14px;
        }
        .btn-edit {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-delete {
            background-color: #dc3545;
            color: white;
        }
        .btn-list {
            background-color: #6c757d;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Product Details</h2>

    <table>
        <tr>
            <td class="label">ID:</td>
            <td>${requestScope["product"].getId()}</td>
        </tr>
        <tr>
            <td class="label">Product Name:</td>
            <td><strong>${requestScope["product"].getName()}</strong></td>
        </tr>
        <tr>
            <td class="label">Price:</td>
            <td><span class="price-highlight">$${requestScope["product"].getPrice()}</span></td>
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

    <div class="actions">
        <a href="products?action=edit&id=${requestScope['product'].getId()}" class="btn btn-edit">Edit</a>
        <a href="products?action=delete&id=${requestScope['product'].getId()}" class="btn btn-delete">Delete</a>
        <a href="products" class="btn btn-list">&larr; Back to List</a>
    </div>
</div>
</body>
</html>
