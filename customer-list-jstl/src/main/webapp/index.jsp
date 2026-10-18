<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.codegym.Customer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Khai báo thư viện thẻ JSTL Core chuẩn --%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<%
    // Bước 5: Tạo danh sách khách hàng mẫu và lưu vào request scope để JSTL c:forEach duyệt qua
    List<Customer> customerList = new ArrayList<>();
    customerList.add(new Customer("Mai Văn Hoàn", "1983-08-20", "Hà Nội", "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=120&q=80"));
    customerList.add(new Customer("Nguyễn Văn Nam", "1983-08-21", "Bắc Giang", "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=120&q=80"));
    customerList.add(new Customer("Nguyễn Thái Hòa", "1983-08-22", "Nam Định", "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=120&q=80"));
    customerList.add(new Customer("Trần Đăng Khoa", "1983-08-17", "Hà Tây", "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=120&q=80"));
    customerList.add(new Customer("Nguyễn Đình Thi", "1983-08-19", "Hà Nội", "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=120&q=80"));

    request.setAttribute("customers", customerList);
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Danh Sách Khách Hàng</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8fafc;
            padding: 40px 20px;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        h2 {
            text-align: center;
            color: #1e293b;
            margin-bottom: 25px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        th {
            background-color: #f1f5f9;
            color: #475569;
            font-weight: bold;
            font-size: 14px;
            text-transform: uppercase;
        }

        tr:hover {
            background-color: #f8fafc;
        }

        .avatar-img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            box-shadow: 0 2px 5px rgba(0,0,0,0.15);
            display: block;
        }

        .index-col {
            text-align: center;
            font-weight: bold;
            color: #64748b;
            width: 60px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Danh Sách Khách Hàng</h2>

        <!-- Bước 6: Sử dụng JSTL c:forEach duyệt qua danh sách khách hàng -->
        <table>
            <thead>
                <tr>
                    <th class="index-col">STT</th>
                    <th>Tên</th>
                    <th>Ngày Sinh</th>
                    <th>Địa Chỉ</th>
                    <th>Ảnh</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="customer" items="${customers}" varStatus="status">
                    <tr>
                        <td class="index-col">${status.count}</td>
                        <td><strong>${customer.name}</strong></td>
                        <td>${customer.dateOfBirth}</td>
                        <td>${customer.address}</td>
                        <td>
                            <img class="avatar-img" src="${customer.image}" alt="${customer.name}">
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</body>
</html>
