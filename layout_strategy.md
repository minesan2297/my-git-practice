# Báo Cáo Chiến Lược Dàn Trang (layout_strategy.md)

### Triết lý: CSS Grid sinh ra cho Layout tổng thể, Flexbox sinh ra cho Component chi tiết

Trong giao diện web hiện đại, việc chọn sai công cụ dàn trang sẽ dẫn đến "Div Soup" hoặc vỡ giao diện:

- **CSS Grid (2 Chiều - 2D):** Được thiết kế theo hướng **Layout-first**, cho phép kiểm soát đồng thời cả hàng và cột. Grid là lựa chọn hoàn hảo để dựng khung xương trang web và các bố cục Bento Box bất đối xứng (nơi các Widget cần `span` 2 hàng hoặc 2 cột) mà không cần lồng ghép các lớp `div` trung gian.
- **Flexbox (1 Chiều - 1D):** Hoạt động theo hướng **Content-first**, cực kỳ linh hoạt trong việc căn chỉnh các phần tử trên một trục duy nhất (trục ngang hoặc dọc). Flexbox lý tưởng cho thanh Navbar tự co giãn theo độ dài chữ, hoặc căn giữa biểu tượng và văn bản bên trong từng Widget nhỏ.
- **Bootstrap 12-Column Grid:** Tận dụng giải pháp có sẵn để triển khai siêu tốc (Rapid Prototyping) các khối chuẩn hóa như bảng giá 3 cột mà không tốn công viết lại Media Queries thủ công.
