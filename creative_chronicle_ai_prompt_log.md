# Nhật Ký Tra Cứu CSS Grid & Bootstrap Breakpoints Với AI (ai_prompt_log.md)

- **Mục tiêu:** Nắm vững cách dùng `grid-template-areas` / `span` trong CSS Grid, cơ chế Breakpoints của Bootstrap và giải pháp thay thế kỹ thuật dàn trang cũ bằng Utility classes.

### Lượt 1: Tác hại của `float` và tại sao Flexbox thay thế hoàn toàn
- **Prompt:** "Tại sao kỹ thuật dàn trang dùng `float` ngày xưa lại bắt buộc phải dùng thêm clearfix (`overflow: hidden` hoặc `clear: both`)? Tại sao `float` không thể căn giữa dọc (`vertical alignment`) tốt như Flexbox?"
- **AI Phản hồi:** Khi một phần tử được `float`, nó được đẩy sang một phía và nhấc một phần ra khỏi luồng văn bản (Out of flow). Thẻ cha không thể nhận biết được chiều cao của phần tử con bị float, dẫn đến hiện tượng sụp đổ chiều cao (Parent Height Collapse). Lập trình viên phải dùng hack clearfix để ép thẻ cha ôm trọn con. Ngoài ra, `float` chỉ xử lý việc trôi dạt theo trục ngang, không có bất kỳ thuộc tính nào để căn chỉnh đối trọng theo trục dọc (Cross Axis). Trong khi đó, Flexbox sinh ra với thuộc tính `align-items: center` giúp căn giữa theo trục dọc một cách tự nhiên và chính xác tuyệt đối.

### Lượt 2: Cú pháp CSS Grid cho bố cục Mosaic bất đối xứng
- **Prompt:** "Hãy hướng dẫn cách tạo bố cục Mosaic Gallery (1 ảnh lớn bên trái chiếm 2 hàng, 2 ảnh nhỏ xếp chồng bên phải) bằng CSS Grid mà không dùng `position: absolute` và không cố định pixel chiều cao?"
- **AI Phản hồi:** 
  Sử dụng CSS Grid 2 cột:
  ```css
  .mosaic-gallery {
      display: grid;
      grid-template-columns: 2fr 1fr;
      grid-template-rows: repeat(2, 220px);
      gap: 16px;
  }
  .photo-main {
      grid-column: 1 / 2;
      grid-row: 1 / 3; /* Chiếm từ hàng 1 đến hàng 3 (span 2 hàng) */
  }
  ```
  Cách này đảm bảo khối gallery nằm trọn vẹn trong Flow Layout, không đè lấn văn bản bên dưới và dễ dàng đổi sang `grid-template-columns: 1fr` trên điện thoại di động.

### Lượt 3: Phân chia Breakpoints trong lưới Bootstrap cho 4 thẻ bài viết
- **Prompt:** "Tôi muốn hiển thị 4 thẻ bài viết trên Desktop, 2 thẻ trên Tablet và 1 thẻ trên Mobile bằng Bootstrap 5. Tôi nên kết hợp những class nào trong thẻ cột (`col`)?"
- **AI Phản hồi:** 
  Sử dụng cấu trúc: `<div class="col-12 col-md-6 col-lg-3">` bên trong một `<div class="row g-4">`.
  - Mặc định (Mobile < 768px): `col-12` chiếm trọn 12/12 cột $\rightarrow$ 1 thẻ / dòng.
  - Tablet ($\ge$ 768px): `col-md-6` chiếm 6/12 cột $\rightarrow$ 2 thẻ / dòng.
  - Desktop ($\ge$ 992px): `col-lg-3` chiếm 3/12 cột $\rightarrow$ 4 thẻ / dòng.
  Bootstrap tự động tính toán padding và ngắt dòng hoàn hảo mà không cần viết thêm bất kỳ dòng Media Query thủ công nào.

### Lượt 4: Tận dụng Spacing Utilities của Bootstrap
- **Prompt:** "Làm thế nào để tận dụng các Spacing Utilities của Bootstrap 5 như `gap-2`, `mb-4`, `d-flex` để viết code HTML tinh gọn hơn mà không phải mở file CSS viết thêm thuộc tính Flexbox?"
- **AI Phản hồi:** Bootstrap 5 tích hợp sẵn hệ thống class tiện ích trực tiếp vào class của thẻ:
  - `d-flex align-items-center justify-content-between`: biến phần tử thành Flex container căn giữa hoàn hảo.
  - `gap-2` hoặc `gap-3`: tạo khoảng cách đồng đều giữa các nút bấm mà không cần `margin`.
  - `mb-4`, `mt-5`, `pb-2`: quản lý khoảng cách lề trên dưới theo thang điểm chuẩn (1 đến 5), giúp giảm thiểu tối đa CSS tùy biến dư thừa.
