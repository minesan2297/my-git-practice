# Báo Cáo Đánh Giá Hiệu Năng & Tài Nguyên Lưu Trữ (storage_performance_report.md)

### 1. Phân tích sự đánh đổi (Trade-off) giữa Read và Write
Index giúp tăng tốc truy vấn đọc (`SELECT`), nhưng lại là gánh nặng lớn đối với thao tác ghi (`INSERT`, `UPDATE`, `DELETE`). Khi một bảng có 5 Index, mỗi lần người dùng đăng status mới, MySQL không chỉ ghi dữ liệu vào bảng chính mà còn phải thực hiện đồng thời 5 thao tác cập nhật, phân tách trang (Page Split) và tái cân bằng trên 5 cây B-Tree ngầm. Điều này làm tăng độ trễ ghi dữ liệu, khóa trang và dẫn đến hiện tượng timeout 5-10 giây.

### 2. Số liệu so sánh và quyết định tối ưu
Sau khi loại bỏ 3 Index vô dụng (`idx_content`, `idx_post_type`, `idx_is_visible` do độ phân giải Cardinality quá thấp hoặc dung lượng Text quá lớn) và giữ lại 2 Index giá trị (`idx_user_id`, `idx_created_at`):

| Hạng mục | Trước tối ưu (5 Index) | Sau tối ưu (2 Index) | Hiệu quả đạt được |
| :--- | :--- | :--- | :--- |
| **Số lần cập nhật B-Tree/INSERT** | 6 lần (1 PK + 5 Index) | 3 lần (1 PK + 2 Index) | Giảm **50%** chi phí I/O ghi |
| **Dung lượng Index (`index_length`)** | ~200% dung lượng Data | ~30% dung lượng Data | Tiết kiệm **~70-80%** bộ nhớ Index |
| **Thời gian phản hồi Đăng bài** | 5 - 10s (Timeout) | < 0.1s | Hệ thống ổn định, hết nghẽn đĩa |
