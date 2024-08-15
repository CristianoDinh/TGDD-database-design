-- TẠO DATABASE, TABLE = CÂU LỆNH SQL
--drop database THEGIOIDIDONG_OFFICAL
--CREATE DATABASE THEGIOIDIDONG_OFFICAL_new

--Quan hệ 1-M . Tạo 1 trước rồi thêm vào M PrimaryKey của 1 ĐỂ LÀM ForeignKey
--Quan hệ M-M . Tạo bảng mới gồm 2Key của 2 M làm PRIMARY KEY. Sau đó thêm thuộc tính sinh ra từ Quan hệ


--Quan hệ 1-M: NhaCungCap(1), XuatXu(1), CongTy(1)  - Danh Muc (M)
CREATE TABLE NhaCungCap
(
	MaNCC varchar(50) PRIMARY KEY NOT NULL,
	TenNCC nvarchar(150),
	SDT varchar(20),
	Email nvarchar(150),
	DiaChi nvarchar(250)
)

CREATE TABLE XuatXu
(
	MaXX varchar(50) PRIMARY KEY NOT NULL,
	TenXX nvarchar(150) 
)


--Quan hệ M: Danh mục
CREATE TABLE DanhMuc
(
	MaDM	 int PRIMARY KEY NOT NULL ,
	TenDM	 nvarchar(150),
	--CONSTRAINT PK_MaDM PRIMARY KEY (MaDM)
	MaNCC    varchar(50) FOREIGN KEY REFERENCES NhaCungCap(MaNCC)
)


--Quan Hệ 1-M: Tồn kho(1) - Chứng từ(M)
CREATE TABLE TonKho
(
	MaKho  varchar(50) PRIMARY KEY NOT NULL,
	DiaChi nvarchar(250)
)

CREATE TABLE ChungTu
(
	MaChungTu	varchar(50) PRIMARY KEY NOT NULL,
	LoaiChungTu	nvarchar(50),
	NgayNhapKho	datetime,
	NgayXuatKho	datetime,
	TrangThai	char(1),
	
)

--Quan hệ M-M: Chứng từ(M) - Danh Mục(M)  => Chứng từ chi tiết
CREATE TABLE ChungTuChiTiet
(
	MaChungTu	varchar(50) FOREIGN KEY REFERENCES ChungTu(MaChungTu),
	MaDM		int FOREIGN KEY REFERENCES DanhMuc(MaDM),
	PRIMARY KEY (MaChungTu,MaDM),
	------------- thuộc tính phát sinh ---------------
	SoLuong		int,
	DonGia		decimal(18,3),
)



--Quan hệ 1-M: DanhMuc(1),Hãng(1) - Sản Phẩm(M)
CREATE TABLE Hang
(
	MaHang	int	NOT NULL PRIMARY KEY,
	TenHang	nvarchar(50)
)

CREATE TABLE Loai
(
	MaLoai	int PRIMARY KEY NOT NULL,
	Ten		nvarchar(150),
	MaDM	int FOREIGN KEY REFERENCES DanhMuc(MaDM)
)

CREATE TABLE SanPham
(
	MaSP		varchar(50) PRIMARY KEY NOT NULL,
	TenSP		nvarchar(150),
	MaDM   int FOREIGN KEY REFERENCES DanhMuc(MaDM),
	MaHang int FOREIGN KEY REFERENCES Hang(MaHang),
	MaLoai	int FOREIGN KEY REFERENCES Loai(MaLoai),
	MaXX varchar(50) FOREIGN KEY REFERENCES XuatXu(MaXX),
	SoLuong		int,
	Gia			money,
	MauSac		nvarchar(150),
	ThongSoKiThuat	nvarchar(250),
	BaoHanh		int,
	tbSao		decimal(2,1),
	NgayTao		datetime,
	TinhTrang	char(1),
	NgayBoSungGanNhat	datetime,
	HOT			bit
	----------------------
)

--Quan hệ 1-M: Sản Phẩm(1) - HinhAnh(M)
CREATE TABLE HinhAnh
(
	MaHA	varchar(50) PRIMARY KEY NOT NULL,
	TenHA	nvarchar(150),
	DuongDan	nvarchar(200),
	----------------------------------
	MaSP	varchar(50) FOREIGN KEY REFERENCES SanPham(MaSP)
)

--Quan hệ M-M: Tồn Kho(M) - Sản Phẩm(M)  => SảnPhẩm TrongKho
CREATE TABLE SanPhamTrongKho 
(
	MaSP   varchar(50) FOREIGN KEY REFERENCES SanPham(MaSP) ,
	MaKho  varchar(50) FOREIGN KEY REFERENCES TonKho(MaKho),
	PRIMARY KEY (MaSP,MaKho),
	------------- thuộc tính phát sinh ---------------
	Soluong int
)

create table GiamGia
(
 	maGG varchar(50) not null primary key,
	ten nvarchar(50),
	phanTram decimal(3,2)

)
--Quan hệ 1-M: GiamGia(1) - GiamGiaSP_TonKho(M), GiamGia_Vip(M), GiamGia_NgayDacBiet(M) 
CREATE TABLE GiamGiaSP_TonKho (
	maGG varchar(50) not null primary key,
	ten nvarchar(50),
	soluong int,
	phanTram decimal(3,2)
)
CREATE TABLE SPDuocGiamGia
(
	maGG varchar(50) FOREIGN KEY REFERENCES GiamGiaSP_TonKho(maGG),
	MaSP	varchar(50) FOREIGN KEY REFERENCES SanPham(MaSP),
	Primary key (maGG, MaSp)
)
CREATE TABLE GiamGia_Vip (
	maGG varchar(50) not null primary key,
	ten nvarchar(50),
	loaiVip nvarchar(50),
	phanTram decimal(3,2) 
)
CREATE TABLE GiamGia_NgayDacBiet (
	maGG varchar(50) not null primary key,
	ten nvarchar(50),
	ngayDB date,
	phanTram decimal(3,2)
)

--Quan hệ M-M: Giảm Giá(M) - Khách Hàng(M)  => Đặc Quyền
CREATE TABLE XepLoaiVip
(
	MaVip		varchar(50) PRIMARY KEY NOT NULL,
	KhoangDiem	int,
	Hang		nvarchar(30),
	maGGVip		varchar(50) FOREIGN KEY REFERENCES GiamGia_Vip(maGG)
	---------------- thuộc tính Khóa Ngoại lấy từ PK của Table Khách Hàng ----------------
)
CREATE TABLE KhachHang
(
	MaKH	  varchar(50) PRIMARY KEY NOT NULL,
	MaVip	varchar(50) FOREIGN KEY REFERENCES XepLoaiVip(MaVip),
	HoTenKH	  nvarchar(150),
	SDT		  varchar(20) UNIQUE,
	DiaChi	  nvarchar(250),
	GioiTinh  nvarchar(50),
	TongDiemTichLuy int
)


--Quan hệ M-M-M: Khách Hàng(M) - Đánh Giá(M) - Sản Phẩm(M) => Khách Hàng Đánh Giá Sản Phẩm
CREATE TABLE KhachHangDanhGiaSP 
(
	MaKH	    varchar(50) FOREIGN KEY REFERENCES KhachHang(MaKH),
	MaSP		varchar(50) FOREIGN KEY REFERENCES SanPham(MaSP),
	PRIMARY KEY(MaKH,MaSP),
	------------- thuộc tính phát sinh ---------------
	soSao       int,
	BinhLuan	nvarchar(200)
)

---------------------------------------------------------------
-----------------------------------------------------------------

--Quan hệ 1-M: Nhân Viên(1) - Người Phụ Thuộc(M) : 
CREATE TABLE NhanVien
(
	MaNV	 varchar(50) PRIMARY KEY NOT NULL,
	TenNV	 nvarchar(150),
	ChucDanh nvarchar(150),
	NgaySinh datetime,
	SDT		 varchar(20),
	DiaChi	 nvarchar(250),
	Email	 nvarchar(150),
	NgayBatDauLam	datetime,
	HinhAnh	 image,
	GhiChu	 nvarchar(200)

)
-- ĐỐI VỚI THỰC THỂ YẾU 1-M
-- Thêm PK của 1 vào M làm thuộc tính Khóa Ngoại giống 1-M thông thường,
-- nhưng thuộc tính Khóa Ngoại đó cũng là Primary key => có 2 Primary key
CREATE TABLE NguoiPhuThuoc
(
	TenNPT nvarchar(150),
	TenMQH nvarchar(50),
	GioiTinh nvarchar(50),
	NgaySinh datetime,
	---------------------lấy PK của Table 1 làm thuộc tính khóa Ngoại cho Table M---------------------
	MaNV varchar(50) FOREIGN KEY REFERENCES NhanVien(MaNV)
	---------------TH Đặc biệt Khóa Ngoại này cũng chính là Khóa Chính ---------------
	PRIMARY KEY (MaNV,TenNPT)
)


CREATE TABLE PhuongThucThanhToan
(
	MaPTTT varchar(50) PRIMARY KEY NOT NULL,
	TenPTTT nvarchar(150),
	---------------- thuộc tính Khóa Ngoại lấy từ PK của Table Hóa Đơn ----------------
	------thuộc tính phát sinh của 1-1 -------------------
	--------------- Khóa của 1-M --------------------------------
)

--Quan hệ 1-1: Hóa Đơn(1) - Chứng từ(1) ||  Đưa Key của bên bất kì cho bên kia làm thuộc tính Khóa ngoại
--Trong thực tế, Hóa đơn sẽ gồm thông tin mua hàng chi tiết và Chứng Từ đi kèm -> đưa Key của Chứng từ vào Hóa Đơn
--------------- KẾT HỢP VỚI ---------------
--Quan hệ 1-M: Khách Hàng		 (1) - Hóa Đơn(M) 
--Quan hệ 1-M: Nhân Viên		 (1) - Hóa Đơn(M) 
--Quan hệ 1-M: Thông Tin Liên Hệ (1) - Hóa Đơn(M) 
CREATE TABLE HoaHong
(
	MaHoaHong varchar(50) PRIMARY KEY NOT NULL,
	MucTien	  money,
	PhanTram  decimal(3,2),
	---------------- thuộc tính Khóa Ngoại lấy từ PK của Table Hóa Đơn ----------------
)
CREATE TABLE HoaDon
(
	MaHoaDon varchar(50) PRIMARY KEY NOT NULL,
	MaKH	  varchar(50) FOREIGN KEY REFERENCES KhachHang(MaKH),
	MaNV	  varchar(50) FOREIGN KEY REFERENCES NhanVien(MaNV),
	TongTien money,
	VAT decimal(3,1),
	maGG_NgayDB varchar(50) FOREIGN KEY REFERENCES GiamGia_NgayDacBiet(maGG),
	maGG_Vip varchar(50) FOREIGN KEY REFERENCES GiamGia_Vip(maGG),
	GiamGia decimal(3,2),
	ThanhTien money,
	DiemTichLuy int,
	GhiChu nvarchar(150),
	ThongTinLH nvarchar(200),
	NgayTaoHoaDon datetime,
	MaHoaHong varchar(50) FOREIGN KEY REFERENCES HoaHong(MaHoaHong),
	MaChungTu varchar(50) FOREIGN KEY REFERENCES ChungTu(MaChungTu),
	MaPTTT varchar(50) FOREIGN KEY REFERENCES PhuongThucThanhToan(MaPTTT)
)


--Quan hệ M-M: Sản Phẩm(M) - Hóa Đơn(M)  => Chi Tiết Hóa Đơn
CREATE TABLE ChiTietHoaDon
(
	MaHoaDon varchar(50) FOREIGN KEY REFERENCES HoaDon(MaHoaDon),
	MaSP	 varchar(50) FOREIGN KEY REFERENCES SanPham(MaSP),	
	PRIMARY KEY(MaHoaDon,MaSP),
	------------- thuộc tính phát sinh ---------------
	TenSP			nvarchar(150),
	SoLuong			int,
	TinhTrangDonHang nvarchar(150)
)



--Hãng
insert into Hang
values
(1, N'Apple'),(2, N'SamSung'),(3, N'OPPO'),(4, N'XIAOMI'),(5, N'VIVO'),(6, N'realme'),(7, N'Nokia'),(8, N'Mastel'),(9, N'mobell'),(10, N'itel'),(11, N'HP'),
(12, N'ASUS'),(13, N'ACER'),(14, N'Lenovo'),(15, N'DELL'),(16, N'MSI'),(17, N'MacBook'),(18, N'GiGaByte'),(19, N'Surface'),(20, N'Masstel'),
(21, N'LG'),(22, 'TCL'),(23, 'HONOR'),(24, 'Panasonic'),(25, 'Razer'),(26, 'Logitech'),(27, 'SONY'),(28, 'SanDisk'),(29, 'G-SHOCK'),
(30, 'CASIO'), (31, 'CANON'), (32, 'Befit'), (33, 'Dareu')

--Nha Cung Cap
insert into NhaCungCap
values
('NCC01', 'CellphoneS', '(028) 7108 9666', 'cskh@cellphones.com.vn', N'350-352 Võ Văn Kiệt, Phường Cô Giang, Quận 1, Thành phố Hồ Chí Minh, Việt Nam'),
('NCC02', 'FPT Shop', '(028) 7302 3456', 'fptshop@fpt.com', N'261 - 263 Khánh Hội, P2, Q4, TP. Hồ Chí Minh'),
('NCC03', N'Điện Máy Xanh', '028 38125960', 'cskh@thegioididong.com', N'128 Trần Quang Khải, P.Tân Định, Q.1, TP.Hồ Chí Minh'),
('NCC04', N'HP', '1800 58 88 68', 'cskh@hp.com', N'Suite 1002, 29 Le Duan, Saigon Tower, 10th floor, District 1,P.C.,Ho Chi Minh City,Viet Nam'),
('NCC05', 'ITToday', '0973836600', 'info@ittoday.com', N'Số 47 - Ngõ 207 Xuân Đỉnh - Q.Bắc Từ Liêm - TP.Hà Nội'),
('NCC06', 'Apple', '1800 1192', 'info@apple.com', N'180 Đ. Hoàng Văn Thụ, Phường 9, Phú Nhuận, Thành phố Hồ Chí Minh'),
('NCC07',N'Hải Triều','1900 6777','info@haitrieu.com',N'160 Âu Cơ, P.9, Q.Tân Bình – TP.HCM'),
('NCC08',N'Vietel Store','1900 8096','cskh@vietelstore.com',N'Số 01, Phố Giang Văn Minh, phường Kim Mã, quận Ba Đình, Thành phố Hà Nội.')

--GiamGia
Insert into GiamGia(maGG,ten,phanTram)
values 
(N'GGTK01',N'Giảm giá sản phẩm tồn kho từ 100 món hàng',0.05),
(N'GGTK02',N'Giảm giá sản phẩm tồn kho từ 200 món hàng',0.08),
(N'GGTK03',N'Giảm giá sản phẩm tồn kho từ 500 món hàng',0.1),
(N'GGTK04',N'Giảm giá sản phẩm tồn kho từ 800 món hàng',0.18),
(N'GGV01',N'Giảm giá sản phẩm cho khách hàng kim cương',0.35),
(N'GGV02',N'Giảm giá sản phẩm cho khách hàng bạch kim',0.26),
(N'GGV03',N'Giảm giá sản phẩm cho khách hàng vàng',0.18),
(N'GGV04',N'Giảm giá sản phẩm cho khách hàng bạc',0.11),
(N'GGV05',N'Giảm giá sản phẩm cho khách hàng đồng',0.08),
(N'GGNDB01',N'Giảm giá sản phẩm vào ngày Quốc tế phụ nữ',0.11),
(N'GGNDB02',N'Giảm giá sản phẩm vào ngày Quốc tế thiếu nhi',0.08),
(N'GGNDB03',N'Giảm giá sản phẩm vào ngày Lễ quốc khánh',0.18),
(N'GGNDB04',N'Giảm giá sản phẩm  cuối năm',0.35),
(N'GGNDB05',N'Giảm giá sản phẩm  đầu năm',0.26);

--GiamGiaSP_TonKho
Insert into GiamGiaSP_TonKho(maGG,ten,soluong,phanTram)
values 
(N'GGTK01',N'Giảm giá sản phẩm tồn kho từ 100 món hàng',100,0.05),
(N'GGTK02',N'Giảm giá sản phẩm tồn kho từ 200 món hàng',200,0.08),
(N'GGTK03',N'Giảm giá sản phẩm tồn kho từ 500 món hàng',500,0.1),
(N'GGTK04',N'Giảm giá sản phẩm tồn kho từ 800 món hàng',800,0.18);

--GiamGiaVip
Insert into GiamGia_Vip(maGG,ten,loaiVip,phanTram)
values 
(N'GGV01',N'Giảm giá sản phẩm cho khách hàng kim cương',N'Kim Cương',0.35),
(N'GGV02',N'Giảm giá sản phẩm cho khách hàng bạch kim',N'Bạch Kim',0.26),
(N'GGV03',N'Giảm giá sản phẩm cho khách hàng vàng',N'Vàng',0.18),
(N'GGV04',N'Giảm giá sản phẩm cho khách hàng bạc',N'Bạc',0.11),
(N'GGV05',N'Giảm giá sản phẩm cho khách hàng đồng',N'Bạc',0.08);

--GiamGiaNgayDB
Insert into GiamGia_NgayDacBiet(maGG,ten,ngayDB,phanTram)
values 
(N'GGNDB01',N'Giảm giá sản phẩm vào ngày Quốc tế phụ nữ','2000-3-8',0.11),
(N'GGNDB02',N'Giảm giá sản phẩm vào ngày Quốc tế thiếu nhi','2000-6-1',0.08),
(N'GGNDB03',N'Giảm giá sản phẩm vào ngày Lễ quốc khánh','2000-9-2',0.18),
(N'GGNDB04',N'Giảm giá sản phẩm  cuối năm','2000-12-1',0.35),
(N'GGNDB05',N'Giảm giá sản phẩm  đầu năm','2000-12-1',0.26);
--XepLoaiVip
insert into XepLoaiVip(MaVip,KhoangDiem,Hang, maGGVip) values (N'V1',5800,N'Kim Cương','GGV01');
insert into XepLoaiVip(MaVip,KhoangDiem,Hang, maGGVip) values (N'V2',2600,N'Bạch Kim','GGV02');
insert into XepLoaiVip(MaVip,KhoangDiem,Hang, maGGVip) values (N'V3',1800,N'Vàng','GGV03');
insert into XepLoaiVip(MaVip,KhoangDiem,Hang, maGGVip) values (N'V4',1100,N'Bạc','GGV04');
insert into XepLoaiVip(MaVip,KhoangDiem,Hang, maGGVip) values (N'V5',800,N'Đồng','GGV05');

--KhachHang
insert into KhachHang
values
('KH001', 'V3', N'Trương Bảo Ngọc', '096 142 5777', N'123 Nguyễn Văn Tăng phường Hiệp Bình quận Tân Phú', 'F', 2200),
('KH002', 'V2', N'Lưu Minh Quân', '096 191 5182', N'123 Nguyễn Văn Tăng phường Hiệp Bình quận 12', 'M', 4800),
('KH003', 'V1', N'Đinh Gia Bảo', '038 514 8672', N'123 Nguyễn Văn Tăng phường Hiệp Bình quận Thủ Đức', 'M', 5900),
('KH004', 'V1', N'Hoàng Nguyễn Minh Hiếu', '096 142 5217', N'123 Nguyễn Văn Tăng phường Hiệp Bình quận 2', 'M', 9700),
('KH005', 'V3', N'Lê Vĩnh Phát', '096 510 2465', N'123 Nguyễn Văn Tăng phường Hiệp Bình quận 12', 'M', 2200),
('KH006', 'V4', N'Nguyễn Đức Thắng', '091 166 877', N'123 Nguyễn Văn Tăng phường Hiệp Bình quận 10', 'M', 1500),
('KH007', null, N'Đặng Thị Huệ', '032 696 5055', N'609/36/1/17 KP4 Nguyễn Ảnh Thủ phường Hiệp Bình quận 9', 'F', 600),
('KH008', 'V4', N'Nguyễn Thị B', '091 109 877', N'153 A Nguyễn Văn Tăng phường Hiệp Bình quận Bình Chánh', 'F', 1500),
('KH009', 'V5', N'Phan Gia Huy', '078 566 3033', N'16C QL1A Nguyễn Văn Linh phường Hiệp Bình quận 7', 'M', 810),
('KH010', null, N'Trương Gia A', '078 123 6789', N'16D QL1B Trần Hoàng Định phường Hiệp Bình quận 6', 'M', 210),
('KH011', 'V2', N'Nguyễn Thị Hương', '096 345 7890', N'789 Nguyễn Văn Linh phường Tân Phong quận 7', 'F', 3800),
('KH012', 'V3', N'Hoàng Văn Nam', '093 987 6543', N'456 Nguyễn Thị Minh Khai phường Đa Kao quận 1', 'M', 2700),
('KH013', 'V1', N'Trần Thị Lan', '091 456 3210', N'321 Lê Lợi phường Bến Thành quận 1', 'F', 4200),
('KH014', 'V2', N'Lê Văn B', '097 234 5678', N'654 Phạm Ngũ Lão phường Nguyễn Cư Trinh quận 1', 'M', 3100),
('KH015', 'V3', N'Nguyễn Thị Mỹ Linh', '090 876 5432', N'987 Lê Thánh Tôn phường Bến Nghé quận 1', 'F', 1800),
('KH016', null, N'Phạm Văn C', '092 135 7928', N'159 Lê Lai phường Phạm Ngũ Lão quận 1', 'M', 290),
('KH017', 'V3', N'Trần Thị An', '098 765 4121', N'246 Nguyễn Công Trứ phường Nguyễn Thái Bình quận 1', 'F', 2400),
('KH018', null, N'Đinh Văn D', '095 246 8109', N'753 Nguyễn Thái Học phường Cầu Kho quận 1', 'M', 300),
('KH019', 'V2', N'Nguyễn Thị G', '094 678 1234', N'852 Nguyễn Văn Cừ phường Nguyễn Cư Trinh quận 1', 'F', 4300),
('KH020', null, N'Lê Văn Khoa', '099 321 6547', N'963 Hai Bà Trưng phường Bến Nghé quận 1', 'M', 390),
('KH021', 'V2', N'Nguyễn Thị Nhung', '097 876 5432', N'369 Lê Lai phường Bến Thành quận 1', 'F', 5200),
('KH022', 'V5', N'Hoàng Văn Dũng', '094 234 5678', N'456 Nguyễn Huệ phường Nguyễn Thái Bình quận 1', 'M', 900),
('KH023', 'V2', N'Đỗ Thị H', '093 123 4567', N'987 Lê Lợi phường Phạm Ngũ Lão quận 1', 'F', 3800),
('KH024', null, N'Trần Văn T', '098 765 4321', N'654 Đề Thám phường Bến Thành quận 1', 'M', 610),
('KH025', 'V3', N'Lê Thị N', '091 876 5432', N'321 Nguyễn Du phường Bến Thành quận 1', 'F', 1800),
('KH026', 'V2', N'Nguyễn Văn E', '092 345 6789', N'159 Nguyễn Trãi phường Phạm Ngũ Lão quận 1', 'M', 2900),
('KH027', 'V2', N'Trần Thị D', '095 678 1234', N'246 Lê Lợi phường Bến Thành quận 1', 'F', 2400),
('KH028', null, N'Đinh Văn F', '096 246 8109', N'753 Đề Thám phường Nguyễn Thái Bình quận 1', 'M', 360),
('KH029', 'V2', N'Nguyễn Thị H', '097 678 1234', N'852 Nguyễn Huệ phường Nguyễn Cư Trinh quận 1', 'F', 4300),
('KH030', 'V2', N'Lê Văn L', '098 321 6547', N'963 Đề Thám phường Bến Thành quận 1', 'M', 3900);

--XuatXu
INSERT INTO XuatXu(MaXX,TenXX) VALUES ('US','USA')
INSERT INTO XuatXu(MaXX,TenXX) VALUES ('UK','United Kingdom')
INSERT INTO XuatXu(MaXX,TenXX) VALUES ('SK','South Korea')
INSERT INTO XuatXu(MaXX,TenXX) VALUES ('BR','Brazil')
INSERT INTO XuatXu(MaXX,TenXX) VALUES ('VN','VietNam')
INSERT INTO XuatXu(MaXX,TenXX) VALUES ('ID','Indonesia')
INSERT INTO XuatXu(MaXX,TenXX) VALUES ('MS','Malaysia')
INSERT INTO XuatXu(MaXX,TenXX) VALUES ('SP','Singapore')
INSERT INTO XuatXu(MaXX,TenXX) VALUES ('TL','ThaiLand')
INSERT INTO XuatXu(MaXX,TenXX) VALUES ('TW','DaiLoan')
INSERT INTO XuatXu(MaXX,TenXX) VALUES ('CN','China')
INSERT INTO XuatXu(MaXX,TenXX) VALUES ('JP','Japan')

--NhanVien

INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu) 
VALUES ('NV01', 'Mai Duy An', N'Nhân viên bán hàng', '1990-05-15', '0987654321', '123 Dong Den street, HCM City, VietNam', 'maiduyan@gmail.com', '2019-01-01', 'path/to/image1.jpg', N'Ghi chú nếu có');
INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu) 
VALUES ('NV11', N'Nguyễn Minh Ngọc', N'Nhân viên bán hàng', '1996-12-15', '0987153211', '16A Big street, HCM City, VietNam', 'CR7@gmail.com', '2010-01-01', 'path/to/image11.jpg', N'Ghi chú nếu có');
INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu) 
VALUES ('NV12', N'Lưu Minh Quân', N'Nhân viên bán hàng', '2004-11-16', '0785663033', '123 Nguyen Anh Thu street, HCM City, VietNam', 'quanlmse@gmail.com', '2023-07-10', 'path/to/image12.jpg', N'Ghi chú nếu có');
INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu) 
VALUES ('NV02', 'Nguyen Van B', N'Kế toán', '1988-08-20', '0901234567', '456 Nguyen Hue street, Hanoi, VietNam', 'nguyenvanb@gmail.com', '2018-02-15', 'path/to/image2.jpg', N'Ghi chú kế toán');
INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu) 
VALUES ('NV03', 'Tran Thi C', N'Nhân sự', '1995-03-10', '0978123456', '789 Le Loi street, Da Nang, VietNam', 'tranthic@gmail.com', '2020-10-05', 'path/to/image3.jpg', N'Ghi chú nhân sự');
INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu) 
VALUES ('NV04', 'Hoang Minh D', N'Trưởng phòng', '1985-12-25', '0912345678', '159 Le Duan street, HCM City, VietNam', 'hoangminhd@gmail.com', '2015-07-20', 'path/to/image4.jpg', N'Ghi chú trưởng phòng');
INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu) 
VALUES ('NV05', 'Le Van E', N'Kỹ thuật viên', '1992-09-18', '0988888888', '246 Pham Van Dong street, Hue, VietNam', 'levane@gmail.com', '2017-04-30', 'path/to/image5.jpg', N'Ghi chú kỹ thuật viên');
INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu) 
VALUES ('NV06', 'Nguyen Thi F', N'Thư ký', '1997-07-05', '0909999999', '369 Vo Van Tan street, HCM City, VietNam', 'nguyenthif@example.com', '2019-12-10', 'path/to/image6.jpg', N'Ghi chú thư ký');
INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu) 
VALUES ('NV07', 'Tran Van G', N'Bảo vệ', '1980-01-30', '0933333333', '147 Vo Thi Sau street, Nha Trang, VietNam', 'tranvang@gmail.com', '2016-09-25', 'path/to/image7.jpg', N'Ghi chú bảo vệ');
INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu) 
VALUES ('NV08', 'Pham Thi H', N'Nhân viên bán hàng', '1993-06-12', '0944444444', '258 Nguyen Trai street, HCM City, VietNam', 'phamthih@gmail.com', '2020-03-15', 'path/to/image8.jpg', N'Ghi chú nhân viên bán hàng');
INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu) 
VALUES ('NV09', 'Vo Van I', N'Quản lý sản xuất', '1983-11-08', '0955555555', '369 Nguyen Dinh Chieu street, Can Tho, VietNam', 'vovani@gmail.com', '2018-08-20', 'path/to/image9.jpg', N'Ghi chú quản lý sản xuất');
INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu)
VALUES ('NV10', 'Tran Van K', N'Kế toán trưởng', '1975-04-15', '0966666666', '123 Le Thanh Ton street, HCM City, VietNam', 'tranvank@gmail.com', '2014-05-01', 'path/to/image10.jpg', N'Ghi chú kế toán trưởng');
INSERT INTO NhanVien (MaNV, TenNV, ChucDanh, NgaySinh, SDT, DiaChi, Email, NgayBatDauLam, HinhAnh, GhiChu)
VALUES ('NV11', 'Cristiano Dinh', N'Nhân viên giao hàng', '2003-12-21', '0966444666', '954 High Way street, HCM City, VietNam', 'CrDinh@gmail.com', '2022-04-30', 'path/to/image11.jpg', N'Ghi chú');

--ChungTu
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM001',N'Nhập Kho','2010-04-16 23:59:59',null,N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHN001',N'Nhập Kho','2020-05-16 23:50:51',null,N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTCT001',N'Nhập Kho','2010-03-16 23:59:59',null,N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM002',N'Nhập Kho','2010-05-16 23:09:59',null,N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM006',N'Xuất Kho',null,'2010-04-16 13:09:00',N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM003',N'Xuất Kho',null,'2011-04-16 12:09:00',N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM004',N'Xuất Kho',null,'2010-04-16 13:09:00',N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM005',N'Xuất Kho',null,'2010-04-16 13:09:00',N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM007',N'Xuất Kho',null,'2010-04-16 13:09:00',N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTDN001',N'Xuất Kho',null,'2010-04-16 13:09:00',N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM011',N'Xuất Kho',null,'2010-04-16 13:09:00',N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM010',N'Xuất Kho',null,'2010-04-16 13:09:00',N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM008',N'Xuất Kho',null,'2010-04-16 13:09:00',N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM015',N'Xuất Kho',null,'2010-04-16 13:09:00',N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM016',N'Xuất Kho',null,'2010-04-16 13:09:00',N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM013',N'Nhập Kho','2015-04-16 11:59:00',null,N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM014',N'Nhập Kho','2010-04-16 23:59:59',null,N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM055',N'Nhập Kho','2010-04-16 23:59:59',null,N'T');
Insert into ChungTu(MaChungTu,LoaiChungTu,NgayNhapKho,NgayXuatKho,TrangThai) values (N'CTHCM066',N'Nhập Kho','2010-04-16 23:59:59',null,N'T');

--Người Phụ Thuộc
Insert into NguoiPhuThuoc values(N'Vương Thị Kim Cúc', 'Em', 'F', '1978-03-20', 'NV01');
Insert into NguoiPhuThuoc values(N'Phạm Nguyên Dũng', N'Chồng', 'M', '1965-04-16', 'NV08');
Insert into NguoiPhuThuoc values(N'Nguyễn Thị Minh Hằng', N'Vợ', 'F', '2000-05-16', 'NV02');
Insert into NguoiPhuThuoc values(N'Nguyễn Thị Thùy Dung', N'Mẹ', 'F', '1953-10-01', 'NV04');
Insert into NguoiPhuThuoc values(N'Hồ Đức Trung Hữu', N'Bố', 'M', '1960-04-16', 'NV11');
Insert into NguoiPhuThuoc values(N'Nguyễn Thạc Hải', N'Anh', 'M', '1988-09-17', 'NV04');

--PhuongThucThanhToan
INSERT INTO PhuongThucThanhToan(MaPTTT,TenPTTT) VALUES ('TT01',N'Thẻ Ngân Hàng')
INSERT INTO PhuongThucThanhToan(MaPTTT,TenPTTT) VALUES ('TT02',N'Thẻ Mặt')
INSERT INTO PhuongThucThanhToan(MaPTTT,TenPTTT) VALUES ('TT03',N'Trả góp')

-- HOAHONG
insert dbo.HoaHong (MaHoaHong,MucTien,PhanTram) values ('HH01',2000000,0.03)
insert dbo.HoaHong (MaHoaHong,MucTien,PhanTram) values ('HH02',5000000,0.05)
insert dbo.HoaHong (MaHoaHong,MucTien,PhanTram) values ('HH03',100000000,0.10)
insert dbo.HoaHong (MaHoaHong,MucTien,PhanTram) values ('HH04',1000000000,0.15)


--Danh Muc
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (1,N'Điện Thoại','NCC01')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (2,N'Laptop','NCC02')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (3,N'Tablet','NCC06')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (4,N'SmartWatch','NCC02')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (5,N'Đồng hô','NCC07')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (6,N'Máy In','NCC03')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (7,N'Mực In','NCC03')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (8,N'Màn hình máy tính','NCC04')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (9,N'Máy tính để bàn','NCC04')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (10,N'Máy chơi game cầm tay','NCC01')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (11,N'Sim, Thẻ cào','NCC08')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (12,N'Sạc dự phòng','NCC01')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (13,N'Sạc, cáp','NCC01')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (14,N'Hub, cáp chuyển đổi','NCC02')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (15,N'Ốp lưng điện thoại','NCC01')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (16,N'Ốp lưng máy tính bảng','NCC06')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (17,N'Miếng dán','NCC02')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (18,N'Túi đựng AirPods','NCC06')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (19,N'Bàn phím, bút Tablet','NCC06')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (20,N'Giá đỡ điện thoại','NCC01')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (21,N'Tai nghe Bluetooth','NCC02')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (22,N'Tai nghe dây','NCC02')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (23,N'Loa','NCC03')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (24,N'Micro','NCC03')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (25,N'Chuột máy tính','NCC04')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (26,N'Bàn phím','NCC04')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (27,N'Thiết bị mạng','NCC05')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (28,N'Balo, túi chống sốc','NCC02')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (29,N'Giá đỡ laptop','NCC04')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (30,N'Phần mềm','NCC05')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (31,N'Camera trong nhà','NCC05')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (32,N'Camera ngoài trời','NCC05')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (33,N'Máy chiếu','NCC03')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (34,N'Ổ cứng di động','NCC08')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (35,N'Thẻ nhớ','NCC008')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (36,N'USB','NCC02')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (37,N'Pin tiểu','NCC03')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (38,N'Phụ kiện ô tô','NCC03')
insert dbo.DanhMuc (MaDM,TenDM,MaNCC) values (39,N'AirTag, Vỏ bảo vệ AirTag','NCC06')

--Ton Kho
insert dbo.TonKho (MaKho,DiaChi) values('STR01',N'Cụm 2-4, đường M14, Khu công nghiệp Tân Bình Mở Rộng, Q.Bình Tân, Hồ Chí Minh, 700000')
insert dbo.TonKho (MaKho,DiaChi) values('STR02',N'QRP9+87M, Phường Phú Hữu, Quận 9, Thành phố Hồ Chí Minh')
insert dbo.TonKho (MaKho,DiaChi) values('STR03',N'114 Đường M1, Bình Hưng Hoà, Bình Tân, Thành phố Hồ Chí Minh')
insert dbo.TonKho (MaKho,DiaChi) values('STR04',N'VM67+Q22, QL1A, Thới An, Quận 12, Thành phố Hồ Chí Minh')
insert dbo.TonKho (MaKho,DiaChi) values('STR05',N'Handee, 127 Lê Văn Chí, Phường Linh Trung, Thủ Đức, Thành phố Hồ Chí Minh 700000')
insert dbo.TonKho (MaKho,DiaChi) values('STR06',N'WMFW+P22, Binh Nhâm, Thuận An, Bình Dương')

--Loai
insert into Loai
 values
 (1,N'Android',1),
 (2,N'iOS',1),
 (3,N'Laptop Gaming',2),
 (4,N'Macbook',2),
 (5,N'Laptop học tập, văn phòng',2),
 (6,N'Laptop Đồ họa, Kỹ thuật',2),
 (7,N'Laptop Cao cấp, Sang trọng',2),
 (8,N'Tablet 7-8inch',3),
 (9,N'Tablet 9 inch',3),
 (10,N'Tablet 10 - 11 inch',3),
 (11,N'Tablet 12 inch trở lên',3),
 (12,N'Smartwatch Thời trang sành điệu',4),
 (13,N'Smartwatch Đa tiện ích',4),
 (14,N'Smartwatch Thể thao chuyên nghiệp',4),
 (15,N'Smartwatch Định vị trẻ em',4),
 (16,N'Dây đồng hồ Smartwatch',4),
 (17,N'Đồng hồ Nam',5),
 (18,N'Đồng hồ Nữ',5),
 (19,N'Đồng hồ trẻ em',5),
 (20,N'Đồng hồ cao cấp',5),
 (21,N'Đồng hồ đôi',5),
 (22,N'Máy in laser trắng đen',6),
 (23,N'Máy in phun trắng đen',6),
 (24,N'Máy in phun màu',6),
 (25,N'Máy in laser màu',6),
 (26,N'Mực in hộp',7),
 (27,N'Mực in phun',7),
 (28,N'Màn hình đồ họa',8),
 (29,N'Màn hình Gaming',8),
 (30,N'Màn hình văn phòng',8),
 (31,N'Màn hình di động',8),
 (32,N'All-in-One',9),
 (33,N'PC',9),
 (34,N'Sim số đẹp',11),
 (35,N'Thẻ điện thoại',11),
 (36,N'Thẻ game',11),
 (37,N'Nạp tiền trả trước',11),
 (38,N'Gói data 3G/4G',11),
 (39,N'Nạp tiền trả sau',11),
 (40,N'Dưới 10,000mAh',12),
 (41,N'10,000mAh',12),
 (42,N'20,000mAh',12),
 (43,N'Adapter sạc',13),
 (44,N'Cáp sạc',13),
 (45,N'Ốp iPhone',15),
 (46,N'Ốp Samsung',15),
 (47,N'Ốp OPPO',15),
 (48,N'Ốp Xiaomi',15),
 (49,N'Ốp Vivo',15),
 (50,N'Ốp Realme',15),
 (51,N'Ốp lưng iPad',16),
 (52,N'Ốp lưng Samsung Tab',16),
 (53,N'Dán mặt trước',17),
 (54,N'Dán mặt sau',17),
 (55,N'Miếng dán camera',17),
 (56,N'Miếng dán kính',17),
 (57,N'Miếng dán full màn hình',17),
 (58,N'Bộ dán Macbook',17),
 (59,N'AirPods Pro',18),
 (60,N'AirPods 1 & AirPods 2',18),
 (61,N'AirPods 3',18),
 (62,N'AirPods Pro 2',18),
 (63,N'Đế điện thoại xe hơi',20),
 (64,N'Đế điện thoại để bàn',20),
 (65,N'In-ear',21),
 (66,N'Earbuds',21),
 (67,N'Over-ear',21),
 (68,N'On-ear',21),
 (69,N'In-ear',22),
 (70,N'Earbuds',22),
 (71,N'Over-ear',22),
 (72,N'On-ear',22),
 (73,N'Loa Bluetooth',23),
 (74,N'Loa vi tính',23),
 (75,N'Loa Karaoke',23),
 (76,N'Dàn âm thanh',23),
 (77,N'Loa thanh',23),
 (78,N'Micro thu âm Podcast/LiveStream',24),
 (79,N'Micro Karaoke',24),
 (80,N'Chuột không dây',25),
 (81,N'Chuột Gaming',25),
 (82,N'Chuột Bluetooth',25),
 (83,N'Chuột có dây',25),
 (84,N'Bàn phím Gaming',26),
 (85,N'Bàn phím có dây',26),
 (86,N'Bàn phím không dây',26),
 (87,N'USB Wifi',27),
 (88,N'Router',27),
 (89,N'Bộ phát Wifi',27),
 (90,N'Repeater(Mở rộng sóng)',27),
 (91,N'Balo Laptop',28),
 (92,N'Túi chống sốc',28),
 (93,N'Đế Laptop/Macbook',29),
 (94,N'Office',30),
 (95,N'Diệt Virus',30),
 (96,N'Giải trí',30),
 (97,N'Windows',30),
 (98,N'Vietmap',30),
 (99,N'Ổ cứng HDD',34),
 (100,N'Ổ cứng SSD',34),
(101,N'USB 2.0',36),
 (102,N'USB Type C',36),
 (103,N'USB 3.0',36),
 (104,N'USB OTG',36),
 (105,N'USB 3.1',36),
 (106,N'USB 3.2',36),
 (107,N'Pin AA',37),
 (108,N'Pin AAA',37),
 (109,N'Cảm biến áp suất',38),
 (110,N'Định vị ô tô',38),
 (111,N'Màn hình hiển thị',38)

--ChungTuChiTiet
Insert into ChungTuChiTiet(MaChungTu,MaDM,SoLuong,DonGia)
values
(N'CTHCM001',1,350,350000000.00),
(N'CTHCM001',2,110,110000000.00),
(N'CTHCM001',3,200,260000000.00),
(N'CTHCM001',4,380,550000000.00),
(N'CTHCM001',5,260,150000000.00),
(N'CTHCM001',6,250,350000000.00),
(N'CTHCM001',7,110,110000000.00),
(N'CTHCM001',8,200,260000000.00),
(N'CTHCM001',9,380,550000000.00),
(N'CTHCM001',10,260,150000000.00),
(N'CTHCM002',1,350,330000000.00),
(N'CTHCM002',2,110,120000000.00),
(N'CTHCM002',3,200,260000000.00),
(N'CTHCM002',4,380,550000000.00),
(N'CTHCM002',5,260,150000000.00),
(N'CTHCM006',10,26,53000000.00),
(N'CTHCM006',1,35,33000000.00),
(N'CTHCM006',2,11,12000000.00),
(N'CTHCM006',3,20,66000000.00),
(N'CTHCM006',4,38,55000000.00),
(N'CTHCM006',5,26,5000000.00);

--SanPham
--DienThoai
insert dbo.SanPham(MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP001',N'Iphone 15 Pro Max', 1, 1, 2, 'CN',150,30990000,N'Titan Xanh', N'iOS 17
Apple A17 Pro 6 nhân, Ram: 8GB, Rom: 256GB', 12,4.7,CAST(N'2023-09-13T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham
values (N'SP002',N'Iphone 15 Pro Max', 1, 1, 2, 'US',150,30990000,N'Titan Đen', N'iOS 17
Apple A17 Pro 6 nhân, Ram: 8GB, Rom: 256GB', 12,4.7,CAST(N'2023-02-26T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham
values (N'SP003',N'Iphone 13',1, 1, 2, 'CN',100,15290000,N'Trắng', N'iOS 15 Apple A15 Bionic 6 nhân, Ram: 4GB, Rom: 128GB', 12,4.2,CAST(N'2021-10-30T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham
values (N'SP004',N'Iphone 13',1, 1, 2, 'TL',100,15290000,N'Đen', N'iOS 15 Apple A15 Bionic 6 nhân, Ram: 4GB, Rom: 128GB', 12,4.2,CAST(N'2021-09-15T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham 
values (N'SP005',N'Samsung Galaxy S24 Ultra 5G',1, 1, 1, 'SK',150,15290000,N'Đen', N'Android 14 Snapdragon 8 Gen 3 for Galaxy, Ram: 12GB, Rom: 256GB', 12,4.8,CAST(N'2024-01-17T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP006',N'Samsung Galaxy S24 Ultra 5G', 1, 1, 1, 'CN',100,15290000,N'Xám', N'Android 14 Snapdragon 8 Gen 3 for Galaxy, Ram: 12GB, Rom: 256GB', 12,4.8,CAST(N'2024-01-17T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham
values (N'SP007',N'Samsung A15 5G', 1, 1, 1, 'BR', 100,15290000,N'Đen', N'Android 14 MediaTek Dimensity 6100+, Ram: 8GB, Rom: 256GB', 12,3.8,CAST(N'2024-12-11T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham 
values (N'SP008',N'Samsung A15 5G', 1, 1, 1, 'ID',75,15290000,N'Xanh dương đậm', N'Android 14 MediaTek Dimensity 6100+, Ram: 8GB, Rom: 256GB', 12,3.8,CAST(N'2024-12-11T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham
values (N'SP009',N'Samsung Galaxy Z Flip5 5G', 1, 1, 1, 'VN',40,21990000,N'Xanh mint', N'Android 13 Snapdragon 8 Gen 2 for Galaxy, Ram: 8GB, Rom: 256GB', 12,4.0,CAST(N'2023-07-26T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP010',N'Samsung Galaxy Z Flip5 5G', 1, 1, 1, 'SP',40,21990000,N'Kem', N'Android 13 Snapdragon 8 Gen 2 for Galaxy, Ram: 8GB, Rom: 256GB', 12,4.0,CAST(N'2023-07-26T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP011',N'Xiaomi Redmi Note 13 Pro', 1, 4, 1, 'CN',60,6790000,N'Xanh lá', N'Android 13 MediaTek Helio G99-Ultra 8 nhân, Ram: 8GB, Rom: 128GB', 12,4.3,CAST(N'2023-09-21T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham 
values (N'SP012',N'Xiaomi Redmi Note 13 Pro', 1, 4, 1, 'CN',70,6790000,N'Tím', N'Android 13 MediaTek Helio G99-Ultra 8 nhân, Ram: 8GB, Rom: 128GB', 12,4.3,CAST(N'2023-09-21T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham
values (N'SP013',N'Xiaomi 13T Pro 5G', 1, 4, 1, 'US',140,14490000,N'Đen', N'Android 13 MediaTek Dimensity 9200+ 5G 8 nhân, Ram: 12GB, Rom: 256GB', 12,4.4,CAST(N'2023-09-26T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP014',N'Xiaomi 13T Pro 5G', 1, 4, 1, 'CN',110,14490000,N'Xanh lá', N'Android 13 MediaTek Dimensity 9200+ 5G 8 nhân, Ram: 12GB, Rom: 256GB', 12,4.4,CAST(N'2023-09-26T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP015',N'Xiaomi 14 5G', 1, 4, 1, 'CN',135,22990000,N'Đen', N'Android 14 Snapdragon 8 Gen 3, Ram: 12GB, Rom: 256GB', 12,4.7,CAST(N'2024-02-25T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham
values (N'SP016',N'Xiaomi 14 5G', 1, 4, 1, 'CN',100,22990000,N'Xanh lá', N'Android 14 Snapdragon 8 Gen 3, Ram: 12GB, Rom: 256GB', 12,4.7,CAST(N'2024-02-25T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham
values (N'SP017',N'OPPO Reno11 5G', 1, 3, 1, 'CN', 120,10690000,N'Xám', N'Android 14 MediaTek Dimensity 7050 5G 8 nhân, Ram: 8GB, Rom: 256GB', 12,4.5,CAST(N'2023-11-23T13:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham
values (N'SP018',N'OPPO Reno11 5G',1, 3, 1, 'CN',120,10690000,N'Xanh lá nhạt', N'Android 14 MediaTek Dimensity 7050 5G 8 nhân, Ram: 8GB, Rom: 256GB', 12,4.5,CAST(N'2023-11-23T13:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham
values (N'SP019',N'OPPO Reno10 Pro+ 5G',1, 3, 1, 'CN',100,19290000,N'Xanh', N'Android 13 Snapdragon 8+ Gen 1, Ram: 12GB, Rom: 256GB', 12, 0,CAST(N'2023-05-24T00:00:00.000'as datetime),'T',GETDATE(), 0)

insert dbo.SanPham
values (N'SP020',N'OPPO Reno10 Pro+ 5G',1, 3, 1, 'CN', 100,19290000,N'Tím', N'Android 13 Snapdragon 8+ Gen 1, Ram: 12GB, Rom: 256GB', 1,0,CAST(N'2023-05-24T00:00:00.000'as datetime),'T',GETDATE(), 0)

insert dbo.SanPham 
values (N'SP021',N'OPPO A18', 1, 3, 1, 'CN', 100,3190000,N'Xanh dương', N'Android 13 MediaTek Helio G85, Ram: 4GB, Rom: 64GB', 12, 0,CAST(N'2023-11-10T00:00:00.000'as datetime),'T',GETDATE(), 0)

insert dbo.SanPham
values (N'SP022',N'OPPO A18',1, 3, 1, 'CN', 100,3190000,N'Đen',N'Android 13 MediaTek Helio G85, Ram: 4GB, Rom: 64GB', 12, 0,CAST(N'2023-11-10T00:00:00.000'as datetime),'T',GETDATE(), 0)

--Tablet
insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP023',N'iPad Pro M2 12.9 inch WiFi Cellular',3,1,2,'US',75,32290000,N'Xám', N'iPadOS 16 Apple M2 8 nhân, Ram: 8GB, Rom: 128GB', 12,0,CAST(N'2022-10-18T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP024',N'iPad Pro M2 12.9 inch WiFi Cellular',3,1,2,'US',75,32290000,N'Bạc', N'iPadOS 16 Apple M2 8 nhân, Ram: 8GB, Rom: 128GB', 12,0,CAST(N'2022-10-18T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP025',N'iPad Pro M2 11 inch WiFi',3,1,2,'US',100,20590000,N'Xám', N'iPadOS 16 Apple M2 8 nhân, Ram: 8GB, Rom: 128GB', 12,0,CAST(N'2022-10-18T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP026',N'iPad Pro M2 11 inch WiFi',3,1,2,'US',100,20590000,N'Bạc', N'iPadOS 16 Apple M2 8 nhân, Ram: 8GB, Rom: 128GB', 12,0,CAST(N'2022-10-18T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP027',N'iPad Air 5 M1 WiFi Cellular',3,1,2,'US',200,17990000,N'Xanh dương', N'iPadOS 15 Apple M1, Ram: 8GB, Rom: 64GB', 12,0,CAST(N'2022-03-08T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP028',N'iPad Air 5 M1 WiFi Cellular',3,1,2,'US',80,10790000,N'Xanh dương', N'iPadOS 17 Apple A14 Bionic, Ram: 4GB, Rom: 64GB', 12,0,CAST(N'2022-10-18T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP029',N'iPad Air 5 M1 WiFi Cellular',3,1,2,'US',90,10790000,N'Bạc', N'iPadOS 17 Apple A14 Bionic, Ram: 4GB, Rom: 64GB', 12,0,CAST(N'2022-10-18T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP030',N'Samsung Galaxy Tab A9+',3,2,1,'SK',75,4890000,N'Xanh dương đậm', N'Android 13 Snapdragon 695, Ram: 4GB, Rom: 64GB', 12,0,CAST(N'2023-10-24T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP031',N'Samsung Galaxy Tab A9+',3,2,1,'SK',75,4890000,N'Bạc', N'Android 13 Snapdragon 695, Ram: 4GB, Rom: 64GB', 12,0,CAST(N'2023-10-24T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP032',N'Samsung Galaxy Tab S9+ WiFi 256GB',3,2,1,'SK',90,19990000,N'Xám', N'Android 13 Snapdragon 8 Gen 2 for Galaxy, Ram: 12GB, Rom: 256GB', 12,0,CAST(N'2023-10-24T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP033',N'Samsung Galaxy Tab S9+ WiFi 256GB',3,2,1,'SK',90,19990000,N'Kem', N'Android 13 Snapdragon 8 Gen 2 for Galaxy, Ram: 12GB, Rom: 256GB', 12,0,CAST(N'2023-10-24T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP034',N'Xiaomi Redmi Pad SE (6GB/128GB)',3,4,1,'CN',60,4490000,N'Xanh lá', N'Android 13 Snapdragon 680 8 nhân, Ram: 6GB, Rom: 128GB', 12,0,CAST(N'2023-09-29T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP035',N'Xiaomi Redmi Pad SE (6GB/128GB)',3,4,1,'CN',60,4490000,N'Xám', N'Android 13 Snapdragon 680 8 nhân, Ram: 6GB, Rom: 128GB', 12,0,CAST(N'2023-09-29T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP036',N'Xiaomi Redmi Pad SE (8GB/256GB)',3,4,1,'CN',50,5690000,N'Xanh lá', N'Android 13 Snapdragon 680 8 nhân, Ram: 8GB, Rom: 256GB', 12,0,CAST(N'2023-09-29T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP037',N'Xiaomi Redmi Pad SE (8GB/256GB)',3,4,1,'CN',50,5690000,N'Xám', N'Android 13 Snapdragon 680 8 nhân, Ram: 8GB, Rom: 256GB', 12,0,CAST(N'2023-09-29T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP038',N'OPPO Pad 2',3,3,1,'CN',100,13690000,N'Xám', N'Android 13 Mediatek Dimensity 9000 8 nhân, Ram: 8GB, Rom: 256GB', 12,0,CAST(N'2023-10-26T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP039',N'OPPO Pad Neo 4G',3,3,1,'CN',130,7590000,N'Xám', N'Android 13 MediaTek Helio G99, Ram: 8GB, Rom: 128GB', 12,0,CAST(N'2024-01-16T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP040',N'OPPO Pad Air 128GB',3,3,1,'CN',200,5990000,N'Tím', N'Android 13 Snapdragon 680 8 nhân, Ram: 4GB, Rom: 128GB', 12,0,CAST(N'2023-04-17T00:00:00.000'as datetime),'T',GETDATE(),0)

--SmartWatch
insert dbo.SanPham 
values (N'SP041',N'Apple Watch Ultra 2 GPS + Cellular', 4, 1, 14, 'US',70,21990000,N'Xanh dương', N'WatchOS Apple S9, Rom: 128GB, 542mAh', 12, 0,CAST(N'2023-09-13T00:00:00.000'as datetime),'T',GETDATE(), 1)

insert dbo.SanPham
values (N'SP042',N'Apple Watch Ultra 2 GPS + Cellular', 4, 1, 14,'US',70,21990000,N'Trắng', N'WatchOS Apple S9, Rom: 128GB, 542mAh', 12, 0,CAST(N'2023-09-13T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham 
values (N'SP043',N'Apple Watch Ultra 2 GPS + Cellular', 4, 1, 14, 'US',70,21990000,N'Cam', N'WatchOS Apple S9, Rom: 128GB, 542mAh', 12, 0,CAST(N'2023-09-13T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP044',N'Apple Watch SE 2023', 4, 1, 13, 'JP',60,5890000,N'Xanh dương nhạt', N'WatchOS Apple S8, Rom: 32GB, 296mAh', 12, 0,CAST(N'2023-09-13T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham 
values (N'SP045',N'Apple Watch SE 2023', 4, 1, 13, 'JP',60,5890000,N'Trắng StarLight', N'WatchOS Apple S8, Rom: 32GB, 296mAh', 12, 0,CAST(N'2023-09-13T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham 
values (N'SP046',N'Apple Watch SE 2023', 4, 1, 13, 'JP',60,5890000,N'Xanh đen đậm', N'WatchOS Apple S8, Rom: 32GB, 296mAh', 12, 0,CAST(N'2023-09-13T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham 
values (N'SP047',N'Samsung Galaxy Watch5', 4, 2, 12, 'SK', 75,3790000,N'Tím', N'Wear OS Exynos W920, Rom: 16GB, 284mAh', 12, 0,CAST(N'2022-08-10T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP048',N'Samsung Galaxy Watch5', 4, 2, 12, 'SK', 75,3790000,N'Đen', N'Wear OS Exynos W920, Rom: 16GB, 284mAh', 12,4.6,CAST(N'2022-08-10T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP049',N'Samsung Galaxy Watch4', 4, 2, 12, 'SK',50,3490000,N'Vàng Hồng', N'Wear OS Exynos W920, Rom: 16GB, 247mAh', 12,4.8,CAST(N'2021-08-11T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham
values (N'SP050',N'Samsung Galaxy Watch4', 4, 2, 12, 'CN',50,3490000,N'Đen', N'Wear OS Exynos W920, Rom: 16GB, 247mAh', 12,4.4,CAST(N'2021-08-11T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP051',N'Samsung Galaxy Watch5 Pro ', 4, 2, 13, 'CN',60,7990000,N'Đen', N'Wear OS Exynos W920, Rom: 16GB, 590mAh', 12,0,CAST(N'2022-08-11T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP052',N'Samsung Galaxy Watch5 Pro ', 4, 2, 13, 'CN',60,7990000,N'Xám', N'Wear OS Exynos W920, Rom: 16GB, 590mAh', 12, 0,CAST(N'2022-08-11T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP053',N'Samsung Galaxy Fit3', 4, 2, 13, 'CN', 80,1390000,N'Đen - Xám', N'FreeRTOS, Rom: 256MB, 208mAh', 12, 0,CAST(N'2022-02-22T00:00:00.000'as datetime),'T',GETDATE(), 0)

insert dbo.SanPham 
values (N'SP054',N'Samsung Galaxy Fit3', 4, 2, 13, 'CN',80,1390000,N'Hồng', N'FreeRTOS, Rom: 256MB, 208mAh', 12, 0,CAST(N'2022-02-22T00:00:00.000'as datetime),'T',GETDATE(), 0)

insert dbo.SanPham 
values (N'SP055',N'Samsung Galaxy Fit3', 4, 2, 13, 'SK', 80,1390000,N'Bạc', N'FreeRTOS, Rom: 256MB, 208mAh', 12, 0,CAST(N'2022-02-22T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP056',N'Xiaomi Watch 2 Pro', 4, 4, 13, 'CN', 170,5790000,N'Đen', N'Google Wear OS Snapdragon W5+ Gen 1, Rom: 32GB, 495mAh', 24,null,CAST(N'2023-09-26T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP057',N'Xiaomi Redmi Watch 4', 4, 4, 13, 'CN',110,2390000,N'Đen', N'Hyper OS BES2700IBP, Rom: 256mM, 460mAh', 24,null,CAST(N'2024-01-15T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP058',N'Xiaomi Redmi Watch 4', 4, 4, 13, 'CN',110,2390000,N'Xám', N'Hyper OS BES2700IBP, Rom: 256MB, 460mAh', 24,null,CAST(N'2024-01-15T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham 
values (N'SP059',N'BeFit Sporty 2 Pro', 4, 32, 12, 'VN',120,1190000,N'Đen', N'Realtek8762DT, Rom: 256KB, 300mAh', 24, 4.7,CAST(N'2023-03-20T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham 
values (N'SP060',N'BeFit Sporty 2 Pro', 4, 32, 12, 'VN',110,1190000,N'Nâu', N'Realtek8762DT, Rom: 256KB, 300mAh',24, 5.0,CAST(N'2023-03-20T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham 
values (N'SP061',N'BeFit WatchS', 4, 32, 12, 'VN',100,990000,N'Đen', N'Realtek 8763EWE, Rom: 256KB, 240mAh', 12, null,CAST(N'2023-04-24T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP062',N'BeFit WatchS', 4, 32, 12, 'VN',95,990000,N'Xám', N'Realtek 8763EWE, Rom: 256KB, 240mAh', 12,null,CAST(N'2023-04-24T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham 
values (N'SP063',N'BeFit WatchS', 4, 32, 12, 'VN',80,990000,N'Hồng', N'Realtek 8763EWE, Rom: 256KB, 240mAh', 12,null,CAST(N'2023-04-24T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham 
values (N'SP064',N'BeFit B3s', 4, 32, 12, 'VN',40,650000,N'Đen', N'GOODIX5515, Rom: 256KB, 180mAh', 24,null,CAST(N'2023-11-28T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham
values (N'SP065',N'BeFit B3s', 4, 32, 12, 'VN',50,650000,N'Xám', N'GOODIX5515, Rom: 256KB, 180mAh', 24,null,CAST(N'2023-11-28T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham
values (N'SP066',N'BeFit B3s', 4, 32, 12, 'VN',40,650000,N'Vàng', N'GOODIX5515, Rom: 256KB, 180mAh', 24,null,CAST(N'2023-11-28T00:00:00.000'as datetime),'T',GETDATE(),1)

--PC
insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP067',N'ASUS AIO A3402WBAK',9,12,32,'TW',40,14090000,N'Trắng', N'Windows 11 Intel Core i3 Alder Lake 1215U, Intel UHD, Ram: 8GB, Rom: 512GB SSD', 24,4.1,CAST(N'2023-11-23T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP068',N'Asus S501MD',9,12,33,'TW',50,9690000,N'Đen', N'Windows 11 Intel Core i3 Alder Lake 12100, Intel UHD 730, Ram: 8GB, Rom: 256GB SSD', 24,3.8,CAST(N'2023-12-28T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP069',N'Asus S500TE',9,12,33,'TW',70,14490000,N'Đen', N'Windows 11 Intel Core i5 Raptor Lake 13400, Intel UHD 730, Ram: 8GB, Rom: 512GB SSD', 36,2.7,CAST(N'2024-01-12T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP070',N'Asus ExpertCenter AIO A5402WVAK',9,12,32,'TW',30,19990000,N'Trắng', N'Windows 11 Intel Core i5 Raptor Lake 1340P, Intel UHD, Ram: 8GB, Rom: 512GB SSD', 2,4.6,CAST(N'2024-01-15T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP071',N'Asus S500SD',9,12,33,'TW',40,10590000,N'Trắng', N'Windows 11 Intel Core i5 Raptor Lake 1340P, Intel UHD, Ram: 8GB, Rom: 512GB SSD', 24,4.4,CAST(N'2024-01-15T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP072',N'iMac 24 inch 2023',9,1,32,'US',40,35690000,N'Xanh dương', N'macOS Sonoma Apple M3 8-core, 8-core GPU, Ram: 8GB, Rom: 256GB SSD', 12,4.5,CAST(N'2023-10-31T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP073',N'iMac 24 inch 2023',9,1,32,'US',40,35690000,N'Bạc', N'macOS Sonoma Apple M3 8-core, 8-core GPU, Ram: 8GB, Rom: 256GB SSD', 12,4.5,CAST(N'2023-10-31T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP074',N'iMac 24 inch 2023',9,1,32,'US',40,35690000,N'Xanh lá', N'macOS Sonoma Apple M3 8-core, 8-core GPU, Ram: 8GB, Rom: 256GB SSD', 12,4.5,CAST(N'2023-10-31T00:00:00.000'as datetime),'T',GETDATE(),1)
insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP075',N'iMac 24 inch 2023',9,1,32,'US',30,35690000,N'Hồng', N'macOS Sonoma Apple M3 8-core, 8-core GPU, Ram: 8GB, Rom: 256GB SSD', 12,4.5,CAST(N'2023-10-31T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP076',N'iMac 24 inch 2021',9,1,32,'US',30,30990000,N'Xanh dương', N'macOS Apple M1 8-core, 8-core GPU, Ram: 8GB, Rom: 256GB SSD', 12,4.3,CAST(N'2021-04-21T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP077',N'Mac mini M2 Pro 2023',9,1,33,'US',50,31990000,N'Bạc', N'macOS Apple M1 8-core, 8-core GPU, Ram: 16GB, Rom: 512GB SSD', 12,4.1,CAST(N'2023-01-17T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP078',N'HP AIO ProOne 240 G9',9,11,32,'US',40,14090000,N'Đen', N'Windows 11 Intel Core i3 Alder Lake 1215U,  Intel UHD, Ram: 8GB, Rom: 512GB SSD', 12,4.3,CAST(N'2022-02-18T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP079',N'Dell XPS 8960',9,15,33,'US',40,49990000,N'Đen', N'Windows 11 Intel Core i7 Raptor Lake 13700, NVIDIA GeForce RTX 3060 12 GB, Ram: 16GB, Rom: 512GB SSD', 12,4.8,CAST(N'2022-03-24T00:00:00.000'as datetime),'T',GETDATE(),1)

--cac loai khac
insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP080',N'HP 15s fq5229TU',2,11,5,'US',100,9999000,N'Bạc', N'Windows 11 Intel Core i3 1215U, Intel UHD, Ram: 8GB, Rom: 512GB SSD', 12,4.3,CAST(N'2022-05-21T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP081',N'Asus Vivobook Go 15 E1504FA ',2,12,6,N'TW',75,9999000,N'Bạc',  N'Windows 11 Ryzen 5 7520U, Radeon, Ram: 16GB, Rom: 512GB SSD', 24,4.4,CAST(N'2022-10-11T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP082',N'Acer Aspire 5 Gaming A51558GM 51LB',2,13,3,N'TW',87,16999000,N'Xám',  N'Windows 11 Intel Core i5 Raptor Lake - 13420H, RTX2050, Ram: 16GB, Rom: 512GB SSD', 12,4.5,CAST(N'2022-09-14T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP083',N'Lenovo Ideapad Slim 3 15IAH8',2,14,5,N'CN',150,15290000,N'Xám',  N'Windows 11 Intel Core i5 12450H, Intel UHD, Ram: 16GB, Rom: 512GB SSD', 24,4.5,CAST(N'2022-06-14T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP084',N'Dell Inspiron 15 3520',2,15,5,N'US',49,15490000,N'Đen',  N'Windows 11 Intel Core i5 1235U, Intel Iris Xe, Ram: 16GB, Rom: 512GB SSD', 12,4.7,CAST(N'2022-09-14T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP085',N'Gigabyte Gaming G5',2,18,3,N'TW',150,19490000,N'Đen',  N'Windows 11 Ryzen 5 7520U, RTX 4050, Ram: 16GB, Rom: 512GB SSD', 24,3.9,CAST(N'2023-10-17T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP086',N'Apple MacBook Air 13 inch M1',2,1,5,N'US',200,17990000,N'Vàng Đồng',  N'macOS Apple M1, 7-core GPU, Ram: 8GB, Rom: 256GB SSD', 12,4.0,CAST(N'2023-01-20T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP087',N'MSI Modern 14 C11M',2,16,3,N'TW',225,8490000,N'Đen',  N'Windows 11  i3 1115G4,  Intel UHD, Ram: 8GB, Rom: 512GB SSD', 24,4.6,CAST(N'2023-01-20T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP088',N'LG gram 2023',2,21,7,N'SK',55,25990000,N'Xám',  N'Windows 11 i5 1340P,  Intel Iris Xe, Ram: 16GB, Rom: 256GB SSD', 12,4.4,CAST(N'2023-07-24T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP089',N'Itel Spirit 2 ',2,10,5,N'CN',20,7990000,N'Bạc',  N'Windows 11  i5 1155G7,  Intel Iris Xe, Ram: 8GB, Rom: 512GB SSD', 12,4.1,CAST(N'2021-05-21T00:00:00.000'as datetime),'T',GETDATE(),0)
 
insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP090',N'Masstel E140 ',2,20,5,N'VN',15,3990000,N'Xám',  N'Windows 10 Pro Celeron N4120,  Intel UHD 600, Ram: 4GB, Rom: 128GB SSD', 24,4.6,CAST(N'2020-11-20T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP091',N'Casio 34 mm Nam MTP-M305L-7AVDF',5,30,17,N'JP',132,2940000,N'Đen',  N'Đường kính mặt 34mm, chất liệu kính thoáng Mineral, bộ máy pin', 12,4.8,CAST(N'2021-12-28T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP092',N'Đồng hồ G-SHOCK 5600 43.2 mm Nam GM-5600-1DR',5,29,20,N'JP',122,4576000,N'Đen',  N'Đường kính mặt 43.2mm, chất liệu kính khoáng Mineral, bộ máy pin', 12,4.1,CAST(N'2022-04-27T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP093',N'Máy in laser trắng đen đa năng HP LaserJet MFP 135a',6,11,22,N'US',50,3490000,N'Trắng',  N'Độ nét 1200 x 1200 dpi, công suất in tối đa 10.000 trang/tháng, loại mực in HP 107A W1107A Đen, in được tối đa 128Mb', 12,3.8,CAST(N'2023-02-21T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP094',N'Máy in phun trắng đen đơn năng Canon PIXMA GM2070 Wifi',6,31,23,N'JP',80,4390000,N'Đen',  N'Độ nét 1200 x 4800 dpi, công suất in tối đa 15.000 trang/tháng, loại mực in Canon GI-70 PGBK ĐenCanon CL-741 Xanh, đỏ, vàng', 12,4.2,CAST(N'2023-10-22T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP095',N'Hộp Mực in laser HP 107A W1107A Đen',7,11,26,N'US',400,1390000,N'Đen',  N'Tương thích máy in HP LaserJet 135a/wHP LaserJet 107a/w', 12,4.3,CAST(N'2023-11-17T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP096',N'Màn hình Asus VA24EHF',8,12,29,N'TW',230,2490000,N'Đen',  N'23.8 inch, Full HD (1920 x 1080), tấm nền IPS, Cổng kết nối HDMI', 36,4.2,CAST(N'2023-04-11T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP097',N'Màn hình Samsung S3 S33GC',8,2,28,N'SK',180,2990000,N'Đen',  N'27 inch, Full HD (1920 x 1080), tấm nền IPS, Cổng kết nối 1 x HDMI 1.41 x DisplayPort 1.2', 24,4.1,CAST(N'2023-07-21T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP098',N'Màn hình MSI PRO MP223',8,16,29,N'TW',175,1890000,N'Đen',  N'21.45", Full HD (1920 x 1080), tấm nền VA, Cổng kết nối Jack tai nghe 3.5 mmD-Sub (VGA)1 x HDMI 1.4', 24,4.4,CAST(N'2023-02-12T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP099',N'Màn hình Apple Studio Display',8,1,30,N'US',70,45990000,N'Bạc',  N'27 inch 5K Retina (5120 x 2880), Cổng kết nối Thunderbolt 33 x USB-C', 12,4.0,CAST(N'2023-03-12T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP100',N'Màn hình Lenovo L27e-40',8,14,30,N'CN',120,2990000,N'Bạc',  N'27 inch, Full HD (1920 x 1080), tấm nền VA, Cổng kết nối, Jack tai nghe 3.5 mm2 x HDMI1 x VGA', 36,4.2,CAST(N'2022-06-02T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP101',N'Màn hình Dell UltraSharp U2422H',8,15,28,N'US',100,5390000,N'Bạc',  N'23.8 inch, Full HD (1920 x 1080), 60 Hz, tấm nền IPS, cổng kết nối Jack tai nghe 3.5 mm, HDMI', 36,4.2,CAST(N'2023-07-12T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP102',N'Màn hình LG 24MP500-B.ATV',8,21,28,N'SK',125,2490000,N'Đen',  N'23.8 inch, Full HD (1920 x 1080), 75 Hz, tấm nền IPS, cổng kết nối, Jack tai nghe 3.5 mm2 x HDMI', 36,4.2,CAST(N'2023-03-25T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP103',N'Màn hình HP M27f ',8,11,30,N'US',78,4290000,N'Đen',  N'27 inch Full HD (1920 x 1080), 75 Hz, tấm nền IPS, cổng kết nối 2 x HDMI1 x VGA', 36,4.6,CAST(N'2023-03-25T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP104',N'Màn hình Acer K273 E ',8,13,28,N'TW',88,3090000,N'Đen',  N'27 inch Full HD (1920 x 1080), 100 Hz, tấm nền IPS, cổng kết nối 1 x VGA1 x HDMI 1.4', 36,4.5,CAST(N'2022-03-26T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP105',N'Màn hình Xiaomi A22i',8,4,30,N'CN',105,1790000,N'Đen',  N'21.45" Full HD (1920 x 1080),75 Hz, Tấm nền VA, Cổng kết nối 1 x VGA1 x HDMI 1.4', 36,4.4,CAST(N'2023-02-16T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP106',N'Máy chơi game cầm tay Asus ROG Ally RC71L',10,12,null,N'TW',176,17990000,N'Trắng',  N'21.45" Full HD (1920 x 1080),75 Hz, Tấm nền VA, Cổng kết nối 1 x VGA1 x HDMI 1.4', 36,4.4,CAST(N'2023-02-16T00:00:00.000'as datetime),'T',GETDATE(),0)
insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values(N'SP107',N'Pin sạc dự phòng Samsung EB-P3400',12,2,41,'SK',250,690000,N'Kem',N'Hiệu suất 66%, 10000mAh, thời gian sạc đầy pin 10 - 11h (1A), 6 - 8h (2A)',12,3.5,CAST(N'2022-02-10T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP, TenSP, MaDM, MaHang, MaLoai, MaXX, SoLuong, Gia, MauSac, ThongSoKiThuat, BaoHanh, tbSao, NgayTao, TinhTrang, NgayBoSungGanNhat, HOT)
values(N'SP108', N'Cáp Type C - Type C 1m Apple MQKJ3', 13, 1, 44, 'US', 500, 540000, N'Trắng', N'Công suất tối đa 60W, độ dài dây 1m, thương hiệu Mỹ', 12, 4, CAST(N'2024-03-11T00:00:00.000' as datetime), 'T', GETDATE(), 0)

insert dbo.SanPham (MaSP, TenSP, MaDM, MaHang, MaLoai, MaXX, SoLuong, Gia, MauSac, ThongSoKiThuat, BaoHanh, tbSao, NgayTao, TinhTrang, NgayBoSungGanNhat, HOT)
values(N'SP109', N'Adapter Sạc Type C PD 25W Samsung EP-TA800N', 13, 2, 44, 'SK', 200, 380000, N'Trắng', N'Công suất tối đa 25W, đầu vào 100-240V~50/60Hz, 0.5A, đầu ra Type C: 5V - 3A, 9V - 2.77A', 12, 4.1, CAST(N'2024-03-13T00:00:00.000' as datetime), 'T', GETDATE(), 0)

insert dbo.SanPham (MaSP, TenSP, MaDM, MaHang, MaLoai, MaXX, SoLuong, Gia, MauSac, ThongSoKiThuat, BaoHanh, tbSao, NgayTao, TinhTrang, NgayBoSungGanNhat, HOT)
values(N'SP110', N'Cáp Type C SuperVOOC 1m OPPO DL129', 13, 3, 44, 'CN', 120, 210000, N'Trắng', N'Công suất tối đa 80W , đầu vào USB Type-A, đầu ra Type C: 10V - 8A', 12, 3.2, CAST(N'2024-03-15T00:00:00.000' as datetime), 'T', GETDATE(), 0)

insert dbo.SanPham (MaSP, TenSP, MaDM, MaHang, MaLoai, MaXX, SoLuong, Gia, MauSac, ThongSoKiThuat, BaoHanh, tbSao, NgayTao, TinhTrang, NgayBoSungGanNhat, HOT)
values(N'SP111', N'Cáp chuyển đổi USB-C sang VGA Multiport Apple MJ1L2', 14, 1, 12, 'CN', 200, 2070000, N'Trắng', N'Đầu ra Thunderbolt, USB, VGA, Jack kết nối Type C', 12, 5, CAST(N'2024-03-18T00:00:00.000' as datetime), 'T', GETDATE(), 0)
insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP112',N'Ốp lưng Galaxy S24 Ultra',15,2,46,N'SK',60,952000,N'Nâu',  N'Nhựa cứng viền dẻo Samsung', 0,4.2,CAST(N'2022-07-12T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP113',N'Ốp lưng Magsafe iPhone 15 Pro Max',15,1,45,N'US',100,1300000,N'Xanh lá',  N'Vải tinh dệt Apple MT4W3', 0,4.7,CAST(N'2023-02-01T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP114',N'Ốp lưng iPhone 15 Pro Max',15,1,45,N'US',158,512000,N'Đen',  N'Nhựa cứng viền dẻo LAUT SHIELD', 0,4.2,CAST(N'2022-11-01T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP115',N'Bao da Galaxy Tab A9 Samsung Chính hãng',16,2,52,N'SK',100,841000,N'Đen',  N'Chất liệu da bền bỉ, hạn chế bám bẩn và dấu vân tay hiệu quả', 0,4.2,CAST(N'2023-12-11T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP116',N'Bao da iPad Pro 11 inch ESR Rebound Hybrid 360 Chính hãng',16,1,51,N'US',90,855000,N'Tím',  N'Nhựa PC và da PU giúp chống trầy xước và va đập tốt', 0,4.6,CAST(N'2023-11-12T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP117',N'Bao da Galaxy Tab S9 / Tab S9 FE Samsung',16,2,52,N'SK',80,1827000,N'Đen',  N'thiết kế mỏng nhẹ, không nặng tay mỗi khi sử dụng, cất giữ gọn gàng không chiếm diện tích', 0,4.7,CAST(N'2023-11-12T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP118',N'Miếng dán kính cường lực iPhone 15 Pro Max',17,1,57,N'US',300,343000,N'Trong suốt',  N'Chất liệu thủy tinh nhôm Silicat bền bỉ', 0,4.1,CAST(N'2023-12-21T00:00:00.000'as datetime),'T',GETDATE(),0)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP119',N'Miếng dán màn hình Macbook Pro/Air 13 inch',17,1,58,N'US',150,304000,N'Trong suốt',  N'chất liệu PET Film bền bỉ và mỏng nhẹ', 0,4.0,CAST(N'2023-01-11T00:00:00.000'as datetime),'T',GETDATE(),1)

insert dbo.SanPham (MaSP,TenSP,MaDM,MaHang,MaLoai,MaXX,SoLuong,Gia,MauSac,ThongSoKiThuat,BaoHanh,tbSao,NgayTao,TinhTrang,NgayBoSungGanNhat,HOT)
values (N'SP120',N'Miếng dán màn hình gập Galaxy Z Fold 5 Jincase',17,2,57,N'SK',60,160000,N'Trong suốt',  N'độ dày mỏng nhẹ, không ảnh hưởng đến chất lượng hiển thị', 0,4.5,CAST(N'2023-10-21T00:00:00.000'as datetime),'T',GETDATE(),0)
--HoaDon
Insert into HoaDon(MaHoaDon,MaKH,MaNV,TongTien,VAT,maGG_NgayDB,maGG_Vip,GiamGia,ThanhTien,DiemTichLuy,GhiChu,ThongTinLH,NgayTaoHoaDon,MaHoaHong,MaChungTu,MaPTTT)
values
(N'HDHCM000001','KH001','NV01',2600000.00,0.05,null,N'GGV03',0.18,2262000.00,22.62,N'Sản phẩm bảo hành 3 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-4-12 12:00:00',N'HH01',N'CTHCM006',N'TT01'),
(N'HDHCM000002','KH002','NV03',3500000.00,0.08,N'GGNDB04',N'GGV04',0.46,2170000,21.7,N'Sản phẩm bảo hành 1 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-12-12 12:00:00',N'HH01',N'CTHCM006',N'TT01'),
(N'HDHCM000003','KH003','NV06',1100000.00,0.08,null,null,0,1188000,11.88,N'Sản phẩm bảo hành 2 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-12-12 12:00:00',null,N'CTHCM006',N'TT02'),
(N'HDHCM000004','KH004','NV01',1800000.00,0.05,null,null,0,1890000.00,18.9,N'Sản phẩm bảo hành 3 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-4-12 12:00:00',null,N'CTHCM006',N'TT03'),
(N'HDHCM000005','KH005','NV03',4700000.00,0.06,N'GGNDB01',null,0.11,4465000,44.65,N'Sản phẩm bảo hành 1 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-5-12 12:00:00',N'HH01',N'CTHCM006',N'TT03'),
(N'HDHCM000006','KH006','NV06',3300000.00,0.03,null,null,0,3201000,32.01,N'Sản phẩm bảo hành 5 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-3-12 12:00:00',N'HH01',N'CTHCM006',N'TT03'),
(N'HDHCM000007','KH007','NV03',3500000.00,0.08,N'GGNDB04',N'GGV04',0.46,2170000,21.7,N'Sản phẩm bảo hành 1 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-12-12 12:00:00',N'HH01',N'CTHCM006',N'TT01'),
(N'HDHCM000008','KH007','NV06',1100000.00,0.08,null,null,0,1188000,11.88,N'Sản phẩm bảo hành 2 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-12-12 12:00:00',null,N'CTHCM006',N'TT02'),
(N'HDHCM000009','KH007','NV01',1800000.00,0.05,null,null,0,1890000.00,18.9,N'Sản phẩm bảo hành 3 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-4-12 12:00:00',null,N'CTHCM006',N'TT03'),
(N'HDHCM000010','KH010','NV03',4700000.00,0.06,N'GGNDB01',null,0.11,4465000,44.65,N'Sản phẩm bảo hành 1 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-5-12 12:00:00',N'HH01',N'CTHCM006',N'TT03'),
(N'HDHCM000011','KH010','NV06',3300000.00,0.03,null,null,0,3201000,32.01,N'Sản phẩm bảo hành 5 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-3-12 12:00:00',N'HH01',N'CTHCM006',N'TT03'),
(N'HDHCM000012','KH001','NV01',2600000.00,0.05,null,N'GGV03',0.18,2262000.00,22.62,N'Sản phẩm bảo hành 3 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-4-12 12:00:00',N'HH01',N'CTHCM006',N'TT01'),
(N'HDHCM000013','KH002','NV03',3500000.00,0.08,N'GGNDB04',N'GGV04',0.46,2170000,21.7,N'Sản phẩm bảo hành 1 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-12-12 12:00:00',N'HH01',N'CTHCM006',N'TT01'),
(N'HDHCM000014','KH003','NV06',1100000.00,0.08,null,null,0,1188000,11.88,N'Sản phẩm bảo hành 2 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-12-12 12:00:00',null,N'CTHCM006',N'TT02'),
(N'HDHCM000015','KH004','NV01',1800000.00,0.05,null,null,0,1890000.00,18.9,N'Sản phẩm bảo hành 3 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-4-12 12:00:00',null,N'CTHCM006',N'TT03'),
(N'HDHCM000016','KH005','NV03',4700000.00,0.06,N'GGNDB01',null,0.11,4465000,44.65,N'Sản phẩm bảo hành 1 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-5-12 12:00:00',N'HH01',N'CTHCM006',N'TT03'),
(N'HDHCM000017','KH006','NV06',3300000.00,0.03,null,null,0,3201000,32.01,N'Sản phẩm bảo hành 5 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-3-12 12:00:00',N'HH01',N'CTHCM006',N'TT03'),
(N'HDHCM000018','KH007','NV03',3500000.00,0.08,N'GGNDB04',N'GGV04',0.46,2170000,21.7,N'Sản phẩm bảo hành 1 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-12-12 12:00:00',N'HH01',N'CTHCM006',N'TT01'),
(N'HDHCM000019','KH007','NV06',1100000.00,0.08,null,null,0,1188000,11.88,N'Sản phẩm bảo hành 2 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-12-12 12:00:00',null,N'CTHCM006',N'TT02'),
(N'HDHCM000020','KH007','NV01',1800000.00,0.05,null,null,0,1890000.00,18.9,N'Sản phẩm bảo hành 3 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-4-12 12:00:00',null,N'CTHCM006',N'TT03'),
(N'HDHCM0000021','KH010','NV03',4700000.00,0.06,N'GGNDB01',null,0.11,4465000,44.65,N'Sản phẩm bảo hành 1 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-5-12 12:00:00',N'HH01',N'CTHCM006',N'TT03'),
(N'HDHCM0000022','KH010','NV06',3300000.00,0.03,null,null,0,3201000,32.01,N'Sản phẩm bảo hành 5 năm, trong 1 tháng có thể đổi trả',N'SĐT: 0128888888, ĐC: 30 đường Phan Bội Châu, Thủ Đức, Hồ Chí Minh, email: thegioididong@gmail.com','2000-3-12 12:00:00',N'HH01',N'CTHCM006',N'TT03');

--KhachHangDanhGiaSP
insert into KhachHangDanhGiaSP
values
('KH001', 'SP018', 2, N'Máy dùng 15p nhanh nóng..thấy mẫu đẹp mùa dùng thử ai ngờ....như căn cọt')
insert into KhachHangDanhGiaSP
values('KH002', 'SP018', 3, N'Máy mới mua được 4 ngày,xài bị lỗi bàn phím, lúc bấm được và không được, pin sạc đầy,rút ra để qua đêm')
insert into KhachHangDanhGiaSP
values('KH003', 'SP086', 1, N'Phục vụ rất kém')
insert into KhachHangDanhGiaSP
values('KH004', 'SP050', 5, N'Đồng hồ nhiều chức năng, sử dụng lâu bền, rất phù hợp cho mọi đối tượng')
insert into KhachHangDanhGiaSP
values('KH005', 'SP022', 4, N'Sản phẩm rất hữu ích và tiện lợi, đã giúp tôi tiết kiệm thời gian và công sức hàng ngày.')
insert into KhachHangDanhGiaSP
values('KH006', 'SP087', 2, N'Chất lượng sản phẩm không đạt yêu cầu, rất thất vọng về trải nghiệm mua sắm lần này.')
insert into KhachHangDanhGiaSP
values('KH007', 'SP104', 5, N'Sản phẩm hoàn hảo, đáp ứng đầy đủ các yêu cầu của tôi và vượt xa mong đợi.')
insert into KhachHangDanhGiaSP
values('KH008', 'SP060', 3, N'Giao hàng đến muộn và gói hàng bị hỏng, mong muốn có trải nghiệm mua sắm tốt hơn lần sau.')
insert into KhachHangDanhGiaSP
values('KH009', 'SP022', 4, N'Sản phẩm đáng giá tiền, chất lượng tốt và dịch vụ khách hàng thân thiện.')
insert into KhachHangDanhGiaSP
values('KH010', 'SP087', 1, N'Không hài lòng về sản phẩm và dịch vụ, sẽ không quay lại mua sắm ở đây nữa.')
insert into KhachHangDanhGiaSP
values('KH011', 'SP032', 3, N'Sản phẩm có chất lượng khá tốt, nhưng giá cả hơi cao so với các sản phẩm tương tự trên thị trường.')
insert into KhachHangDanhGiaSP
values('KH012', 'SP076', 4, N'Sản phẩm đáp ứng đúng nhu cầu của tôi, giao hàng nhanh chóng và dễ dàng sử dụng.')
insert into KhachHangDanhGiaSP
values('KH013', 'SP096', 2, N'Chất lượng sản phẩm không như mong đợi, cần cải thiện hơn về hiệu suất và độ bền.')
insert into KhachHangDanhGiaSP
values('KH014', 'SP055', 5, N'Sản phẩm vượt xa mong đợi, đáng đồng tiền bát gạo và phục vụ khách hàng rất tốt.')
insert into KhachHangDanhGiaSP
values('KH015', 'SP013', 1, N'Sản phẩm đã gây thất vọng lớn, không hoạt động như quảng cáo và dịch vụ sau bán hàng cũng rất kém.')
insert into KhachHangDanhGiaSP
values('KH016', 'SP076', 4, N'Tôi đã hài lòng với sản phẩm và sẽ giới thiệu cho bạn bè của mình.')
insert into KhachHangDanhGiaSP
values('KH017', 'SP032', 2, N'Sản phẩm không đáp ứng được nhu cầu của tôi, không hài lòng với chất lượng và tính năng.')
insert into KhachHangDanhGiaSP
values('KH018', 'SP096', 3, N'Chất lượng sản phẩm trung bình, có thể cải thiện được nếu công ty tập trung vào nghiên cứu và phát triển.')
insert into KhachHangDanhGiaSP
values('KH019', 'SP055', 5, N'Sản phẩm chất lượng cao, đáp ứng hoàn hảo nhu cầu của tôi, rất hài lòng với trải nghiệm mua sắm này.')
insert into KhachHangDanhGiaSP
values('KH020', 'SP013', 1, N'Đã gặp rất nhiều vấn đề khi sử dụng sản phẩm, không thể khuyến khích cho ai muốn mua.')
insert into KhachHangDanhGiaSP
values('KH021', 'SP088', 4, N'Sản phẩm đạt chuẩn chất lượng, dễ sử dụng và giá cả hợp lý.')
insert into KhachHangDanhGiaSP
values('KH022', 'SP014', 2, N'Không hài lòng với sản phẩm, chất lượng kém và không đúng với mô tả trên trang web.')
insert into KhachHangDanhGiaSP
values('KH023', 'SP067', 5, N'Sản phẩm rất tốt, đáp ứng mọi nhu cầu của tôi và dịch vụ giao hàng cũng rất nhanh chóng.')
insert into KhachHangDanhGiaSP
values('KH024', 'SP032', 3, N'Sản phẩm đáng giá tiền, nhưng có thể cải thiện về tính năng và hiệu suất.')
insert into KhachHangDanhGiaSP
values('KH025', 'SP091', 1, N'Sản phẩm không hoạt động sau một thời gian ngắn sử dụng, không hài lòng với chất lượng này.')
insert into KhachHangDanhGiaSP
values('KH026', 'SP076', 5, N'Sản phẩm rất tốt, đặc biệt là dịch vụ sau bán hàng, tôi rất hài lòng với trải nghiệm mua sắm này.')
insert into KhachHangDanhGiaSP
values('KH027', 'SP041', 2, N'Sản phẩm không đáp ứng được mong đợi, chất lượng kém và không ổn định.')
insert into KhachHangDanhGiaSP
values('KH028', 'SP098', 4, N'Sản phẩm đáng giá tiền, chất lượng tốt và dịch vụ giao hàng nhanh chóng.')
insert into KhachHangDanhGiaSP
values('KH029', 'SP022', 3, N'Sản phẩm có chất lượng tốt nhưng không có nhiều tính năng đặc biệt.')
insert into KhachHangDanhGiaSP
values('KH030', 'SP055', 5, N'Sản phẩm hoàn hảo, chất lượng vượt xa mong đợi và giá cả phải chăng.');

--HinhAnh
insert into HinhAnh values ('HA02',N'Ảnh của IpadPro','path/to/imageIpadPro.jpg','SP023')
insert into HinhAnh values ('HA01',N'Ảnh của IpadAir','path/to/imageIpadAir.jpg','SP028')
INSERT INTO HinhAnh VALUES ('HA03', N'Ảnh của Pin sạc dự phòng Samsung EB-P3400', 'path/to/imagePinSachDuPhongSamsungEBP3400.jpg', 'SP107');
INSERT INTO HinhAnh VALUES ('HA04', N'Ảnh của Cáp Type C - Type C 1m Apple MQKJ3', 'path/to/imageCapTypeCTypeCAppleMQKJ3.jpg', 'SP108');
INSERT INTO HinhAnh VALUES ('HA05', N'Ảnh của Adapter Sạc Type C PD 25W Samsung EP-TA800N', 'path/to/imageAdapterSacTypeCPD25WSamsungEPTA800N.jpg', 'SP109');
INSERT INTO HinhAnh VALUES ('HA06', N'Ảnh của Cáp Type C SuperVOOC 1m OPPO DL129', 'path/to/imageCapTypeCSuperVOOC1mOPPODL129.jpg', 'SP110');
INSERT INTO HinhAnh VALUES ('HA07', N'Ảnh của Cáp chuyển đổi USB-C sang VGA Multiport Apple MJ1L2', 'path/to/imageCapChuyenDoiUSBCSangVGAMultiportAppleMJ1L2.jpg', 'SP111');
INSERT INTO HinhAnh VALUES ('HA08', N'Ảnh của OPPO Pad Air 128GB', 'path/to/imageOPPOPadAir128GB.jpg', 'SP040');
INSERT INTO HinhAnh VALUES ('HA09', N'Ảnh của ASUS AIO A3402WBAK', 'path/to/imageASUSAIOA3402WBAK.jpg', 'SP067');
INSERT INTO HinhAnh VALUES ('HA10', N'Ảnh của Asus S501MD', 'path/to/imageAsusS501MD.jpg', 'SP068');
INSERT INTO HinhAnh VALUES ('HA11', N'Ảnh của Asus S500TE', 'path/to/imageAsusS500TE.jpg', 'SP069');
INSERT INTO HinhAnh VALUES ('HA12', N'Ảnh của Ốp lưng Galaxy S24 Ultra', 'path/to/imageOplungGalaxyS24Ultra.jpg', 'SP112');
INSERT INTO HinhAnh VALUES ('HA13', N'Ảnh của Ốp lưng Magsafe iPhone 15 Pro Max', 'path/to/imageOplungMagsafeiPhone15ProMax.jpg', 'SP113');
INSERT INTO HinhAnh VALUES ('HA14', N'Ảnh của Ốp lưng iPhone 15 Pro Max', 'path/to/imageOplungiPhone15ProMax.jpg', 'SP114');
INSERT INTO HinhAnh VALUES ('HA15', N'Ảnh của Bao da Galaxy Tab A9 Samsung Chính hãng', 'path/to/imageBaodaGalaxyTabA9SamsungChinhhang.jpg', 'SP115');
INSERT INTO HinhAnh VALUES ('HA16', N'Ảnh của Bao da iPad Pro 11 inch ESR Rebound Hybrid 360 Chính hãng', 'path/to/imageBaodaiPadPro11inchESRReboundHybrid360Chinhhang.jpg', 'SP116');
INSERT INTO HinhAnh VALUES ('HA17', N'Ảnh của Bao da Galaxy Tab S9 / Tab S9 FE Samsung', 'path/to/imageBaodaGalaxyTabS9TabS9FESamsung.jpg', 'SP117');
INSERT INTO HinhAnh VALUES ('HA18', N'Ảnh của Miếng dán kính cường lực iPhone 15 Pro Max', 'path/to/imageMiengdankinhcuongluciPhone15ProMax.jpg', 'SP118');
INSERT INTO HinhAnh VALUES ('HA19', N'Ảnh của Miếng dán màn hình Macbook Pro/Air 13 inch', 'path/to/imageMiengdanmanhinhMacbookProAir13inch.jpg', 'SP119');
INSERT INTO HinhAnh VALUES ('HA20', N'Ảnh của Miếng dán màn hình gập Galaxy Z Fold 5 Jincase', 'path/to/imageMiengdanmanhinhgapGalaxyZFold5Jincase.jpg', 'SP120');
INSERT INTO HinhAnh VALUES ('HA21', N'Ảnh của Iphone 13 - Màu Trắng', 'path/to/imageIphone13Trang.jpg', 'SP003');
INSERT INTO HinhAnh VALUES ('HA22', N'Ảnh của Iphone 13 - Màu Đen', 'path/to/imageIphone13Den.jpg', 'SP004');
INSERT INTO HinhAnh VALUES ('HA23', N'Ảnh của Samsung Galaxy S24 Ultra 5G - Màu Đen', 'path/to/imageSamsungGalaxyS24UltraDen.jpg', 'SP005');
INSERT INTO HinhAnh VALUES ('HA24', N'Ảnh của Samsung Galaxy S24 Ultra 5G - Màu Xám', 'path/to/imageSamsungGalaxyS24UltraXam.jpg', 'SP006');
INSERT INTO HinhAnh VALUES ('HA25', N'Ảnh của Samsung A15 5G - Màu Đen', 'path/to/imageSamsungA15Den.jpg', 'SP007');
INSERT INTO HinhAnh VALUES ('HA26', N'Ảnh của Samsung A15 5G - Màu Xanh dương đậm', 'path/to/imageSamsungA15XanhDuongDam.jpg', 'SP008');
INSERT INTO HinhAnh VALUES ('HA27', N'Ảnh của Samsung Galaxy Z Flip5 5G - Màu Xanh mint', 'path/to/imageSamsungGalaxyZFlip5XanhMint.jpg', 'SP009');
INSERT INTO HinhAnh VALUES ('HA28', N'Ảnh của Samsung Galaxy Z Flip5 5G - Màu Kem', 'path/to/imageSamsungGalaxyZFlip5Kem.jpg', 'SP010');
INSERT INTO HinhAnh VALUES ('HA29', N'Ảnh của Xiaomi Redmi Note 13 Pro - Màu Xanh lá', 'path/to/imageXiaomiRedmiNote13ProXanhLa.jpg', 'SP011');
INSERT INTO HinhAnh VALUES ('HA30', N'Ảnh của Xiaomi Redmi Note 13 Pro - Màu Tím', 'path/to/imageXiaomiRedmiNote13ProTim.jpg', 'SP012');
INSERT INTO HinhAnh VALUES ('HA31', N'Ảnh của Xiaomi 13T Pro 5G - Màu Đen', 'path/to/imageXiaomi13TPro5GDen.jpg', 'SP013');
INSERT INTO HinhAnh VALUES ('HA32', N'Ảnh của Xiaomi 13T Pro 5G - Màu Xanh lá', 'path/to/imageXiaomi13TPro5GXanhLa.jpg', 'SP014');
INSERT INTO HinhAnh VALUES ('HA33', N'Ảnh của Xiaomi 14 5G - Màu Đen', 'path/to/imageXiaomi14_5GDen.jpg', 'SP015');
INSERT INTO HinhAnh VALUES ('HA34', N'Ảnh của Xiaomi 14 5G - Màu Xanh lá', 'path/to/imageXiaomi14_5GXanhLa.jpg', 'SP016');
INSERT INTO HinhAnh VALUES ('HA35', N'Ảnh của OPPO Reno11 5G - Màu Xám', 'path/to/imageOPPOReno11_5G_Xam.jpg', 'SP017');
INSERT INTO HinhAnh VALUES ('HA36', N'Ảnh của OPPO Reno11 5G - Màu Xanh lá nhạt', 'path/to/imageOPPOReno11_5G_XanhLaNhat.jpg', 'SP018');

--SPDuocGiamGia
INSERT INTO SPDuocGiamGia values('GGTK01','SP023')
INSERT INTO SPDuocGiamGia VALUES ('GGTK02', 'SP024')
INSERT INTO SPDuocGiamGia VALUES       ('GGTK03', 'SP025')
INSERT INTO SPDuocGiamGia VALUES       ('GGTK04', 'SP026')
INSERT INTO SPDuocGiamGia VALUES       ('GGTK01', 'SP027')
INSERT INTO SPDuocGiamGia VALUES       ('GGTK02', 'SP028')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK03', 'SP029')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK04', 'SP030')
INSERT INTO SPDuocGiamGia VALUES     ('GGTK01', 'SP031')
INSERT INTO SPDuocGiamGia VALUES     ('GGTK02', 'SP032')
INSERT INTO SPDuocGiamGia VALUES     ('GGTK03', 'SP033')
INSERT INTO SPDuocGiamGia VALUES    ('GGTK04', 'SP034')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK01', 'SP035')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK02', 'SP036')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK03', 'SP037')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK04', 'SP038')
INSERT INTO SPDuocGiamGia VALUES     ('GGTK01', 'SP039')
INSERT INTO SPDuocGiamGia VALUES    ('GGTK02', 'SP040')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK03', 'SP041')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK04', 'SP042')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK01', 'SP043')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK02', 'SP044')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK03', 'SP045')
INSERT INTO SPDuocGiamGia VALUES     ('GGTK04', 'SP046')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK01', 'SP047')
INSERT INTO SPDuocGiamGia VALUES     ('GGTK02', 'SP048')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK03', 'SP049')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK04', 'SP050')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK01', 'SP051')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK02', 'SP052')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK03', 'SP053')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK04', 'SP054')
INSERT INTO SPDuocGiamGia VALUES      ('GGTK01', 'SP055')
INSERT INTO SPDuocGiamGia VALUES     ('GGTK02', 'SP056')
INSERT INTO SPDuocGiamGia VALUES     ('GGTK03', 'SP057')
INSERT INTO SPDuocGiamGia VALUES     ('GGTK04', 'SP058')

--SPTrongKho
INSERT INTO SanPhamTrongKho values(N'SP001', 'STR01', 200)
INSERT INTO SanPhamTrongKho values(N'SP094', 'STR06', 180)
INSERT INTO SanPhamTrongKho values(N'SP052', 'STR01', 320)
INSERT INTO SanPhamTrongKho values(N'SP033', 'STR04', 650)
INSERT INTO SanPhamTrongKho values(N'SP041', 'STR04', 800)
INSERT INTO SanPhamTrongKho values(N'SP077', 'STR03', 270)
INSERT INTO SanPhamTrongKho values(N'SP100', 'STR02', 1000)
INSERT INTO SanPhamTrongKho values(N'SP084', 'STR06', 420)
INSERT INTO SanPhamTrongKho values(N'SP055', 'STR03', 550)
INSERT INTO SanPhamTrongKho values(N'SP012', 'STR01', 720)
INSERT INTO SanPhamTrongKho values(N'SP078', 'STR05', 360)
INSERT INTO SanPhamTrongKho values(N'SP035', 'STR02', 890)
INSERT INTO SanPhamTrongKho values(N'SP067', 'STR06', 480)
INSERT INTO SanPhamTrongKho values(N'SP029', 'STR04', 610)
INSERT INTO SanPhamTrongKho values(N'SP102', 'STR01', 320)
INSERT INTO SanPhamTrongKho values(N'SP049', 'STR03', 780)
INSERT INTO SanPhamTrongKho values(N'SP071', 'STR02', 430)
INSERT INTO SanPhamTrongKho values(N'SP088', 'STR04', 690)
INSERT INTO SanPhamTrongKho values(N'SP096', 'STR05', 540)

--HoaDonChiTiet
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000001',N'SP093',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000001',N'SP084',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000002',N'SP098',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000003',N'SP104',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000004',N'SP108',2,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000005',N'SP112',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000006',N'SP113',2,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000007',N'SP115',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000008',N'SP116',2,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000009',N'SP117',2,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000010',N'SP116',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000011',N'SP097',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000012',N'SP052',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000013',N'SP042',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000014',N'SP117',2,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000015',N'SP052',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000016',N'SP117',2,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000017',N'SP119',3,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000018',N'SP097',4,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000019',N'SP119',2,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000020',N'SP117',2,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000005',N'SP044',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000003',N'SP117',4,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000001',N'SP098',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000002',N'SP104',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000003',N'SP113',2,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000008',N'SP115',2,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000010',N'SP042',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000016',N'SP119',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000017',N'SP117',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000020',N'SP054',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000014',N'SP057',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000011',N'SP067',1,N'Còn Hàng')
INSERT INTO ChiTietHoaDon(MaHoaDon,MaSP,SoLuong,TinhTrangDonHang)
VALUES (N'HDHCM000018',N'SP074',1,N'Còn Hàng')

