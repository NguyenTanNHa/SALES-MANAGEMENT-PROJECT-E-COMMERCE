-- Tạo cơ sở dữ liệu shoppor
CREATE DATABASE shoppor;
GO

-- Sử dụng cơ sở dữ liệu shoppor
USE shoppor;
GO

-- Bảng NHÂN VIÊN
CREATE TABLE NHANVIEN (
    MANV NVARCHAR(50) NOT NULL PRIMARY KEY,
    HOTEN NVARCHAR(50) NOT NULL,
    EMAIL NVARCHAR(50) NOT NULL,
    MATKHAU NVARCHAR(50) NULL
);

-- Bảng KHÁCH HÀNG
CREATE TABLE KHACHHANG (
    MAKH NVARCHAR(20) NOT NULL PRIMARY KEY,
    MATKHAU NVARCHAR(50) NULL,
    HOTEN NVARCHAR(50) NOT NULL,
    GIOITINH BIT NOT NULL,
    NGAYSINH DATETIME NOT NULL,
    DIACHI NVARCHAR(60) NULL,
    DIENTHOAI NVARCHAR(24) NULL,
    EMAIL NVARCHAR(50) NOT NULL,
    HINH NVARCHAR(50) NULL,
    HIEULUC BIT NOT NULL,
    VAITRO INT NOT NULL,
    RANDOMKEY VARCHAR(50) NULL
);

-- Bảng LOẠI HÀNG
CREATE TABLE LOAI (
    MaLoai INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TenLoai NVARCHAR(50) NOT NULL,
    TenLoaiAlias NVARCHAR(50) NULL,
    MoTa NVARCHAR(MAX) NULL,
    Hinh NVARCHAR(50) NULL
);

-- Bảng NHÀ CUNG CẤP
CREATE TABLE NHACUNGCAP (
    MaNCC NVARCHAR(50) NOT NULL PRIMARY KEY,
    TenCongTy NVARCHAR(50) NOT NULL,
    Logo NVARCHAR(50) NOT NULL,
    NguoiLienLac NVARCHAR(50) NULL,
    Email NVARCHAR(50) NOT NULL,
    DienThoai NVARCHAR(50) NULL,
    DiaChi NVARCHAR(50) NULL,
    MoTa NVARCHAR(MAX) NULL
);

CREATE TABLE HANGHOA (
    MaHH INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- Khóa chính
    TenHH NVARCHAR(50) NOT NULL,                 -- Tên hàng hóa
    TenAlias NVARCHAR(50) NULL,                  -- Tên khác (Alias)
    MaLoai INT NOT NULL,                         -- Loại hàng hóa (Khóa ngoại)
    MoTaDonVi NVARCHAR(50) NULL,                 -- Mô tả đơn vị
    DonGia FLOAT NULL,                           -- Đơn giá
    Hinh NVARCHAR(50) NULL,                      -- Đường dẫn hình ảnh
    NgaySX DATETIME NOT NULL,                    -- Ngày sản xuất
    GiamGia FLOAT NOT NULL,                      -- Tỷ lệ giảm giá
    SoLanXem INT NOT NULL,                       -- Số lần xem
    MoTa NVARCHAR(MAX) NULL,                     -- Mô tả chi tiết
    MaNCC NVARCHAR(50) NOT NULL,                 -- Mã nhà cung cấp (Khóa ngoại)
    Danhgia NVARCHAR(50) NOT NULL,               -- Đánh giá

    -- Thiết lập khóa ngoại
    CONSTRAINT FK_HANGHOA_LOAI FOREIGN KEY (MaLoai) REFERENCES LOAI(MaLoai),
    CONSTRAINT FK_HANGHOA_NHACUNGCAP FOREIGN KEY (MaNCC) REFERENCES NHACUNGCAP(MaNCC)
);


CREATE TABLE SOLUONG (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,   -- Khóa chính
    MaHH INT NOT NULL,                           -- Mã hàng hóa (Khóa ngoại)
    Soluong INT NOT NULL,                        -- Số lượng
    DateCreated DATETIME NOT NULL,               -- Ngày tạo

    -- Thiết lập khóa ngoại
    CONSTRAINT FK_SOLUONG_HANGHOA FOREIGN KEY (MaHH) REFERENCES HANGHOA(MaHH)
);

-- Bảng TRẠNG THÁI
CREATE TABLE TrangThai (
    MaTrangThai INT NOT NULL PRIMARY KEY,
    TenTrangThai NVARCHAR(50) NOT NULL,
    MoTa NVARCHAR(500) NULL
);

-- Bảng HÓA ĐƠN
CREATE TABLE HOADON (
    MaHD INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    MaKH NVARCHAR(20) NOT NULL FOREIGN KEY REFERENCES KHACHHANG(MaKH),
    NgayDat DATETIME NOT NULL,
    NgayCan DATETIME NULL,
    NgayGiao DATETIME NULL,
    HoTen NVARCHAR(50) NULL,
    DiaChi NVARCHAR(60) NOT NULL,
    CachThanhToan NVARCHAR(50) NOT NULL,
    CachVanChuyen NVARCHAR(50) NOT NULL,
    PhiVanChuyen FLOAT NOT NULL,
    MaTrangThai INT NOT NULL FOREIGN KEY REFERENCES TrangThai(MaTrangThai),
    MaNV NVARCHAR(50) NULL FOREIGN KEY REFERENCES NHANVIEN(MANV),
    GhiChu NVARCHAR(150) NULL
);

-- Bảng CHI TIẾT HÓA ĐƠN
CREATE TABLE CHITIETHD (
    MaCT INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    MaHD INT NOT NULL FOREIGN KEY REFERENCES HOADON(MaHD),
    MaHH INT NOT NULL FOREIGN KEY REFERENCES HANGHOA(MaHH),
    DonGia FLOAT NOT NULL,
    SoLuong INT NOT NULL,
    GiamGia FLOAT NOT NULL
);

-- Bảng YÊU THÍCH
CREATE TABLE YEUTHICH (
    MaYT INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    MaHH INT NULL FOREIGN KEY REFERENCES HANGHOA(MaHH),
    MaKH NVARCHAR(20) NULL FOREIGN KEY REFERENCES KHACHHANG(MaKH),
    NgayChon DATETIME NULL,
    MoTa NVARCHAR(255) NULL
);

-- Bảng GÓP Ý
CREATE TABLE GOPY (
    MaGY NVARCHAR(50) NOT NULL PRIMARY KEY,
    MaCD INT NOT NULL,
    NoiDung NVARCHAR(MAX) NOT NULL,
    NgayGY DATE NOT NULL,
    HoTen NVARCHAR(50) NULL,
    Email NVARCHAR(50) NULL,
    DienThoai NVARCHAR(50) NULL,
    CanTraLoi BIT NOT NULL,
    TraLoi NVARCHAR(50) NULL,
    NgayTL DATE NULL
);


-- Bảng PHÂN CÔNG
CREATE TABLE PhanCong (
    MaPC INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    MaNV NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES NHANVIEN(MANV),
    MaPB VARCHAR(7) NOT NULL,
    NgayPC DATETIME NULL,
    HieuLuc BIT NULL
);

-- Bảng PHÂN QUYỀN
CREATE TABLE PhanQuyen (
    MaPQ INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    MaPB VARCHAR(7) NULL,
    MaTrang INT NULL,
    Them BIT NOT NULL,
    Sua BIT NOT NULL,
    Xoa BIT NOT NULL,
    Xem BIT NOT NULL
);
CREATE TABLE CONTACT (
	UserName Nvarchar(50),
	Email Nvarchar(50),
	Message Nvarchar(100),
	Image Nvarchar(50)
);
-- Thêm dữ liệu mẫu cho bảng NHANVIEN
INSERT INTO NHANVIEN (MANV, HOTEN, EMAIL, MATKHAU)
VALUES 
('NV001', N'Nguyễn Văn A', 'a.nguyen@shoppor.com', 'password123'),
('NV002', N'Trần Thị B', 'b.tran@shoppor.com', 'password456'),
('NV003', N'Lê Văn C', 'c.le@shoppor.com', 'password789');

-- Thêm dữ liệu mẫu cho bảng KHACHHANG
INSERT INTO KHACHHANG (MAKH, MATKHAU, HOTEN, GIOITINH, NGAYSINH, DIACHI, DIENTHOAI, EMAIL, HINH, HIEULUC, VAITRO, RANDOMKEY)
VALUES 
('KH001', 'customer123', N'Nguyễn Thị D', 0, '1990-05-20', N'Hà Nội', '0987654321', 'd.nguyen@gmail.com', 'kh001.jpg', 1, 0, NULL),
('KH002', 'customer456', N'Phạm Văn E', 1, '1985-07-15', N'TP Hồ Chí Minh', '0976543210', 'e.pham@gmail.com', 'kh002.jpg', 1, 0, NULL);

-- Thêm dữ liệu mẫu cho bảng LOAI
INSERT INTO LOAI (TenLoai, TenLoaiAlias, MoTa, Hinh)
VALUES 
(N'Điện thoại', 'dien-thoai', N'Các sản phẩm điện thoại di động', 'dienthoai.jpg'),
(N'Laptop', 'laptop', N'Các sản phẩm máy tính xách tay', 'laptop.jpg'),
(N'Phụ kiện', 'phu-kien', N'Các loại phụ kiện', 'phukien.jpg'),
(N'Quần', 'quan', N'Các loại quần thời trang', 'quan.jpg'),
(N'Áo', 'ao', N'Các loại áo thời trang', 'ao.jpg'),
(N'Đồ Gia Dụng', 'do-gia-dung', N'Các sản phẩm đồ gia dụng', 'dogiadung.jpg');

-- Thêm dữ liệu mẫu cho bảng NHACUNGCAP
INSERT INTO NHACUNGCAP (MaNCC, TenCongTy, Logo, NguoiLienLac, Email, DienThoai, DiaChi, MoTa)
VALUES 
('NCC001', N'Công ty Điện Tử ABC', 'dientu.jpg', N'Nguyễn Văn H', 'contact@abc.com', '0931234567', N'Hà Nội', N'Nhà cung cấp điện tử lớn nhất'),
('NCC002', N'Công ty Công Nghệ XYZ', 'congnghe.jpg', N'Trần Thị K', 'support@xyz.com', '0945678901', N'TP Hồ Chí Minh', N'Nhà cung cấp các sản phẩm công nghệ');

-- Thêm dữ liệu mẫu cho bảng HANGHOA
INSERT INTO HANGHOA (TenHH, TenAlias, MaLoai, MoTaDonVi, DonGia, Hinh, NgaySX, GiamGia, SoLanXem, MoTa, MaNCC, Danhgia)
VALUES 
('iPhone 14 Pro', 'iphone-14-pro', 1, 'Chiếc', 29990000, 'iphone14pro.jpg', '2024-01-01', 5, 500, N'Điện thoại cao cấp của Apple', 'NCC001', '5 sao'),
('Samsung Galaxy S23', 'samsung-galaxy-s23', 1, 'Chiếc', 25990000, 'galaxys23.jpg', '2024-02-01', 10, 400, N'Điện thoại flagship của Samsung', 'NCC002', '4.8 sao'),
('Xiaomi 13 Pro', 'xiaomi-13-pro', 1, 'Chiếc', 19990000, 'xiaomi13pro.jpg', '2024-03-01', 10, 350, N'Điện thoại cấu hình mạnh mẽ', 'NCC001', '4.5 sao'),
('OPPO Reno 10', 'oppo-reno-10', 1, 'Chiếc', 10990000, 'opporeno10.jpg', '2024-04-01', 15, 300, N'Điện thoại camera đẹp', 'NCC002', '4.6 sao'),
('Vivo V27', 'vivo-v27', 1, 'Chiếc', 8990000, 'vivoV27.jpg', '2024-05-01', 20, 250, N'Điện thoại thời trang', 'NCC001', '4.7 sao'),
('Realme GT Neo 5', 'realme-gt-neo-5', 1, 'Chiếc', 14990000, 'realmegtneo5.jpg', '2024-06-01', 10, 200, N'Điện thoại hiệu năng cao', 'NCC002', '4.5 sao'),
('Google Pixel 7', 'google-pixel-7', 1, 'Chiếc', 17990000, 'googlepixel7.jpg', '2024-07-01', 5, 180, N'Điện thoại với camera AI', 'NCC001', '4.8 sao'),
('Asus ROG Phone 7', 'asus-rog-phone-7', 1, 'Chiếc', 27990000, 'asusrogphone7.jpg', '2024-08-01', 10, 150, N'Điện thoại chơi game tốt nhất', 'NCC002', '5 sao'),
('Nokia X30', 'nokia-x30', 1, 'Chiếc', 11990000, 'nokiax30.jpg', '2024-09-01', 20, 120, N'Điện thoại bền bỉ', 'NCC001', '4.4 sao'),
('Sony Xperia 1 V', 'sony-xperia-1-v', 1, 'Chiếc', 34990000, 'sonyxperia1v.jpg', '2024-10-01', 5, 100, N'Điện thoại flagship Sony', 'NCC002', '4.9 sao'),
('MacBook Air M2', 'macbook-air-m2', 2, 'Chiếc', 29999000, 'macbook_air.jpg', '2023-06-01', 15, 300, N'Laptop siêu mỏng và nhẹ', 'NCC002', '4.5 sao'),
('AirPods Pro 2', 'airpods-pro-2', 3, 'Chiếc', 6990000, 'airpodspro2.jpg', '2024-01-01', 5, 500, N'Tai nghe không dây cao cấp của Apple', 'NCC001', '5 sao'),
('Sony WH-1000XM5', 'sony-wh-1000xm5', 3, 'Chiếc', 8990000, 'sonywh1000xm5.jpg', '2024-02-01', 10, 400, N'Tai nghe chống ồn tốt nhất', 'NCC002', '4.9 sao'),
('Bose QuietComfort 45', 'bose-quietcomfort-45', 3, 'Chiếc', 8990000, 'boseqc45.jpg', '2024-03-01', 10, 350, N'Tai nghe chống ồn cao cấp', 'NCC001', '4.8 sao'),
('Jabra Elite 7 Pro', 'jabra-elite-7-pro', 3, 'Chiếc', 5990000, 'jabraelite7pro.jpg', '2024-04-01', 15, 300, N'Tai nghe không dây chống nước', 'NCC002', '4.7 sao'),
('Sennheiser Momentum 4', 'sennheiser-momentum-4', 3, 'Chiếc', 7990000, 'momentum4.jpg', '2024-05-01', 20, 250, N'Tai nghe không dây âm thanh tốt', 'NCC001', '4.9 sao'),
('Beats Studio Buds+', 'beats-studio-buds-plus', 3, 'Chiếc', 4990000, 'beatsstudiobudsplus.jpg', '2024-06-01', 15, 200, N'Tai nghe in-ear cao cấp', 'NCC002', '4.6 sao'),
('Quần Jeans Nam', 'quan-jeans-nam', 4, 'Chiếc', 499000, 'quan_jeans.jpg', '2024-01-01', 10, 100, N'Quần jeans nam thời trang', 'NCC001', '4.5 sao'),
('Quần Kaki Nam', 'quan-kaki-nam', 4, 'Chiếc', 399000, 'quan_kaki.jpg', '2024-02-01', 15, 120, N'Quần kaki nam chất lượng cao', 'NCC002', '5 sao'),
('Quần Short Nam', 'quan-short-nam', 4, 'Chiếc', 299000, 'quan_short.jpg', '2024-03-01', 5, 80, N'Quần short nam thoáng mát', 'NCC001', '4 sao'),
('Quần Jeans Nữ', 'quan-jeans-nu', 4, 'Chiếc', 449000, 'quan_jeans_nu.jpg', '2024-01-05', 10, 90, N'Quần jeans nữ thời trang', 'NCC002', '4.5 sao'),
('Quần Kaki Nữ', 'quan-kaki-nu', 4, 'Chiếc', 399000, 'quan_kaki_nu.jpg', '2024-02-10', 10, 70, N'Quần kaki nữ phong cách', 'NCC001', '5 sao'),
('Quần Short Nữ', 'quan-short-nu', 4, 'Chiếc', 299000, 'quan_short_nu.jpg', '2024-03-20', 5, 60, N'Quần short nữ thoải mái', 'NCC002', '4 sao'),
('Quần Thể Thao Nam', 'quan-the-thao-nam', 4, 'Chiếc', 250000, 'quan_the_thao_nam.jpg', '2024-04-01', 15, 100, N'Quần thể thao nam co giãn', 'NCC001', '4.5 sao'),
('Quần Thể Thao Nữ', 'quan-the-thao-nu', 4, 'Chiếc', 250000, 'quan_the_thao_nu.jpg', '2024-05-01', 15, 110, N'Quần thể thao nữ năng động', 'NCC002', '5 sao'),
('Quần Tây Nam', 'quan-tay-nam', 4, 'Chiếc', 550000, 'quan_tay_nam.jpg', '2024-01-15', 10, 50, N'Quần tây nam sang trọng', 'NCC001', '5 sao'),
('Quần Tây Nữ', 'quan-tay-nu', 4, 'Chiếc', 550000, 'quan_tay_nu.jpg', '2024-02-15', 10, 60, N'Quần tây nữ lịch sự', 'NCC002', '4.5 sao'),
('Áo Sơ Mi Nam', 'ao-so-mi-nam', 5, 'Chiếc', 299000, 'ao_so_mi_nam.jpg', '2024-01-01', 10, 120, N'Áo sơ mi nam lịch lãm', 'NCC001', '5 sao'),
('Áo Polo Nam', 'ao-polo-nam', 5, 'Chiếc', 399000, 'ao_polo_nam.jpg', '2024-02-01', 15, 130, N'Áo polo nam cao cấp', 'NCC002', '4.5 sao'),
('Áo Thun Nam', 'ao-thun-nam', 5, 'Chiếc', 199000, 'ao_thun_nam.jpg', '2024-03-01', 5, 140, N'Áo thun nam thoải mái', 'NCC001', '4 sao'),
('Áo Sơ Mi Nữ', 'ao-so-mi-nu', 5, 'Chiếc', 349000, 'ao_so_mi_nu.jpg', '2024-01-05', 10, 100, N'Áo sơ mi nữ thanh lịch', 'NCC002', '5 sao'),
('Áo Polo Nữ', 'ao-polo-nu', 5, 'Chiếc', 399000, 'ao_polo_nu.jpg', '2024-02-10', 15, 90, N'Áo polo nữ phong cách', 'NCC001', '4.5 sao'),
('Áo Thun Nữ', 'ao-thun-nu', 5, 'Chiếc', 199000, 'ao_thun_nu.jpg', '2024-03-20', 5, 80, N'Áo thun nữ thoáng mát', 'NCC002', '4 sao'),
('Áo Khoác Nam', 'ao-khoac-nam', 5, 'Chiếc', 599000, 'ao_khoac_nam.jpg', '2024-04-01', 10, 70, N'Áo khoác nam giữ ấm', 'NCC001', '5 sao'),
('Áo Khoác Nữ', 'ao-khoac-nu', 5, 'Chiếc', 599000, 'ao_khoac_nu.jpg', '2024-05-01', 10, 75, N'Áo khoác nữ thời trang', 'NCC002', '4.5 sao'),
('Áo Vest Nam', 'ao-vest-nam', 5, 'Chiếc', 999000, 'ao_vest_nam.jpg', '2024-01-15', 15, 60, N'Áo vest nam cao cấp', 'NCC001', '5 sao'),
('Áo Vest Nữ', 'ao-vest-nu', 5, 'Chiếc', 999000, 'ao_vest_nu.jpg', '2024-02-15', 15, 65, N'Áo vest nữ sang trọng', 'NCC002', '4.5 sao'),
('Nồi Chiên Không Dầu', 'noi-chien-khong-dau', 6, 'Chiếc', 2999000, 'noi_chien_khong_dau.jpg', '2024-01-01', 10, 150, N'Nồi chiên không dầu tiện lợi', 'NCC001', '5 sao'),
('Máy Hút Bụi', 'may-hut-bui', 6, 'Chiếc', 4999000, 'may_hut_bui.jpg', '2024-02-01', 15, 140, N'Máy hút bụi công suất lớn', 'NCC002', '4.5 sao'),
('Bếp Điện Từ', 'bep-dien-tu', 6, 'Chiếc', 3999000, 'bep_dien_tu.jpg', '2024-03-01', 10, 130, N'Bếp điện từ an toàn', 'NCC001', '5 sao'),
('Quạt Điện', 'quat-dien', 6, 'Chiếc', 999000, 'quat_dien.jpg', '2024-01-05', 5, 120, N'Quạt điện làm mát hiệu quả', 'NCC002', '4 sao'),
('Đèn Bàn Học', 'den-ban-hoc', 6, 'Chiếc', 499000, 'den_ban_hoc.jpg', '2024-02-10', 10, 110, N'Đèn bàn học chống cận', 'NCC001', '4.5 sao'),
('Máy Giặt', 'may-giat', 6, 'Chiếc', 8999000, 'may_giat.jpg', '2024-03-20', 15, 100, N'Máy giặt tự động hiện đại', 'NCC002', '5 sao'),
('Tủ Lạnh', 'tu-lanh', 6, 'Chiếc', 12999000, 'tu_lanh.jpg', '2024-04-01', 10, 90, N'Tủ lạnh tiết kiệm điện', 'NCC001', '5 sao'),
('Máy Lọc Nước', 'may-loc-nuoc', 6, 'Chiếc', 6999000, 'may_loc_nuoc.jpg', '2024-05-01', 10, 80, N'Máy lọc nước tinh khiết', 'NCC002', '4.5 sao'),
('Bàn Ủi Hơi Nước', 'ban-ui-hoi-nuoc', 6, 'Chiếc', 999000, 'ban_ui_hoi_nuoc.jpg', '2024-01-15', 5, 70, N'Bàn ủi hơi nước công suất cao', 'NCC001', '4 sao'),
('Ấm Siêu Tốc', 'am-sieu-toc', 6, 'Chiếc', 399000, 'am_sieu_toc.jpg', '2024-02-15', 10, 60, N'Ấm siêu tốc đun nước nhanh', 'NCC002', '5 sao');


-- Thêm dữ liệu mẫu vào bảng SOLUONG
INSERT INTO SOLUONG (Soluong, MaHH, DateCreated)
VALUES 
(100, 1, '2024-12-01'), -- iPhone 14 Pro
(50, 2, '2024-12-02'), -- Samsung Galaxy S23
(75, 3, '2024-12-03'), -- Xiaomi 13 Pro
(30, 4, '2024-12-04'), -- OPPO Reno 10
(60, 5, '2024-12-05'), -- Vivo V27
(40, 6, '2024-12-06'), -- Realme GT Neo 5
(20, 7, '2024-12-07'), -- Google Pixel 7
(10, 8, '2024-12-08'), -- Asus ROG Phone 7
(90, 9, '2024-12-09'), -- Nokia X30
(15, 10, '2024-12-10'); -- Sony Xperia 1 V


-- Thêm dữ liệu mẫu cho bảng TrangThai
INSERT INTO TrangThai (MaTrangThai, TenTrangThai, MoTa)
VALUES 
(1, N'Đang xử lý', N'Hóa đơn đang được xử lý'),
(2, N'Đã giao hàng', N'Hóa đơn đã được giao đến khách hàng'),
(3, N'Đã hủy', N'Hóa đơn bị hủy bởi khách hàng hoặc hệ thống');

-- Thêm dữ liệu mẫu cho bảng HOADON
INSERT INTO HOADON (MaKH, NgayDat, NgayCan, NgayGiao, HoTen, DiaChi, CachThanhToan, CachVanChuyen, PhiVanChuyen, MaTrangThai, MaNV, GhiChu)
VALUES 
('KH001', '2024-11-01', '2024-11-05', NULL, N'Nguyễn Thị D', 'Hà Nội', N'Thanh toán khi nhận hàng', N'Giao hàng nhanh', 30000, 1, 'NV001', N'Giao vào buổi sáng'),
('KH002', '2024-11-02', NULL, '2024-11-06', N'Phạm Văn E', 'TP Hồ Chí Minh', N'Chuyển khoản ngân hàng', N'Giao hàng tiêu chuẩn', 20000, 2, 'NV002', N'Hóa đơn VIP');

-- Thêm dữ liệu mẫu cho bảng CHITIETHD
INSERT INTO CHITIETHD (MaHD, MaHH, DonGia, SoLuong, GiamGia)
VALUES 
(1, 1, 29999000, 1, 10),
(1, 3, 1299000, 2, 5),
(2, 2, 29999000, 1, 15);

-- Thêm dữ liệu mẫu cho bảng YEUTHICH
INSERT INTO YEUTHICH (MaHH, MaKH, NgayChon, MoTa)
VALUES 
(1, 'KH001', '2024-11-10', N'Rất thích sản phẩm này'),
(3, 'KH002', '2024-11-12', N'Muốn mua trong đợt giảm giá');

-- Thêm dữ liệu mẫu cho bảng GOPY
INSERT INTO GOPY (MaGY, MaCD, NoiDung, NgayGY, HoTen, Email, DienThoai, CanTraLoi, TraLoi, NgayTL)
VALUES 
('GY001', 1, N'Sản phẩm rất tốt nhưng giao hàng hơi chậm.', '2024-11-11', N'Nguyễn Thị D', 'd.nguyen@gmail.com', '0987654321', 1, N'Cảm ơn góp ý của bạn!', '2024-11-12');

-- Thêm dữ liệu mẫu cho bảng BanBe
INSERT INTO BanBe (MaKH, MaHH, HoTen, Email, NgayGui, GhiChu)
VALUES 
('KH001', 1, N'Lê Văn F', 'thienluong@gmail.com', '2024-11-15', N'Tôi nghĩ bạn sẽ thích sản phẩm này!');
