# Báo Cáo Phân Tích Tái Cấu Trúc Bố Cục (layout_refactoring.md)

### 1. Tác hại của `position: absolute` đối với Responsive Design
Khi sử dụng `position: absolute` kèm chiều cao cố định (`height: 400px`), phần tử bị tách hoàn toàn khỏi luồng hiển thị thông thường (Normal Flow) của tài liệu. Thẻ cha mất khả năng tự động tính toán chiều cao thực tế dựa theo nội dung bên trong (Height Collapse). Khi hiển thị trên thiết bị di động với màn hình hẹp, các ảnh tuyệt đối không thể tự co giãn theo tỉ lệ, dẫn đến hiện tượng xếp chồng méo mó và đè bẹp lên đoạn văn bản bên dưới, phá hủy hoàn toàn trải nghiệm đọc.

### 2. CSS Grid: Giải pháp cứu cánh cho Mosaic Gallery
CSS Grid giải quyết triệt để vấn đề này nhờ cơ chế quản lý không gian hai chiều (2D):
- Giữ nguyên các phần tử trong luồng DOM tự nhiên, tự động tính toán chiều cao theo nội dung thực.
- Sử dụng đơn vị linh hoạt `2fr 1fr` kết hợp `grid-row: 1 / 3` (span 2 hàng) giúp tạo hình ảnh khảm bất đối xứng mà không cần gán cứng pixel.
- Dễ dàng chuyển đổi mượt mà thành bố cục 1 cột dọc trên Mobile thông qua Media Query mà không làm xô lệch nội dung tiếp theo.
