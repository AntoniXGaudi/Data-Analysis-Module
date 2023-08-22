drop procedure print_hello_world

create procedure print_hello_world as 
	begin
		select 'hello world 2'
	end;

exec print_hello_world


drop proc print_hello_world

create proc print_hello_world as 
	begin
		select 'hello world 2'
	end;

execute print_hello_world

alter proc print_hello_world as 
	begin
		print 'hello world 3'
	end;

exec print_hello_world


print_hello_world


create table new_updates (
	update_column  varchar(20),
	update_time    datetime
			);


insert into new_updates (update_column, update_time)
values ('new update', getdate())


select * from new_updates



CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);



INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )


SELECT * FROM ORDER_TBL

CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);



SET NOCOUNT ON
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )



create proc sp_sum_order as
	begin

		SELECT COUNT (ORDER_ID) AS TOTAL_ORDER FROM ORDER_TBL
	end

exec sp_sum_order


select *
from ORDER_TBL
where order_date = '2023-05-12'

create proc sp_wantedday_order
	(@DAY date)
as
begin
	select *
	from ORDER_TBL
	where order_date = @DAY
end ;

exec sp_wantedday_order '2023-05-12'


declare @p1 int, @p2 int, @sum int
set @p1 = 5
select @p2 = 4
select @sum = @p1 + @p2 
select @sum



declare @sum int
set @sum = 4

select @sum

select sum()


declare @order_date date = getdate()
select *
	from ORDER_TBL
	where order_date = @order_date



DECLARE @CUST_ID INT = 2

SELECT *
FROM
ORDER_TBL 
WHERE
CUSTOMER_ID = @CUST_ID


IF 
ELSE IF 
ELSE


DECLARE @CUST_ID INT
SET @CUST_ID = 3

--DECLARE @CUST_ID INT = 3

IF @CUST_ID < 3
	BEGIN
		SELECT *
		FROM
		ORDER_TBL
		WHERE
		CUSTOMER_ID = @CUST_ID
	END
ELSE IF @CUST_ID > 3
	BEGIN
		SELECT *
		FROM
		ORDER_TBL
		WHERE
		CUSTOMER_ID = @CUST_ID		
	END
ELSE
	PRINT 'THE CUSTOMER ID EQUAL TO 3'


declare @order_date date = getdate()

PRINT 'orders from past'
drop table if exists historic_orders
select *
into historic_orders
from ORDER_TBL
where order_date < @order_date

PRINT 'orders from today'

drop table if exists current_orders
declare @order_date date = getdate()
select *
into current_orders
from ORDER_TBL
where order_date = @order_date


DECLARE @NUM_OF_ITER INT = 50 , @COUNTER INT = 0

WHILE @NUM_OF_ITER > @COUNTER

	BEGIN

		SELECT @COUNTER
		SET @COUNTER += 1
	
	END

select @counter 



DECLARE  @CUST_ID INT = 1

WHILE @CUST_ID < 4

	BEGIN

	SELECT *
		FROM
		ORDER_TBL
		WHERE
		CUSTOMER_ID = @CUST_ID
		set @CUST_ID +=1
	END


	SELECT sum(order_id)
		FROM
		ORDER_TBL

select * 
from ORDER_TBL


CREATE FUNCTION fnc_uppertext
(
	@inputtext varchar (MAX)
)
RETURNS VARCHAR (MAX)
AS
BEGIN
	RETURN UPPER(@inputtext)
END

select dbo.fnc_uppertext('whats up')

SELECT CUSTOMER_NAME, dbo.fnc_uppertext(CUSTOMER_NAME) FROM ORDER_TBL

select CUSTOMER_NAME, UPPER(CUSTOMER_NAME) from ORDER_TBL


select * 
from ORDER_TBL



CREATE FUNCTION dbo.statusoforderdelivery
(
	@ORDER INT
)
RETURNS VARCHAR (10)
AS
BEGIN
	
	DECLARE @EST_DATE DATE
	DECLARE @DEL_DATE DATE 
	DECLARE @STATUS VARCHAR (10)
	
	SELECT @EST_DATE = EST_DELIVERY_DATE -- @EST_DATE değişkenine değer atıyoruz. bu değer her order_id için değişecektir. Burada select ile bir tablodan değişkene değer atamayı örneklendirmiş olduk.
	FROM ORDER_TBL 
	WHERE ORDER_ID = @ORDER -- input olarak verilen order id' nin tabloda bulunabilmesi için eşitleme yapıyoruz. 
	
	SET @DEL_DATE = (SELECT DELIVERY_DATE FROM ORDER_DELIVERY WHERE ORDER_ID= @ORDER)-- @DEL_DATE değişkenine değer atıyoruz. Bu değer de her order_id için değişecektir. Burada da set ile bir tablodan değişkene değer atamayı örneklendirmiş olduk.


	IF @EST_DATE < @DEL_DATE-- Buradan sonra if else yapısıyla status çıktı değişkeninin farklı durumlar için alacağı değerleri belirliyoruz.
		
		SET @STATUS = 'LATE'-- üst satırla bu satırın okunması: eğer @EST_DATE küçük ise @DEL_DATE' ten Statusu 'LATE' olarak tanımla
	
	ELSE IF @EST_DATE > @DEL_DATE

		SET @STATUS = 'EARLY'

	ELSE
		SET @STATUS = 'ON TIME'
		
RETURN @STATUS--Fonksiyon sonucunda getireceği değerin ne olduğunu tanımlıyor ve end ile tamamlıyoruz.

END;

SELECT * FROM ORDER_TBL WHERE dbo.statusoforderdelivery(ORDER_ID) = 'ON TIME'

CREATE TABLE ON_TIME_ORDER
(
ORDER_ID INT,
DELIVERY_STATUS VARCHAR(10),
CONSTRAINT check_status CHECK (dbo.statusoforderdelivery(ORDER_ID) = 'ON TIME')--Eğer insert edilecek order_id' nin statusu ON TIME ise insert işlemini tamamla
)

select * from ON_TIME_ORDER


INSERT INTO  ON_TIME_ORDER (ORDER_ID, DELIVERY_STATUS) VALUES (4, 'ON TIME')

INSERT INTO  ON_TIME_ORDER (ORDER_ID, DELIVERY_STATUS) VALUES (7, 'ON TIME')


--Bu fonksiyon girilen bir order_id' nin ON_TIME_ORDER tablosundaki değerlerini tablo olarak getirir.
CREATE FUNCTION dbo.sample_tbl_valued
(
	@ORDER_ID INT
)
RETURNS TABLE --Getirilecek değerin bir tablo olduğunu belirtiyoruz.
AS
	RETURN SELECT * FROM ON_TIME_ORDER WHERE ORDER_ID = @ORDER_ID


	--fonksiyonu bir tablo olarak kullanıyoruz.
SELECT * FROM dbo.sample_tbl_valued (7)


SELECT * FROM ON_TIME_ORDER




CREATE FUNCTION dbo.Haversine (@point_a geography, @point_b geography) RETURNS FLOAT AS BEGIN
    DECLARE @result FLOAT
    DECLARE @lat1 FLOAT = @point_a.Lat
    DECLARE @lon1 FLOAT = @point_a.Long
    DECLARE @lat2 FLOAT = @point_b.Lat
    DECLARE @lon2 FLOAT = @POINT_b.Long

    DECLARE @earth_radius FLOAT = 6371
    DECLARE @dLat FLOAT = RADIANS (@lat2 - @lat1)
    DECLARE @dLon FLOAT = RADIANS (@lon2 - @lon1)
    SET @lat1 = RADIANS (@lat1)
    SET @lat2 = RADIANS (@lat2)

    DECLARE @a FLOAT
    SET @a = POWER (SIN (@dLat/2),2) + COS (@lat1)*COS (@lat2)*POWER (SIN (@dLon/2),2)
    DECLARE @c FLOAT = 2*ASIN (SQRT (@a))
    SET @result = @earth_radius * @c;
    RETURN @result
END

DECLARE @point_a geography = geography::Point(47.6062, -122.3321, 4326)
DECLARE @point_b geography = geography::Point(40.7128, -74.0060, 4326)
SELECT dbo.Haversine(@point_a, @point_b);