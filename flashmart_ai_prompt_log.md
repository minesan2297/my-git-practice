# Nhật Ký Hỏi Đáp Lý Thuyết JOIN Với AI (AI Prompt Log)

- **Mục tiêu:** Tra cứu lý thuyết tập hợp trong SQL, kỹ thuật Anti-Join và cơ chế tối ưu hóa câu lệnh JOIN của MySQL Optimizer.

### Lượt 1: Phân tích sự cố mất dữ liệu khi dùng INNER JOIN
- **Prompt:** "Trong MySQL, mặc định từ khóa `JOIN` (khi không ghi rõ `LEFT` hay `RIGHT`) hoạt động như thế nào? Tại sao nó lại làm biến mất những khách hàng chưa từng mua hàng trong bảng báo cáo?"
- **AI Phản hồi:** Mặc định `JOIN` tương đương với `INNER JOIN`. Phép toán này hoạt động dựa trên giao của hai tập hợp (Intersection): chỉ những bản ghi có giá trị khớp ở cả hai bảng mới được trả về. Do khách hàng chưa từng mua hàng không có dòng tương ứng trong bảng `Orders`, toàn bộ thông tin của họ bị loại bỏ khỏi kết quả. Để giữ nguyên tập hợp gốc bên trái, bắt buộc phải dùng `LEFT JOIN`.

### Lượt 2: Cơ chế đếm của hàm COUNT() khi kết hợp LEFT JOIN
- **Prompt:** "Khi tôi sử dụng `LEFT JOIN` và đếm số lượng đơn hàng bằng hàm `COUNT`, tôi nên dùng `COUNT(*)` hay `COUNT(o.order_id)`? Sự khác biệt khi kết quả trả về `NULL` là gì?"
- **AI Phản hồi:** `COUNT(*)` đếm số lượng hàng thực tế được sinh ra sau phép ghép, không quan tâm giá trị các cột có `NULL` hay không. Đối với bản ghi không khớp, dòng đó vẫn tồn tại nên `COUNT(*)` sẽ ra 1. Trong khi đó, `COUNT(cột)` chỉ đếm những dòng mà giá trị tại cột đó khác `NULL`. Vì vậy, dùng `COUNT(o.order_id)` sẽ trả về đúng 0 cho các khách hàng chưa có đơn.

### Lượt 3: Hiệu năng của Anti-Join (LEFT JOIN ... IS NULL) vs Subquery
- **Prompt:** "Hãy phân tích hiệu năng (Performance) của việc dùng `LEFT JOIN` kết hợp `WHERE ... IS NULL` so với việc dùng subquery `NOT IN` hoặc `NOT EXISTS` khi tìm kiếm các bản ghi không tồn tại trong bảng khác."
- **AI Phản hồi:** `LEFT JOIN ... IS NULL` và `NOT EXISTS` thường mang lại hiệu năng cao và an toàn hơn `NOT IN`. Nếu bảng con có chứa giá trị `NULL`, mệnh đề `NOT IN` có thể trả về tập rỗng (empty result) do logic 3 giá trị của SQL. MySQL Optimizer có thể chuyển đổi `LEFT JOIN ... IS NULL` thành chiến lược tìm kiếm sớm (Early Stop) khi thấy dòng khớp đầu tiên.

### Lượt 4: Mở rộng cơ chế MySQL Join Optimizer
- **Prompt:** "MySQL thực thi và tối ưu hóa các câu lệnh JOIN bên dưới tầng engine như thế nào? Thuật toán Nested-Loop Join hoạt động ra sao?"
- **AI Phản hồi:** MySQL sử dụng thuật toán **Nested-Loop Join (NLJ)** (hoặc Block Nested-Loop / Hash Join ở MySQL 8.0+). Engine sẽ duyệt qua từng dòng của bảng ngoài (Driving/Outer Table), sau đó dùng index để tìm các dòng khớp ở bảng trong (Inner Table). Với `LEFT JOIN`, bảng bên trái luôn cố định đóng vai trò Driving Table, đòi hỏi việc đánh chỉ mục khóa ngoại ở bảng bên phải để tránh Full Table Scan.
