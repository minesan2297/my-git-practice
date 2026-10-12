# Báo Cáo Phân Tích Đánh Đổi Hiệu Năng & Chi Phí (index_tradeoff_report.md)

### 1. Bản chất sự đánh đổi (Trade-off) giữa Read và Write trong hệ thống IoT
Trong hệ thống IoT "SmartFactory" với lưu lượng ghi hàng chục nghìn bản ghi/giây (Write-heavy), việc duy trì "Fat Covering Index" (`idx_fat_covering` gồm cả 5 cột) là một quyết định thiếu cân nhắc. Mặc dù truy vấn Dashboard đọc nhanh do `Extra: Using index`, nhưng mỗi lệnh `INSERT` phải gánh chịu **Write Penalty** nặng nề: phân tách trang B-Tree (Page Splits) và ghi ngẫu nhiên trên đĩa cho toàn bộ các cột đo lường liên tục biến động. Điều này dẫn đến nghẽn hàng đợi (Data Loss) và hóa đơn AWS SSD tăng gấp 4 lần.

### 2. Quyết định tái cấu trúc Lean Index
Chúng tôi đã thay thế bằng **Lean Index** `idx_lean_search(sensor_id, recorded_at)`:

| Tiêu chí | Fat Covering Index | Lean Index (Tối ưu) | Hiệu quả thực tế |
| :--- | :--- | :--- | :--- |
| **Kích thước Index** | ~45 bytes/row | ~12 bytes/row | **Tiết kiệm >70%** bộ nhớ Index & Disk |
| **Tốc độ INSERT (Ghi)** | Nghẽn pipeline, Timeout | Tăng tốc độ ghi gấp 4 - 5 lần | Chấm dứt hoàn toàn lỗi rớt dữ liệu |
| **Tốc độ SELECT (Đọc)** | Cực nhanh (Using index) | ~1-2ms (Index Range + Row Lookup) | Vẫn mượt mà, người dùng không nhận ra chênh lệch |

Hệ thống chấp nhận đánh đổi một phần nghìn giây thời gian đọc của Dashboard để đổi lại sự sống còn của toàn bộ luồng truyền dữ liệu cảm biến và tối ưu chi phí hạ tầng Cloud.
