# Giai thich su thieu hut cot damage_fee trong DB cu

Trong luong nghiep vu tra xe thuc te:
- Sau khi nhan vien kiem tra xe (Inspection) va phat hien hu hong, he thong phai tru tien boi thuong vao tien coc:
  Refund = security_deposit - late_fee - damage_fee

CSDL cu khong co cot `damage_fee` dan den:
1. He thong khong luu duoc so tien phat hu hong ma chi tinh phi thue xe thong thuong. Khach van nhan lai toan bo tien coc, lam phong kham/cong ty bi that thoat chi phi sua chua.
2. Thieu nhat quan giua bien ban kiem tra xe va so sach ke toan. Nhan vien phai ghi tay ra ngoai, de xay ra sai lech so lieu doi soat.

Vi vay, cot `damage_fee` voi kieu du lieu `DECIMAL(10,2)` la bat buoc de dong bo hoan toan voi Activity Diagram.