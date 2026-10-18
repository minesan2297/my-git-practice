<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Delete customer</title>
</head>
<body>
<h1>Delete customer</h1>
<p>
    <a href="customers">Back to customer list</a>
</p>
<form method="post">
    <h3>Are you sure you want to delete this customer?</h3>
    <fieldset>
        <legend>Customer information</legend>
        <table>
            <tr>
                <td>Name: </td>
                <td>${requestScope["customer"].getName()}</td>
            </tr>
            <tr>
                <td>Email: </td>
                <td>${requestScope["customer"].getEmail()}</td>
            </tr>
            <tr>
                <td>Address: </td>
                <td>${requestScope["customer"].getAddress()}</td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" value="Delete customer"></td>
            </tr>
        </table>
    </fieldset>
</form>
</body>
</html>
