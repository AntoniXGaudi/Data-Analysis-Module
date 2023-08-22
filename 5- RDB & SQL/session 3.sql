CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

select * from dbo.t_date_time

INSERT t_date_time 
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())

select * from dbo.t_date_time

SELECT	A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date),
		YEAR (A_date),
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROM	t_date_time

select DATEPART (NANOSECOND, A_time)
	   --,DATEPART (NANOSECOND, A_date)
from t_date_time

Msg 9810, Level 16, State 2, Line 27
The datepart nanosecond is not supported by date function datepart for data type date.

select	A_time
		,A_date
		,day(a_date) as a_date_day
		,month(a_date) as a_date_month
		,year(a_date) as a_date_year
from t_date_time

select A_datetime
		,getdate()
		,datediff(minute, A_datetime, getdate())
		,DATEDIFF (MINUTE, getdate(), A_datetime) Diff_minute,
		DATEDIFF (HOUR, getdate(), A_datetime) Diff_Hour,
		DATEDIFF (DAY, getdate(), A_datetime) Diff_day,
		DATEDIFF (MONTH, getdate(), A_datetime) Diff_month,
		DATEDIFF (YEAR, getdate(), A_datetime) Diff_year
from t_date_time

select * 
from t_date_time


select	order_date 
		,dateadd(day, 5, order_date)
		,dateadd(day, -5, order_date)
		,dateadd(year, 5, order_date)
		,dateadd(year, -5, order_date)
from [sale].[orders]

select order_date 
       ,eomonth(order_date)
	   ,eomonth(order_date,2)
from [sale].[orders]

select isdate('string')
select isdate('2021-01-01')
select isdate('2021/01/01')

select isdate(cast(order_date as varchar)), order_date
from [sale].[orders]

select isdate('01-01-2020')

select cast('01-01-2020' as date)

select case when isdate('01-01-2020') = 1 then cast('01-01-2020' as date)
		else null end


select	  *
		, datediff(day, order_date, shipped_date) as date_diff
from [sale].[orders]
where datediff(day, order_date, shipped_date) > 2

select datediff(day,'2018-02-11', null)

select len(1234567)

select len(welcome)

select len('Jack''s phone number')

select charindex('s','string')
select charindex('s','string',2)
select charindex('s', 'strings')
select charindex('gt', 'string')

SELECT PATINDEX('%R', 'CHARACTER')
SELECT PATINDEX('R%', 'CHARACTER')
SELECT PATINDEX('R%', 'ROCKET')
SELECT PATINDEX('%ER', 'PAPER')
SELECT PATINDEX('%ER', 'LEVER')

SELECT LEFT('CHARACTER', 3)
SELECT LEFT(' CHARACTER', 3)

SELECT RIGHT('CHARACTER', 3)
SELECT RIGHT('CHARACTER ', 3)

SELECT SUBSTRING('CHARACTER', 3, 5)
SELECT SUBSTRING(123456789, 3, 5)
SELECT SUBSTRING('CHARACTER', 0, 5)
SELECT SUBSTRING('CHARACTER', -1, 5)

SELECT LOWER ('CHARACTER')
SELECT UPPER ('character')


SELECT UPPER(LEFT('character', 1)) + LOWER(RIGHT('character', 8))



SELECT * 
FROM STRING_SPLIT ('John,Jeremy,Jack',',')



SELECT TRIM(' CHARACTER')
SELECT TRIM(' CHARACTER ')
SELECT TRIM( ' CHAR ACTER ')

SELECT TRIM('?, ' FROM '    ?SQL Server,    ') AS TrimmedString;


SELECT LTRIM ('     CHARACTER ')
SELECT RTRIM ('     CHARACTER ')

SELECT STR (5454)
SELECT STR (2135454654)
SELECT STR (5454, 10)
SELECT STR (5454, 10, 5)
SELECT STR (133215.654645,7)
SELECT STR (133215.654645, 11, 3)

sql ISNUMERIC

select * 
from information_schema.columns
where table_schema = 'sale' and table_name = 'customer'

SELECT REPLACE('CHARACTER STRING', ' ', '/')
SELECT REPLACE('CHARACTER STRING', 'CHARACTER STRING', 'CHARACTER')

SELECT CAST (12345 AS CHAR)
SELECT CAST (123.65 AS INT)
SELECT CAST ('10102020' AS DATE)


SELECT CONVERT(int, 30.60)
SELECT CONVERT (VARCHAR(10), '2020-10-10')

SELECT CONVERT (DATETIME, '2020-10-10' )

SELECT CONVERT (NVARCHAR, GETDATE(),112 )

SELECT CAST ('20201010' AS DATE)
SELECT CONVERT (NVARCHAR, CAST ('20201010' AS DATE),103 )

SELECT COALESCE(NULL, 'Hi', 'Hello', NULL) result;
SELECT COALESCE(NULL, NULL ,'Hi', 'Hello', NULL) result;
SELECT COALESCE(NULL, NULL) result;


select


SELECT NULLIF (10,10)
SELECT NULLIF('Hello', 'Hi') result;
SELECT NULLIF(2,'2')




select email, patindex('%yahoo%', email)
from [sale].[customer]
where patindex('%yahoo%', email) > 0
 

select email
from [sale].[customer]
where email like '%@yahoo.com%'

select count(*)
from [sale].[customer]
where email like '@yahoo.com%'

select email, left(email, CHARINDEX('@', email) -1 )
from [sale].[customer]

select email, CHARINDEX('@', email)
from [sale].[customer]


select email
	, phone
	, case when phone is null then email 
		else phone end 
from [sale].[customer]

select email
	, phone
	, coalesce(phone, email)
from [sale].[customer]


select	street, 
		substring(street, 3,1) as third_char
from [sale].[customer]
where isnumeric(substring(street, 3,1)) = 1

--Split the mail addresses into two parts from ‘@’, 
--and place them in separate columns.

select email, 
		CHARINDEX('@', email),
		left(email, CHARINDEX('@', email) -1),
		len(email),
		len(email) - CHARINDEX('@', email),
		right(email, len(email) - CHARINDEX('@', email))
from [sale].[customer]


select	street, 
		left(street, charindex(' ', street) -2),
		right(street, len(street) - CHARINDEX(' ', street))
from sale.customer
where isnumeric(left(street, charindex(' ', street) -1)) = 1

select	street, 
		left(street, charindex(' ', street) -2)
from  sale.customer
where street like '[0-9]'

select isnumeric(4) = 1
select isnumeric('4') = 1

select isnumeric('four') = 0



int('7') = 7
int('seven') #error



