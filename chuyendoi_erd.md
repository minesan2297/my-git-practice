Báo Cáo Chuyển Đổi Mô Hình ERD Sang Mô Hình Quan Hệ

Bước 1: Xác định các thực thể và thuộc tính
Dựa trên sơ đồ ERD đã cho, hệ thống bao gồm 5 thực thể chính:
1. **PHIEUXUAT (Phiếu xuất):**
   - Thuộc tính khóa chính: `SoPX`
   - Thuộc tính mô tả: `NgayXuat`
2. **VATTU (Vật tư):**
   - Thuộc tính khóa chính: `MaVTU`
   - Thuộc tính mô tả: `TenVTU`
3. **PHIEUNHAP (Phiếu nhập):**
   - Thuộc tính khóa chính: `SoPN`
   - Thuộc tính mô tả: `NgayNhap`
4. **DONDH (Đơn đặt hàng):**
   - Thuộc tính khóa chính: `SoDH`
   - Thuộc tính mô tả: `NgayDH`
5. **NHACC (Nhà cung cấp):**
   - Thuộc tính khóa chính: `MaNCC`
   - Thuộc tính mô tả: `TenNCC`, `DiaChi`
   - Thuộc tính đa trị: `SDT`

---

Bước 2: Xác định và xử lý các mối quan hệ (1-1, 1-N, N-N)
1. **Mối quan hệ 1 (Chi tiết phiếu xuất):**
   - Bản số: Nhiều - Nhiều ($N - N$) giữa `PHIEUXUAT` và `VATTU`.
   - Xử lý: Tạo bảng trung gian `ChiTietPhieuXuat`, lấy khóa chính của 2 bảng làm khóa ngoại và chứa các thuộc tính riêng của mối quan hệ (`DGXuat`, `SLXuat`).
2. **Mối quan hệ 2 (Chi tiết phiếu nhập):**
   - Bản số: Nhiều - Nhiều ($N - N$) giữa `PHIEUNHAP` và `VATTU`.
   - Xử lý: Tạo bảng trung gian `ChiTietPhieuNhap`, lấy khóa chính của 2 bảng làm khóa ngoại và chứa các thuộc tính riêng của mối quan hệ (`DGNhap`, `SLNhap`).
3. **Mối quan hệ 3 (Chi tiết đơn đặt hàng):**
   - Bản số: Nhiều - Nhiều ($N - N$) giữa `DONDH` và `VATTU`.
   - Xử lý: Tạo bảng trung gian `ChiTietDonDatHang`, gồm khóa chính của 2 bảng kết hợp làm khóa chính tổng hợp.
4. **Mối quan hệ 4 (Cung cấp):**
   - Bản số: Một - Nhiều ($1 - N$) giữa `NHACC` và `DONDH` (Một nhà cung cấp có thể cung cấp nhiều đơn đặt hàng).
   - Xử lý: Thêm khóa ngoại `MaNCC` vào bảng phía nhiều là bảng `DONDH`.

---

Bước 3: Tách thuộc tính đa trị
- Thuộc tính `SDT` (Số điện thoại) của thực thể `NHACC` là thuộc tính đa trị (biểu diễn bằng 2 vòng elip lồng nhau).
- Xử lý: Tách thành bảng riêng đặt tên là `NhaCungCap_SDT` gồm 2 thuộc tính (`MaNCC`, `SDT`) để đảm bảo dạng chuẩn 1NF (First Normal Form).

---

Bước 4: Danh sách các bảng sau khi chuyển đổi hoàn chỉnh

1. **PhieuXuat** (<u>SoPX</u>, NgayXuat)
2. **VatTu** (<u>MaVTU</u>, TenVTU)
3. **PhieuNhap** (<u>SoPN</u>, NgayNhap)
4. **NhaCungCap** (<u>MaNCC</u>, TenNCC, DiaChi)
5. **NhaCungCap_SDT** (<u>MaNCC</u>, <u>SDT</u>)
   - `MaNCC` là Foreign Key tham chiếu đến `NhaCungCap(MaNCC)`
6. **DonDatHang** (<u>SoDH</u>, NgayDH, MaNCC)
   - `MaNCC` là Foreign Key tham chiếu đến `NhaCungCap(MaNCC)`
7. **ChiTietPhieuXuat** (<u>SoPX</u>, <u>MaVTU</u>, DGXuat, SLXuat)
   - `SoPX` là Foreign Key tham chiếu đến `PhieuXuat(SoPX)`
   - `MaVTU` là Foreign Key tham chiếu đến `VatTu(MaVTU)`
8. **ChiTietPhieuNhap** (<u>SoPN</u>, <u>MaVTU</u>, DGNhap, SLNhap)
   - `SoPN` là Foreign Key tham chiếu đến `PhieuNhap(SoPN)`
   - `MaVTU` là Foreign Key tham chiếu đến `VatTu(MaVTU)`
9. **ChiTietDonDatHang** (<u>SoDH</u>, <u>MaVTU</u>)
   - `SoDH` là Foreign Key tham chiếu đến `DonDatHang(SoDH)`
   - `MaVTU` là Foreign Key tham chiếu đến `VatTu(MaVTU)`