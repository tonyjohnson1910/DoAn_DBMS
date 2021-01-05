CREATE DATABASE dbms_final_proj
GO

-- USE master
-- GO
-- ALTER DATABASE dbms_final_proj SET SINGLE_USER WITH ROLLBACK IMMEDIATE
-- GO
-- DROP DATABASE dbms_final_proj
-- GO

USE dbms_final_proj
GO

-- ///
-- admin_accounts (userid/, uname, upasswd)
-- tho_accounts (userid/, uname, upasswd, acctype)

-- tho_infos (userid/, fname, lname, hinhanh)

-- khachhang (cid/, fname, lname)

-- xe (bienso/, loaixe, hieuxe, hinhanh, cosan)
-- sohuuxe (bienso/, oid/)

-- chitiethd (sohd/, loaihd, ngayhd, ngayhieuluc, ngayhethan, trigiahd)
-- hopdong (sohd/, cid/, bienso/)

-- vexe (bienso/, ngaygiovaoben/, loaive)
-- chamsocxe (bienso/, tho_id/, ngaygiogiaoxe/, noidung)

-- thanhtoanhd (sohd/, fname/, lname/, thoigiantt/, sotien)
-- thanhtoanvexe (bienso/, ngaygiovaoben/, thoigianthanhtoan/, sotien)
-- thanhtoancsx (bienso/, tho_id/, ngaygiogiaoxe/, thoigianthanhtoan/, sotien)

-- bangchamcong (tho_id/, thoigianvaolam/, thoigiantanlam)
-- phieutraluong (tho_id/, thang/, sogiolamviec, tienluong)
-- ///

-- Create tables

CREATE TABLE admin_accounts(
	userid INT IDENTITY(1,1),
	uname VARCHAR(20) UNIQUE NOT NULL,
	upasswd VARCHAR(100) NOT NULL,

	PRIMARY KEY(userid)
)
GO

CREATE TABLE tho_infos(
	userid INT,
	fname NVARCHAR(50) NOT NULL,
	lname NVARCHAR(50) NOT NULL,
	hinhanh IMAGE NOT NULL,

	PRIMARY KEY(userid)
)
GO

CREATE TABLE tho_accounts(
	userid INT IDENTITY(1,1),
	uname VARCHAR(20) UNIQUE NOT NULL,
	upasswd VARCHAR(100) NOT NULL,
	acctype TINYINT NOT NULL,	-- 1: giuxe | 2: chamsocxe

	FOREIGN KEY(userid) REFERENCES dbo.tho_infos(userid),
	PRIMARY KEY(userid)
)

CREATE TABLE khachhang(
	cid VARCHAR(20),	-- cmnd
	fname NVARCHAR(50) NOT NULL,
	lname NVARCHAR(50) NOT NULL,

	PRIMARY KEY(cid)
)
GO

CREATE TABLE xe(
	bienso VARCHAR(20),
	loaixe NVARCHAR(50) NOT NULL,
	hieuxe NVARCHAR(50) NOT NULL,
	hinhanh IMAGE NOT NULL,
	cosan INT NOT NULL, -- 1: Co the cho thue | 0: ko the cho thue

	PRIMARY KEY(bienso)
)
GO

CREATE TABLE sohuuxe(
	bienso VARCHAR(20) REFERENCES dbo.xe(bienso),
	oid VARCHAR(20) REFERENCES dbo.khachhang(cid),	-- cmnd chu xe

	PRIMARY KEY(bienso, oid)
)
GO

CREATE TABLE chitiethd(
	sohd INT IDENTITY(1,1),
	loaihd TINYINT NOT NULL,	-- 1: gui | 2: thue
	ngayhd DATE NOT NULL,
	ngayhieuluc DATE NOT NULL,
	ngayhethan DATE NOT NULL,
	trigiahd MONEY NOT NULL,

	PRIMARY KEY(sohd)
)
GO

CREATE TABLE hopdong(
	sohd INT REFERENCES dbo.chitiethd(sohd),
	cid VARCHAR(20) REFERENCES dbo.khachhang(cid) NOT NULL,
	bienso VARCHAR(20) REFERENCES dbo.xe(bienso) NOT NULL,

	PRIMARY KEY(sohd)
)
GO

CREATE TABLE vexe(
	bienso VARCHAR(20) REFERENCES dbo.xe(bienso),
	ngaygiovaoben DATETIME,
	loaive TINYINT NOT NULL,	-- 1: ve gio | 2: ve ngay | 3: ve tuan | 4: ve thang

	PRIMARY KEY(bienso, ngaygiovaoben)
)
GO

CREATE TABLE chamsocxe(
	bienso VARCHAR(20) REFERENCES dbo.xe(bienso),
	tho_id INT REFERENCES dbo.tho_infos(userid),
	ngaygiogiaoxe DATETIME,
	noidung NTEXT NOT NULL,

	PRIMARY KEY(bienso, tho_id, ngaygiogiaoxe)
)
GO

CREATE TABLE thanhtoanhd(
	sohd INT REFERENCES dbo.chitiethd(sohd),
	fname NVARCHAR(50),
	lname NVARCHAR(50),
	thoigiantt DATETIME,
	sotien MONEY NOT NULL,

	PRIMARY KEY(sohd, fname, lname, thoigiantt)
)
GO

CREATE TABLE thanhtoanvexe(
	bienso VARCHAR(20),
	ngaygiovaoben DATETIME,
	thoigianthanhtoan DATETIME,
	sotien MONEY NOT NULL,

	FOREIGN KEY(bienso) REFERENCES dbo.xe(bienso),
	PRIMARY KEY(bienso, ngaygiovaoben, thoigianthanhtoan)
)
GO

CREATE TABLE thanhtoancsx(
	bienso VARCHAR(20),
	tho_id INT,
	ngaygiogiaoxe DATETIME,
	thoigianthanhtoan DATETIME,
	sotien MONEY NOT NULL,

	FOREIGN KEY(bienso, tho_id, ngaygiogiaoxe) REFERENCES dbo.chamsocxe(bienso, tho_id, ngaygiogiaoxe),
	PRIMARY KEY(bienso, tho_id, ngaygiogiaoxe, thoigianthanhtoan)
)
GO

CREATE TABLE bangchamcong(
	tho_id INT REFERENCES dbo.tho_infos(userid),
	thoigianvaolam DATETIME,
	thoigiantanlam DATETIME,

	PRIMARY KEY(tho_id, thoigianvaolam, thoigiantanlam)
)
GO

CREATE TABLE phieutraluong(
	tho_id INT REFERENCES dbo.tho_infos(userid),
	thang DATE,	-- thang/nam de tinh luong
	sogiolamviec DEC(5,2) NOT NULL,
	tienluong MONEY NOT NULL,

	PRIMARY KEY(tho_id, thang)
)
GO


-- /Create tables

-- Proc and func
-- Nguyen Dinh Phu

-- mỗi lần thợ đến chấm công thì chương trình sẽ truyền vào proc này userid của thợ đó
-- lúc đó thời gian vào làm và tan làm của thợ sẽ được lấy là thời gian hiện tại của database server (do chưa có tan làm nên lấy tạm thời gian hiện tại)
-- mỗi record của bangchamcong là 1 ngày công
CREATE PROC proc_chamcong_vao
@thoid INT
AS
BEGIN
    INSERT dbo.bangchamcong
    (
        tho_id,
        thoigianvaolam,
        thoigiantanlam
    )
    VALUES
    (   0,         -- tho_id - int
        GETDATE(), -- thoigianvaolam - datetime
        GETDATE()  -- thoigiantanlam - datetime
        )
END
GO

-- EXEC proc_chamcong_vao @thoid = 0
-- GO

-- đến cuối ngày thợ đến kết thúc thời gian làm thì sẽ thay đổi thời gian tan làm thành thời điểm hiện tại (trước đó lấy tạm là bằng thời gian vào làm)
-- truyền vào userid của thợ
CREATE PROC proc_chamcong_ra
@thoid INT
AS
BEGIN
	DECLARE @currentDate DATETIME;
	
	SELECT TOP(1) @currentDate = thoigianvaolam
	FROM dbo.bangchamcong
	WHERE tho_id = @thoid
	ORDER BY thoigianvaolam DESC;

	UPDATE dbo.bangchamcong
	SET thoigiantanlam = GETDATE()
	WHERE tho_id = @thoid AND thoigianvaolam = @currentDate;
END
GO

-- EXEC proc_chamcong_ra @thoid = 0
-- GO

-- Tringger thực hiện thay đổi trên bangchamcong khi được update
-- Mỗi khi bảng chấm công được update (do cuối ngày thợ đến kết thúc công việc và cập nhật thời gian tan làm)
-- lúc này trigger giúp cập nhật số  giờ làm việc và lương của thợ trong bảng phiếu trả lương
-- nếu là mùng 1 của tháng thì tạo record phiếu trả lương mới cho tháng đó
CREATE TRIGGER trg_hthanh_ngaycong ON dbo.bangchamcong
AFTER UPDATE
AS
BEGIN
	DECLARE @currentDate INT;
	SET @currentDate = DAY(GETDATE());

	DECLARE @thoid INT, @tgvao DATETIME, @tgra DATETIME;
	SELECT @thoid = Inserted.tho_id, @tgvao = Inserted.thoigianvaolam, @tgra = Inserted.thoigiantanlam
	FROM Inserted;

	DECLARE @sogio DEC(5,2);
	SET @sogio = DATEPART(HOUR,@tgra) - DATEPART(HOUR,@tgvao);

	IF @currentDate = 1
	BEGIN
	    INSERT dbo.phieutraluong
	    (
	        tho_id,
	        thang,
	        sogiolamviec,
	        tienluong
	    )
	    VALUES
	    (   @thoid,         -- tho_id - int
	        GETDATE(), -- thang - date
	        @sogio,      -- sogiolamviec - dec(5, 2)
	        @sogio * 40       -- tienluong - money
	        );
	END;
	ELSE
	BEGIN
	    UPDATE dbo.phieutraluong
		SET sogiolamviec = sogiolamviec + @sogio, tienluong = sogiolamviec * 40
		WHERE tho_id = @thoid AND MONTH(thang) = MONTH(GETDATE()) AND YEAR(thang) = YEAR(GETDATE());
	END;
END
GO

-- function truyền vào userid của thợ, lấy ra số tiền lương tháng hiện tại của thợ đó
CREATE FUNCTION func_getLuong (@thoid INT)
RETURNS DEC(5,2)
AS
BEGIN
    DECLARE @outLuong DEC(5,2);

	SELECT TOP(1) @outLuong = tienluong
	FROM dbo.phieutraluong
	WHERE tho_id = @thoid
	ORDER BY thang DESC;

	RETURN @outLuong;
END
GO

-- SELECT func_getLuong(0)
-- GO

-- thêm 1 thợ mới vào database gồm các thông tin cần thiết như username, password, acctype (loại tài khoản hay còn gọi là chức vụ), họ, tên và avatar
CREATE PROC proc_insTho
@uname VARCHAR(20), @passwd VARCHAR(100), @acctype TINYINT, @fname NVARCHAR(50), @lname NVARCHAR(50), @img IMAGE
AS
BEGIN
	BEGIN TRAN;
    INSERT dbo.tho_accounts
    (
        uname,
        upasswd,
        acctype
    )
    VALUES
    (   @uname, -- uname - varchar(20)
        @passwd, -- upasswd - varchar(100)
        @acctype   -- acctype - tinyint
        );
	
	DECLARE @lastuid INT;
	SELECT TOP(1) @lastuid = userid
	FROM dbo.tho_accounts
	ORDER BY userid DESC;

	INSERT dbo.tho_infos
	(
	    userid,
	    fname,
	    lname,
	    hinhanh
	)
	VALUES
	(   @lastuid,   -- userid - int
	    @fname, -- fname - nvarchar(50)
	    @lname, -- lname - nvarchar(50)
	    @img -- hinhanh - image
	    );
	COMMIT TRAN;
END
GO

-- EXEC dbo.proc_insTho @uname = '', @passwd = '', @acctype = 0, @fname = N'', @lname = N'', @img = NULL
-- GO

-- thay đổi avatar của thợ, truyền vào userid và avatar mới của thợ cần thay đổi avatar
CREATE PROC proc_editThoImage
@uid INT, @img IMAGE
AS
BEGIN
    UPDATE dbo.tho_infos
	SET hinhanh = @img
	WHERE userid = @uid;
END
GO

-- EXEC dbo.proc_editThoImage @uid = 0, @img = NULL
-- GO

-- thay đổi password của thợ, truyền vào userid của thợ cần đổi password và password mới
CREATE PROC proc_changeThoPasswd
@uid INT, @passwd VARCHAR(100)
AS
BEGIN
    UPDATE dbo.tho_accounts
	SET upasswd = @passwd
	WHERE userid = @uid;
END
GO

-- EXEC dbo.proc_changeThoPasswd @uid = 0, @passwd = ''
-- GO

-- Xóa thợ khỏi database gồm tho_infos và tho_accounts của thợ đó
-- truyền vào userid của thợ cần xóa
CREATE PROC proc_delTho
@uid INT
AS
BEGIN
    DELETE FROM dbo.tho_infos
	WHERE userid = @uid;
	DELETE FROM dbo.tho_accounts
	WHERE userid = @uid;
END
GO

-- EXEC dbo.proc_delTho @uid = 0 -- int
-- GO
