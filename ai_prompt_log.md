# Nhật Ký Tương Tác AI (AI Prompt Log)

- **Mục tiêu:** Hỗ trợ phân tích lỗ hổng thiết kế CSDL và tối ưu hóa kiểu dữ liệu tài chính trong MySQL.

### Lượt 1: Phân tích Anti-Pattern
- **Prompt:** "Trong thiết kế cơ sở dữ liệu quan hệ, tại sao việc dùng một cột `is_active` (kiểu TINYINT/BOOLEAN) để theo dõi vòng đời của một Đơn hàng/Lịch hẹn lại là một thiết kế tồi (Anti-pattern)? Tôi nên thay thế bằng cấu trúc nào?"
- **AI Phản hồi:** Giải thích rằng kiểu BOOLEAN chỉ biểu diễn được 2 trạng thái bật/tắt, không thể mô tả quy trình luân chuyển trạng thái (State Machine). Giải pháp chuẩn là dùng kiểu `ENUM` liệt kê danh sách trạng thái hoặc tạo bảng trạng thái riêng biệt (`Lookup Table`).

### Lượt 2: Lựa chọn kiểu dữ liệu tài chính
- **Prompt:** "Khi thiết kế cột deposit_amount và penalty_fee trong MySQL phục vụ tính toán tài chính, tôi nên dùng kiểu dữ liệu FLOAT, DOUBLE hay DECIMAL? Tại sao?"
- **AI Phản hồi:** Khuyên dùng `DECIMAL(12, 2)` vì FLOAT và DOUBLE là kiểu số thực dấu phẩy động xấp xỉ (floating-point), dễ gây ra sai số làm tròn (precision errors) khi tính toán cộng/trừ tiền tệ. DECIMAL lưu trữ giá trị số chính xác tuyệt đối.

### Lượt 3: Thiết lập ràng buộc toàn vẹn
- **Prompt:** "Làm thế nào để đảm bảo một Lịch hẹn chỉ có tối đa 1 đơn thuốc duy nhất và nếu xóa lịch hẹn thì đơn thuốc bị xóa theo?"
- **AI Phản hồi:** Đặt khóa ngoại `appointment_id` trong bảng `Prescriptions` kèm ràng buộc `UNIQUE` (tạo quan hệ 1-1) và thêm điều kiện `ON DELETE CASCADE`.