# Nhật Ký Tra Cứu Hiệu Năng Index & SARGable Với AI (ai_prompt_log.md)

- **Mục tiêu:** Nắm vững cơ chế hoạt động của lệnh EXPLAIN, khái niệm SARGable, cấu trúc cây B-Tree và cơ chế Index Seek vs Index Scan trong MySQL.

### Lượt 1: Bản chất của truy vấn Non-SARGable
- **Prompt:** "Trong MySQL, nếu tôi tạo Index cho một cột ngày tháng, nhưng trong mệnh đề WHERE tôi lại viết `WHERE YEAR(col) = 2026 AND MONTH(col) = 6`, tại sao MySQL lại từ chối sử dụng Index và phải quét toàn bộ bảng (Full Table Scan)?"
- **AI Phản hồi:** Index dạng B-Tree lưu trữ các giá trị của cột đã được sắp xếp theo thứ tự nguyên bản. Khi áp dụng một hàm như `YEAR(col)` lên cột, MySQL không thể suy diễn ngược giá trị đầu vào nằm ở nhánh nào của cây B-Tree. Do đó, engine buộc phải duyệt qua từng dòng trong bảng, chạy hàm biến đổi rồi mới so sánh kết quả. Đây chính là hiện tượng Non-SARGable (Not Search Argument Able). Để tận dụng Index, phải giữ nguyên cột và chuyển phép so sánh thành khoảng (`>=` và `<`).

### Lượt 2: Thiết kế Composite Index và thứ tự cột
- **Prompt:** "Khi thiết kế một Composite Index cho bảng Transactions gồm 2 cột `(transaction_type, created_at)`, thứ tự các cột trong Index có quan trọng không? Tôi nên đặt cột nào đứng trước để có hiệu suất tốt nhất?"
- **AI Phản hồi:** Thứ tự cột trong Composite Index cực kỳ quan trọng và phải tuân theo quy tắc tiền tố trái nhất (Leftmost Prefix Rule). Cột dùng phép so sánh chính xác (`=`) là `transaction_type` phải đặt trước, còn cột dùng phép so sánh dải giá trị (`>=`, `<`) là `created_at` phải đặt sau. Nếu đặt `created_at` trước, sau khi engine thực hiện Range Scan trên ngày tháng, nó sẽ không thể tận dụng tiếp nhánh cây cho điều kiện `=` của cột sau.

### Lượt 3: Ý nghĩa các chỉ số trong EXPLAIN
- **Prompt:** "Hãy giải thích sự khác biệt giữa các mức độ truy cập trong cột `type` của lệnh EXPLAIN (`ALL`, `index`, `range`, `ref`, `const`) và ý nghĩa của thông báo `Using index condition` trong cột `Extra`."
- **AI Phản hồi:** 
  - `const`: Tìm kiếm duy nhất trên Primary Key hoặc Unique Key (nhanh nhất, O(1)).
  - `ref`: Khớp dữ liệu trên Non-Unique Index với điều kiện `=`.
  - `range`: Quét một khoảng giá trị trên Index thỏa mãn điều kiện so sánh dải (`>`, `<`, `BETWEEN`).
  - `index`: Quét toàn bộ cây Index (Full Index Scan).
  - `ALL`: Quét toàn bộ dữ liệu trên ổ đĩa (Full Table Scan - chậm nhất).
  - `Using index condition`: Biểu thị tính năng Index Condition Pushdown (ICP) của MySQL, cho phép lọc bản ghi trực tiếp tại tầng Storage Engine trước khi nạp dữ liệu vào Server Engine.

### Lượt 4: Cấu trúc cây B-Tree và cơ chế Index Seek vs Index Scan
- **Prompt:** "Sự khác biệt giữa Index Seek và Index Scan dưới góc nhìn cấu trúc cây B-Tree là gì? Tại sao Index Seek lại tối ưu hơn?"
- **AI Phản hồi:** 
  - **Index Seek:** Bộ tìm kiếm đi từ Root node qua các Non-leaf nodes xuống thẳng đúng Leaf node chứa dữ liệu cần tìm nhờ tính chất phân nhánh nhị phân/đa nhánh (độ phức tạp $O(\log N)$).
  - **Index Scan:** Con trỏ duyệt tuần tự qua danh sách liên kết kép nối giữa các Leaf node (độ phức tạp $O(N)$ trên tập phần tử của index).
  - Tối ưu hóa SARGable giúp câu truy vấn biến từ Full Table Scan thành Index Seek kết hợp Range Scan cục bộ, giảm thiểu số lần đọc trang đĩa (I/O).
