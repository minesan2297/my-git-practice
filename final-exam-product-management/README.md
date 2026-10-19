# HƯỚNG DẪN CÀI ĐẶT VÀ CHẠY DỰ ÁN FINAL EXAM: PRODUCT MANAGEMENT

Dự án Java Web xây dựng bằng **JSP - Servlet - JDBC - MySQL**, tương thích **Apache Tomcat 10.1+** (chuẩn Jakarta EE 6.0).

---

## 1. Cấu hình Cơ sở dữ liệu (MySQL)
1. Mở MySQL Workbench / DBeaver / Terminal.
2. Chạy file `database.sql` đính kèm trong thư mục gốc của dự án.
   - Database name: `product_management_db`
   - Bảng: `products` (`id`, `name`, `price`, `quantity`).
   - Đã có sẵn dữ liệu mẫu.
3. Nếu mật khẩu MySQL khác `password`, mở file:
   `src/main/java/com/codegym/dao/ProductDAO.java`
   và sửa lại `jdbcPassword = "your_mysql_password";`.

---

## 2. Đóng gói và chạy trên Apache Tomcat
1. Mở Terminal tại thư mục dự án và chạy lệnh:
   ```bash
   mvn clean package
   ```
2. Sau khi xuất hiện `BUILD SUCCESS`, file `product-management.war` được tạo tại thư mục `target/`.
3. Copy file `product-management.war` dán vào thư mục `webapps/` của Apache Tomcat.
4. Khởi động server Tomcat và truy cập vào đường dẫn:
   ```text
   http://localhost:8080/product-management/products
   ```

---

## 3. Các chức năng chính
- **Hiển thị danh sách sản phẩm**: Bảng danh sách đầy đủ ID, Tên, Giá, Số lượng.
- **Thêm sản phẩm mới**: Form nhập liệu trực quan, tự động làm mới danh sách sau khi thêm.
- **Sửa thông tin sản phẩm**: Cho phép cập nhật tên, giá bán và số lượng tồn kho.
- **Xóa sản phẩm**: Có màn hình xác nhận an toàn trước khi xóa khỏi CSDL.
- **Tìm kiếm**: Tìm kiếm theo tên sản phẩm trực tiếp.
