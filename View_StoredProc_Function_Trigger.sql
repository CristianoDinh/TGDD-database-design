
-------------------------------------------------------------------------------------------------------
------------------------------------------- VIEW ------------------------------------------------------
-------------------------------------------------------------------------------------------------------
--1. Sản phẩm 'Iphone 15 Pro Max' của Hãng nào ?	Hỏi cách này phải tạo ra số VIEW = sô dòng trong TABLE SanPham
CREATE VIEW vw_HangSP
AS 
	SELECT h.*
	FROM Hang h WHERE h.MaHang = (
									SELECT DISTINCT (s.MaHang) FROM SanPham s WHERE s.TenSP = 'Iphone 15 Pro Max'
								)

SELECT * FROM vw_HangSP


--2. Xuất ra những hóa đơn có giá trị trên 2 triệu đồng => Kiểm tra Nhân viên nào được nhận Hoa Hồng(ko tính mức hoa hồng nhận được) 
CREATE VIEW vw_Uper2TRvnd
AS
	SELECT hd.MaHoaDon AS N'Mã hóa đơn trên 2 triệu đồng', hd.ThanhTien, nv.MaNV AS N'Mã nhân viên được nhận hoa hồng', nv.TenNV
	FROM HoaDon hd , NhanVien nv
	WHERE hd.MaNV = nv.MaNV 
	AND hd.ThanhTien > 2000000 

select * from vw_Uper2TRvnd


--3. Liệt kê thông tin chi tiết Sản Phẩm có Bảo hành trong 1 năm = 12 THÁNG? -- ko rõ sản phẩm thuộc danh mục nào? ( ko lẽ người dùng ko có định trước danh mục cần mua )
CREATE VIEW vw_SanPhamBH
AS
	SELECT sp.*
	FROM SanPham sp WHERE BaoHanh = '12'

-- Liệt kê Danh mục + Sản Phẩm có Bảo hành trong 2 năm = 24 THÁNG?
-- Liệt kê thông tin chi tiết Sản Phẩm có Bảo hành trong 3 năm = 36 THÁNG?
-----------   => ĐƯA VÀO STORED PROCEDURE   ---------------------
CREATE PROCEDURE proc_SanPhamBH (@thoiGianBH int)
AS
BEGIN
	SELECT dm.TenDM,sp.TenSP, sp.BaoHanh
	FROM DanhMuc dm, SanPham sp
	WHERE dm.MaDM=sp.MaDM 
	AND sp.BaoHanh = @thoiGianBH
END

EXECUTE proc_SanPhamBH @thoiGianBH = 12


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------- STORED PROCEDURE -----------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--1. Tham số vào là Tên Danh Mục. => Liệt kê Nơi Xuất Xứ tương ứng với tên Danh Mục đó 
--vd Customer nói: "Cho hỏi Điện thoại thì có Đơnvị/Nước nào sản xuất"
CREATE PROCEDURE proc_XuatXuDM (@tenDM nvarchar(100))
AS
BEGIN
	SELECT dm.TenDM, xx.TenXX
	FROM DanhMuc dm, SanPham sp, XuatXu xx
	WHERE dm.MaDM=sp.MaDM AND sp.MaXX=xx.MaXX
	AND dm.TenDM = @tenDM
END

EXECUTE proc_XuatXuDM @tenDM = N'Điện thoại'

--2. Tham số vào là Tên Danh Mục + Nơi Xuất Xứ. => Liệt kê Tên sản phẩm và các thuộc tính cần thiết 
--vd Customer nói: "Cho hỏi Điện thoại của China có những dòng/sản phẩm nào."
CREATE PROCEDURE proc_SanPhamDMXX (@tenDM nvarchar(100), @noiXX nvarchar(100))
AS
BEGIN
	SELECT dm.TenDM,sp.TenSP,xx.TenXX,  sp.MauSac,sp.ThongSoKiThuat,sp.SoLuong,sp.TinhTrang,sp.BaoHanh
	FROM DanhMuc dm, SanPham sp, XuatXu xx
	WHERE dm.MaDM=sp.MaDM AND sp.MaXX=xx.MaXX
	AND dm.TenDM = @tenDM AND xx.TenXX = @noiXX
END

EXECUTE proc_SanPhamDMXX @tenDM=N'Điện thoại',@noiXX=N'China'

--3. Tham số vào là Tên Danh Mục + Nơi Xuất Xứ. => Liệt kê Tên sản phẩm và Giá
--vd Customer nói: "Điện thoại sản xuất tại Trung Quốc có mức giá trong khoảng nào?", những SP nào HOT và ko HOT
--					cũng như thông tin về các chương trình khuyến mãi hoặc giảm giá (nếu có).
drop PROCEDURE proc_giaSanPhamDMXX
CREATE PROCEDURE proc_giaSanPhamDMXX (@tenDM nvarchar(100), @noiXX nvarchar(100))
AS
BEGIN
	SELECT sp.TenSP,dm.TenDM,xx.TenXX,  sp.Gia,gg.maGG,hd.GiamGia,  sp.HOT
	FROM DanhMuc dm, SanPham sp, XuatXu xx , SPDuocGiamGia gg ,ChiTietHoaDon cthd,HoaDon hd
	WHERE dm.MaDM=sp.MaDM AND sp.MaXX=xx.MaXX AND sp.MaSP=gg.MaSP AND sp.MaSP=cthd.MaSP AND cthd.MaHoaDon=hd.MaHoaDon
	AND dm.TenDM = @tenDM AND xx.TenXX = @noiXX
END

EXECUTE proc_giaSanPhamDMXX @tenDM=N'SmartWatch',@noiXX=N'Japan'



-- SO SÁNH TÍNH NĂNG GIỮA 2 SP BẤT KÌ
--4. Tham số vào là TênDanhMục A + TênDanhMục B. => Liệt kê Tên Thông số kỹ thuật của 2 SP và các thuộc tính cần thiết khác(nếu có).
--vd Customer nói: "So sánh tính năng sản phẩm A và sản phẩm B"
DROP PROCEDURE proc_SoSanh2SP
CREATE PROCEDURE proc_SoSanh2SP (@tenSP_A nvarchar(100), @tenSP_B nvarchar(100))
AS
BEGIN
	SELECT DISTINCT dm.TenDM, a.TenSP AS N'Sản Phẩm 1',a.ThongSoKiThuat,a.MauSac,a.BaoHanh, b.TenSP AS N'Sản Phẩm 2',b.ThongSoKiThuat,b.MauSac,b.BaoHanh
	FROM SanPham a, SanPham b , DanhMuc dm
	WHERE a.MaDM = b.MaDM	and b.MaDM = dm.MaDM
	AND a.TenSP = @tenSP_A AND b.TenSP = @tenSP_B
END

EXECUTE proc_SoSanh2SP @tenSP_A=N'Iphone 15 Pro Max',@tenSP_B= N'Iphone 13'

select * from SanPham
--5. Tham số vào là Mã Sản Phẩm   => Liệt kê ra Số sao đánh giá và Bình luận của từng khách hàng(Ẩn tên khách hàng, chỉ hiện mã)
--vd Customer nói: "Sản phẩm A được Khách hàng khác đánh giá và Bình luận như thế nào?"
CREATE PROCEDURE proc_DanhGiaSP (@maSP nvarchar(50))
AS
BEGIN
	SELECT sp.MaSP,sp.TenSP, dg.MaKH,dg.soSao,dg.BinhLuan
	FROM SanPham sp, KhachHangDanhGiaSP dg
	WHERE sp.MaSP=dg.MaSP
	AND sp.MaSP = @maSP
END

EXECUTE proc_DanhGiaSP @maSP = N'SP018'


-- CHI TIẾT TRONG QUÁ TRÌNH MUA HÀNG
--6. Tham số vào là SĐT khách hàng   => Liệt kê ra Thông tin Khách hàng + % giảm giá tương ứng với Khách hàng đó
--vd Customer nói: "Tôi được hưởng bao nhiêu % giảm giá khi mua hàng." => Nhân viên hỏi "Vui lòng đọc SĐT để em kiểm tra!"

CREATE PROCEDURE proc_GiamGiaKH (@sdt varchar(20))
AS
BEGIN
	SELECT kh.MaKH,kh.HoTenKH,kh.GioiTinh,kh.DiaChi, xlv.MaVip,xlv.Hang, ggv.loaiVip,ggv.phanTram
	FROM KhachHang kh, XepLoaiVip xlv, GiamGia_Vip ggv
	WHERE kh.MaVip=xlv.MaVip AND xlv.maGGVip=ggv.maGG
	AND kh.SDT = @sdt
END

EXECUTE proc_GiamGiaKH @sdt = '038 514 8672'


--7. Tham số vào là thành tiền
--vd Liệt kê nhân viên với những mức hoa hồng tương ứng (>2tr,>4tr,...)
CREATE PROCEDURE proc_HoaHongNV (@thanhTien money)
AS 
BEGIN
	IF (@thanhTien >= 2000000 AND @thanhTien < 5000000)
		SELECT nv.MaNV,nv.TenNV,nv.SDT, hd.MaHoaDon AS N'Mã hóa đơn trên 2tr đồng',hd.ThanhTien,hh.MaHoaHong,hh.PhanTram
		FROM NhanVien nv,HoaDon hd,HoaHong hh
		WHERE nv.MaNV=hd.MaNV AND hd.MaHoaHong=hh.MaHoaHong
	
	ELSE IF(@thanhTien >= 5000000 AND @thanhTien < 100000000)
		SELECT nv.MaNV,nv.TenNV,nv.SDT, hd.MaHoaDon AS N'Mã hóa đơn trên 5tr đồng',hd.ThanhTien,hh.MaHoaHong,hh.PhanTram
		FROM NhanVien nv,HoaDon hd,HoaHong hh
		WHERE nv.MaNV=hd.MaNV AND hd.MaHoaHong=hh.MaHoaHong

	ELSE IF (@thanhTien >= 100000000 AND @thanhTien < 1000000000)
		SELECT nv.MaNV,nv.TenNV,nv.SDT, hd.MaHoaDon AS N'Mã hóa đơn trên 100tr đồng',hd.ThanhTien,hh.MaHoaHong,hh.PhanTram
		FROM NhanVien nv,HoaDon hd,HoaHong hh
		WHERE nv.MaNV=hd.MaNV AND hd.MaHoaHong=hh.MaHoaHong
END


EXECUTE proc_HoaHongNV @thanhTien = 2262000.00

------------------------------------------------------------------------------------------
------------------------------------ FUNCTION --------------------------------------------
------------------------------------------------------------------------------------------

-- 1. Tính số sao trung bình từ các lượt đánh giá của 1 sản phẩm
go
CREATE FUNCTION func_SoSaoTrungBinh (@maSP nvarchar(100))
RETURNS @subTable TABLE
		(
			[Mã Sản Phẩm] nvarchar(100) PRIMARY KEY NOT NULL,
			[Tên Sản Phẩm] nvarchar(150),
			[Trung bình số sao đánh giá] decimal(2,1)
		)

AS
BEGIN
		INSERT @subTable
		SELECT s.MaSP,s.TenSP, AVG(CAST(dg.soSao AS decimal(2,1))) AS N'Đánh giá trung bình (*)'
		FROM SanPham s, KhachHangDanhGiaSP dg
		WHERE s.MaSP=dg.MaSP AND s.MaSP=@maSP
		GROUP BY s.MaSP,s.TenSP

		RETURN
END
go

SELECT * FROM dbo.func_SoSaoTrungBinh('SP018')

-- 2. Tính tổng số hóa đơn của 1 khách hàng 
GO
CREATE FUNCTION func_TongSoHoaDon (@maKH varchar(50))
RETURNS @subTable TABLE
		(
			[Mã Khách Hàng] varchar(50) PRIMARY KEY,
			[Họ và Tên]		nvarchar(150),
			[SĐT]			varchar(20),
			[Địa Chỉ]		nvarchar(250),
			[Giới Tính]		nvarchar(50),
			[Tổng số hóa đơn của khách hàng] int
		)
AS
BEGIN
		INSERT @subTable
		SELECT kh.MaKH,kh.HoTenKH,kh.SDT,kh.DiaChi,kh.GioiTinh, COUNT(hd.MaHoaDon)
		FROM KhachHang kh, HoaDon hd
		WHERE kh.MaKH=hd.MaKH AND kh.MaKH=@maKH
		GROUP BY kh.MaKH,kh.HoTenKH,kh.SDT,kh.DiaChi,kh.GioiTinh

		RETURN
END
GO

SELECT * FROM dbo.func_TongSoHoaDon('KH001')


--3. Tìm ra khách hàng có bậc (Đồng,Bạc,Vàng,Bạch Kim,Kim Cương)

GO
CREATE FUNCTION func_BacCuaKH (@maKH varchar(50))
RETURNS TABLE 
AS
	RETURN (
			SELECT xlv.Hang, kh.MaKH,kh.HoTenKH,kh.SDT,kh.GioiTinh,kh.DiaChi,kh.TongDiemTichLuy
			FROM KhachHang kh, XepLoaiVip xlv
			WHERE kh.MaVip = xlv.MaVip AND kh.MaKH = @maKH
			)
GO

SELECT * FROM dbo.func_BacCuaKH('KH001')

--Số hóa đơn nhân viên bán được trong 1 tháng
CREATE FUNCTION HOADON_NVBANDUOC(@MANV NVARCHAR(30), @thang int)
RETURNS INT
AS
	BEGIN
	RETURN(
		SELECT count(hd.MaHoaDon) 
		FROM HoaDon hd, NhanVien nv
		WHERE hd.MaNV = nv.MaNV AND nv.MaNV = @MANV and MONTH(hd.NgayTaoHoaDon) = @thang
	)
	END
GO

declare @kq int
set @kq = dbo.HOADON_NVBANDUOC('NV03', 12)
print N'Số hóa đơn nhân viên bán được là: ' + cast(@kq as varchar(10))

--Tìm các sp nổi bật theo Danh mục
IF OBJECT_ID('func_CacSPHottheoDanhMuc', 'IF') IS NOT NULL
DROP FUNCTION func_CacSPHottheoDanhMuc
GO
CREATE FUNCTION func_CacSPHottheoDanhMuc(@tenDM nvarchar(30))
RETURNS TABLE 
AS
	RETURN
	(
		SELECT sp.* 
		FROM SanPham sp, DanhMuc dm
		WHERE sp.MaDM = dm.MaDM and dm.TenDM = @tenDM and sp.HOT = 1
	)
GO

SELECT * 
FROM DBO.func_CacSPHottheoDanhMuc(N'Laptop')

-- Tính tổng thành tiền của các hóa đơn
GO
CREATE FUNCTION func_SumTTHoaDon(@tenDM nvarchar(30))
RETURNS TABLE 
AS
	RETURN
	(
		SELECT sp.* 
		FROM SanPham sp, DanhMuc dm
		WHERE sp.MaDM = dm.MaDM and dm.TenDM = @tenDM and sp.HOT = 1
	)
GO


-------------------------------------------------------------------------------------------------------
------------------------------------------  TRIGGER  --------------------------------------------------
-------------------------------------------------------------------------------------------------------
go
CREATE TRIGGER UpdateUnitInStock
ON [dbo].[ChiTietHoaDon]
AFTER INSERT
AS
	BEGIN
		UPDATE [dbo].[SanPham]
		SET	SoLuong = SoLuong - (select i.SoLuong from inserted i where SanPham.MaSP = i.MaSP)
		WHERE dbo.SanPham.MaSP IN (SELECT MaSP FROM inserted)
		--CHỈ CẬP NHẬT NHỮNG SP NÀO CÓ TRONG ĐƠN KHI TA NHẬP
	END
go


go
CREATE TRIGGER UpdateUnitInStock
ON [dbo].[ChiTietHoaDon]
AFTER INSERT
AS
	BEGIN
		UPDATE [dbo].[SanPham]
		SET	SoLuong = SoLuong - (select i.SoLuong from inserted i where SanPham.MaSP = i.MaSP)
		WHERE dbo.SanPham.MaSP IN (SELECT MaSP FROM inserted)
		--CHỈ CẬP NHẬT NHỮNG SP NÀO CÓ TRONG ĐƠN KHI TA NHẬP
	END
go




-- CHỨC NĂNG QUẢN LÝ NHẬP XUẤT KHO

--Chặn không cho cho phép UPDATE số lượng sản phẩm nhỏ hơn 0.
CREATE TRIGGER PreventNegativeSoluong
ON [dbo].[SanPhamTrongKho]
FOR UPDATE 
AS
BEGIN
	--SET NOCOUNT ON
	IF EXISTS(SELECT * FROM inserted i WHERE i.Soluong < 0)
	BEGIN
		ROLLBACK --	Ko cho thực hiện việc update
		RAISERROR(N'Số lượng không thể nhỏ hơn 0', --Messege text
					16, --Serverity
					1	--State
				) 
	END
END

--TEST
UPDATE SanPhamTrongKho 
SET Soluong = -1
WHERE MaSP = 'SP001'


-- Trigger không cho nhập lớn hơn 194 dòng ( 194 nước ) 
go
CREATE TRIGGER TR_CheckInsertionLimitationXuatxu ON XuatXu
FOR INSERT
AS
BEGIN
	--kiểm tra xem trong table Event ko cho vượt quá 5 sự kiện
	--if số MaXX > 5 thì rollback!!!
	
	DECLARE @noCountry int
	SELECT @noCountry = COUNT(*) FROM XuatXu
	--PRINT @noCountry
	IF @noCountry > 5
	BEGIN
		PRINT 'Just only 194 Countries in the World.'
		ROLLBACK
	END
	-- SELECT * FROM INSERTED
END
go

CREATE TRIGGER KiemTraSoLuongSP
ON [dbo].[ChiTietHoaDon]
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM SanPham sp INNER JOIN inserted i ON sp.MaSP = i.MaSP WHERE sp.SoLuong < i.SoLuong)
    BEGIN
        ROLLBACK
		RAISERROR(N'Số Lượng SP trên kệ không đủ', 16, 1)
    END
END

insert ChiTietHoaDon
values('HDHCM000019', 'SP090', 16, 'Còn Hàng')
go