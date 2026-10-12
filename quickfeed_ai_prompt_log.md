# Nhật Ký Phân Tích Tài Nguyên & Cardinality Với AI (ai_prompt_log.md)

- **Mục tiêu:** Nắm vững cách tính dung lượng lưu trữ của InnoDB, khái niệm Cardinality và tác hại của việc lạm dụng Index (Over-indexing).

### Lượt 1: Tác hại của việc tạo Index trên cột TEXT và BOOLEAN
- **Prompt:** "Trong MySQL, nếu tôi tạo Index trên một cột chứa văn bản dài (`TEXT`) và một cột kiểu `BOOLEAN` (chỉ 0 và 1), thì điều này gây hại như thế nào đến bộ nhớ RAM, dung lượng Disk và bộ tối ưu hóa (Query Optimizer)?"
- **AI Phản hồi:**
  - Cột `TEXT` có độ dài chuỗi lớn, làm cho kích thước mỗi node trong cây B-Tree phình to. Điều này làm giảm số lượng khóa chứa được trong một trang dữ liệu 16KB (InnoDB page), dẫn đến chiều cao cây B-Tree tăng, tốn RAM trong Buffer Pool và lãng phí dung lượng đĩa.
  - Cột `BOOLEAN` chỉ có 2 giá trị phân biệt. Bộ tối ưu hóa (Query Optimizer) tính toán chi phí và nhận thấy việc duyệt qua Index rồi tra cứu lại bảng (Bookmark Lookup) tốn tài nguyên hơn nhiều so với việc quét tuần tự toàn bảng (Full Table Scan), khiến Index này hoàn toàn bị lãng phí.

### Lượt 2: Lý giải vì sao MySQL từ chối Index trên cột có độ phân giải thấp
- **Prompt:** "Tại sao khi tôi truy vấn `SELECT * FROM Posts WHERE is_visible = 1` trên bảng có hàng triệu dòng (trong đó 99% bản ghi mang giá trị 1), MySQL lại chọn Full Table Scan thay vì dùng Index `idx_is_visible`?"
- **AI Phản hồi:** MySQL Optimizer hoạt động dựa trên mô hình định giá chi phí (Cost-based Optimizer). Khi điều kiện lọc trả về một tỷ lệ dữ liệu lớn (thường > 20-30% bảng), việc sử dụng Index sẽ phát sinh hàng triệu lượt Random Disk I/O để đọc bảng chính. Thay vào đó, Sequential I/O (đọc liên tục) của Full Table Scan sẽ nhanh hơn gấp nhiều lần. Vì vậy, Index trên cột có Cardinality thấp gần như không bao giờ được sử dụng cho truy vấn loại này.

### Lượt 3: Truy vấn dung lượng Data và Index từ information_schema
- **Prompt:** "Hãy cho tôi xem truy vấn SQL sử dụng bảng `information_schema.TABLES` để in ra kích thước Data và kích thước Index của bảng 'Posts' tính theo đơn vị Megabyte (MB)."
- **AI Phản hồi:**
  ```sql
  SELECT table_name,
         ROUND(data_length / (1024 * 1024), 2) AS Data_MB,
         ROUND(index_length / (1024 * 1024), 2) AS Index_MB
  FROM information_schema.TABLES
  WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';
  ```
  Thông số `data_length` đại diện cho Clustered Index (dữ liệu thật), còn `index_length` là tổng kích thước của tất cả Secondary B-Tree Indexes.

### Lượt 4: Cơ chế lưu trữ trang của InnoDB và giải pháp thay thế cho cột TEXT
- **Prompt:** "Trong InnoDB, cấu trúc Data Pages và Index Pages được quản lý như thế nào? Nếu người dùng muốn tìm kiếm từ khóa trong cột content mà không tốn dung lượng B-Tree, ta nên áp dụng giải pháp nào?"
- **AI Phản hồ:** InnoDB quản lý bộ nhớ theo các Page kích thước mặc định 16KB. Khi một hàng hoặc một Index Key quá lớn, nó sẽ gây ra hiện tượng phân mảnh và tràn trang (Off-page storage). Để tìm kiếm từ khóa trong bài viết, giải pháp chuẩn mực là dùng **FULLTEXT Index** (sử dụng cấu trúc Inverted Index tối ưu cho văn bản) hoặc tách tìm kiếm sang các Search Engine chuyên dụng như Elasticsearch, thay vì đánh B-Tree Index truyền thống.
