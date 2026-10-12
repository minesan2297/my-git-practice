# Nhật Ký Tra Cứu Kiến Trúc Clustered & Secondary Index Với AI (ai_prompt_log.md)

- **Mục tiêu:** Hiểu sâu về cấu trúc Clustered Index vs Secondary Index trong InnoDB, cơ chế Covering Index và tính toán dung lượng Byte của Index.

### Lượt 1: Cơ chế Covering Index và lý do nó tăng tốc tối đa
- **Prompt:** "Trong MySQL, khái niệm 'Covering Index' (Chỉ mục bao phủ) là gì? Tại sao khi EXPLAIN xuất hiện `Extra: Using index` thì câu truy vấn SELECT lại chạy nhanh nhất có thể?"
- **AI Phản hồi:** Covering Index là một Secondary Index chứa đầy đủ tất cả các cột được yêu cầu trong câu truy vấn (cả ở mệnh đề SELECT, WHERE, ORDER BY). Bình thường, khi tìm kiếm bằng Secondary Index, sau khi định vị được khóa, MySQL phải dùng con trỏ Primary Key để tra cứu ngược về Clustered Index (gọi là Bookmark/Row Lookup) nhằm lấy các cột còn lại. Khi có Covering Index, toàn bộ dữ liệu cần thiết đã nằm ngay tại lá của cây Index, MySQL đọc trực tiếp từ Index mà không cần chạm vào ổ đĩa đọc bảng gốc, giảm 50% thao tác I/O.

### Lượt 2: Kiến trúc Clustered Index vs Secondary Index trong InnoDB
- **Prompt:** "Cách MySQL InnoDB phân bổ dữ liệu trên Clustered Index và Secondary Index như thế nào? Tại sao Secondary Index lại phải lưu kèm cả giá trị của Primary Key?"
- **AI Phản hồi:** 
  - Trong InnoDB, bảng chính chính là **Clustered Index**, được tổ chức theo cây B-Tree dựa trên Primary Key; các lá (Leaf nodes) chứa toàn bộ dữ liệu thực của từng dòng.
  - Các **Secondary Index** là những cây B-Tree độc lập. Tại các Leaf node của Secondary Index, InnoDB chỉ lưu các cột được index cộng với giá trị **Primary Key** của dòng tương ứng (đóng vai trò con trỏ logic). Vì vậy, nếu Primary Key càng lớn (ví dụ UUID) hoặc Secondary Index chứa càng nhiều cột, dung lượng Index sẽ nhân lên gấp bội.

### Lượt 3: Tính toán chi tiết dung lượng Byte của Fat Index vs Lean Index
- **Prompt:** "Hãy tính toán dung lượng (Byte calculation) trên mỗi dòng của `idx_fat_covering(sensor_id, recorded_at, temperature, humidity, status)` so với `idx_lean_search(sensor_id, recorded_at)` trong bảng `SensorLogs` (log_id BIGINT PRIMARY KEY)?"
- **AI Phản hồi:** 
  - Mỗi bản ghi trong Secondary Index luôn kèm khóa chính `log_id (BIGINT)` = 8 bytes + overhead con trỏ ~4 bytes.
  - **Fat Index:** `sensor_id (4B)` + `recorded_at (5B)` + `temperature (DECIMAL(5,2): 3B)` + `humidity (3B)` + `status (VARCHAR(20) utf8mb4: ~20-80B)` + `log_id (8B)` $\approx$ **45 - 100 bytes/row**.
  - **Lean Index:** `sensor_id (4B)` + `recorded_at (5B)` + `log_id (8B)` $\approx$ **17 bytes/row**.
  - Với 10,000 cảm biến gửi hàng chục triệu bản ghi, Fat Index chiếm hàng chục Gigabyte SSD đắt đỏ, trong khi Lean Index tiết kiệm hơn 70% dung lượng.

### Lượt 4: Write Penalty và sự cố Page Splits
- **Prompt:** "Khái niệm 'Write Penalty' của Index là gì? Tại sao việc nhồi nhiều cột liên tục thay đổi (như nhiệt độ, độ ẩm) vào Index lại làm sập hệ thống ghi thời gian thực?"
- **AI Phản hồi:** Write Penalty là chi phí hiệu năng mà database phải trả mỗi khi có lệnh ghi (INSERT/UPDATE/DELETE). Cây B-Tree đòi hỏi dữ liệu luôn được sắp xếp theo thứ tự khóa. Khi các giá trị nhiệt độ và thời gian đến liên tục và không theo thứ tự tuyệt đối, InnoDB phải liên tục thực hiện chia tách trang (Page Splits), tạo các trang rỗng một nửa, gây phân mảnh đĩa và sinh ra hàng nghìn thao tác Random Disk I/O. Điều này làm trễ hàng đợi nạp dữ liệu và gây nghẽn toàn bộ pipeline.
