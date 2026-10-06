# Báo Cáo Phân Tích Sự Bất Nhất (Gap Analysis) - Hệ Thống HealthSync

Sau khi đối chiếu giữa Lưu đồ hoạt động (UML Activity Diagram) của nghiệp vụ với mã cơ sở dữ liệu cũ (Legacy Schema), phát hiện 3 lỗ hổng nghiêm trọng khiến hệ thống sụp đổ khi vận hành:

### 1. Thiếu cấu trúc quản lý vòng đời đa trạng thái
Bản thiết kế cũ dùng trường `is_active BOOLEAN`. Một cờ nhị phân (chỉ có True/False) hoàn toàn bất lực trước quy trình 5 bước thực tế: `PENDING` -> `CONFIRMED` -> `CHECKED_IN` -> `COMPLETED` / `CANCELLED`. Khi lịch hẹn được xác nhận hay khi bệnh nhân đã check-in, hệ thống không có cách nào ghi nhận.

### 2. Thiếu hụt hoàn toàn các trường phục vụ xử lý tài chính và phạt hủy lịch
Nghiệp vụ quy định bệnh nhân hủy sau khi xác nhận phải bị phạt trừ vào cọc. Schema cũ không có các cột `deposit_amount`, `penalty_fee` và `cancel_reason`. Hậu quả là phần mềm không thể lưu vết dòng tiền cọc và tiền phạt, gây thất thoát tài chính và kế toán không thể đối soát.

### 3. Vắng mặt bảng dữ liệu Đơn thuốc (Prescriptions)
Khi khám xong (`COMPLETED`), nghiệp vụ yêu cầu bác sĩ kê đơn thuốc gắn liền với lịch khám. Tuy nhiên CSDL cũ hoàn toàn không có bảng nào để lưu đơn thuốc hay thuốc điều trị, dẫn đến tính năng kê đơn báo lỗi 100% khi chạy thử nghiệm.