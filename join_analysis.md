# Giải Trình Kỹ Thuật: Sử Dụng COUNT(o.order_id) Thay Vì COUNT(*)

Trong câu truy vấn báo cáo Marketing, việc sử dụng `COUNT(o.order_id)` thay vì `COUNT(*)` là bắt buộc vì:

Khi thực hiện `LEFT JOIN` giữa bảng `Customers` và `Orders`, đối với khách hàng chưa từng mua hàng (như Charlie), toàn bộ các cột từ bảng `Orders` sẽ mang giá trị `NULL`. 

- Hàm `COUNT(*)` đếm tổng số dòng được tạo ra sau phép JOIN, kể cả dòng chứa các giá trị `NULL`. Do đó, dòng của khách hàng Charlie vẫn được tính là 1 dòng, dẫn đến kết quả sai lệch là `total_orders = 1`.
- Ngược lại, hàm `COUNT(tên_cột)` (cụ thể là `COUNT(o.order_id)`) có cơ chế tự động bỏ qua (ignore) các giá trị `NULL`. Vì `o.order_id` của Charlie là `NULL`, hàm sẽ trả về đúng giá trị `0`.

Nhờ đó, hệ thống phân loại chính xác khách hàng chưa phát sinh đơn để áp dụng Voucher 50%.
