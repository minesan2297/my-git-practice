<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
            background-color: #f7f9fa;
        }
        h1 {
            color: #333;
        }
        .actions-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: #28a745;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
        }
        .btn:hover {
            background-color: #218838;
        }
        .search-form {
            display: flex;
            gap: 8px;
        }
        .search-input {
            padding: 7px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: 250px;
        }
        .search-btn {
            padding: 7px 15px;
            background-color: #007bff;
            border: none;
            color: white;
            border-radius: 4px;
            cursor: pointer;
        }
        .search-btn:hover {
            background-color: #0069d9;
        }
        .reset-link {
            padding: 7px 12px;
            color: #666;
            text-decoration: none;
            align-self: center;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            background-color: #fff;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #e0e0e0;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #f1f3f5;
            color: #495057;
        }
        tr:hover {
            background-color: #f8f9fa;
        }
        .action-link {
            text-decoration: none;
            margin-right: 10px;
            font-weight: 500;
        }
        .link-edit {
            color: #e0a800;
        }
        .link-delete {
            color: #dc3545;
        }
        .link-view {
            color: #007bff;
        }
    </style>
</head>
<body>
<h1>Product List</h1>

<div class="actions-bar">
    <div>
        <a href="products?action=create" class="btn">+ Create New Product</a>
    </div>
    <form action="products" method="get" class="search-form">
        <input type="hidden" name="action" value="search">
        <input type="text" name="search" class="search-input" placeholder="Search by product name..." value="${requestScope["searchKeyword"]}">
        <button type="submit" class="search-btn">Search</button>
        <c:if test='${requestScope["searchKeyword"] != null && !requestScope["searchKeyword"].isEmpty()}'>
            <a href="products" class="reset-link">Clear</a>
        </c:if>
    </form>
</div>

<c:if test='${requestScope["searchKeyword"] != null && !requestScope["searchKeyword"].isEmpty()}'>
    <p>Search results for: <strong>"${requestScope["searchKeyword"]}"</strong></p>
</c:if>

<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Product Name</th>
        <th>Price ($)</th>
        <th>Description</th>
        <th>Manufacturer</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${not empty requestScope['products']}">
            <c:forEach items="${requestScope['products']}" var="product">
                <tr>
                    <td>${product.getId()}</td>
                    <td><a href="products?action=view&id=${product.getId()}" class="link-view"><strong>${product.getName()}</strong></a></td>
                    <td>${product.getPrice()}</td>
                    <td>${product.getDescription()}</td>
                    <td>${product.getManufacturer()}</td>
                    <td>
                        <a href="products?action=view&id=${product.getId()}" class="action-link link-view">View</a>
                        <a href="products?action=edit&id=${product.getId()}" class="action-link link-edit">Edit</a>
                        <a href="products?action=delete&id=${product.getId()}" class="action-link link-delete">Delete</a>
                    </td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="6" style="text-align: center; color: #888; padding: 20px;">No products found.</td>
            </tr>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

</body>
</html>
