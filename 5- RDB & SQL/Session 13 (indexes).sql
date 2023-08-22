--------- 

------------- Indexes


/*

-- There are several different scanning methods, the query planner tries to bring the 
query result using the most appropriate one.

-- The correct scanning method to use is highly dependent on the use case and 
the state of the database at the time of scanning.


A clustered index defines the order in which data is physically stored in a table. 
Table data can be sorted in only way, therefore, there can be only one clustered index per table. 
In SQL Server, the primary key constraint automatically creates a clustered index on that particular column.



A non-clustered index doesn’t sort the physical data inside the table. 
In fact, a non-clustered index is stored at one place and table data is stored in another place. 
This is similar to a textbook where the book content is located in one place and the index is located in another. 
This allows for more than one non-clustered index per table.


*/

-- we create table 

create table website_visitor 
(
visitor_id int,
ad varchar(50),
soyad varchar(50),
phone_number bigint,
city varchar(50)
);


DECLARE @i int = 1
DECLARE @RAND AS INT
WHILE @i<200000
BEGIN
	SET @RAND = RAND()*81
	INSERT website_visitor
		SELECT @i , 'visitor_name' + cast (@i as varchar(20)), 'visitor_surname' + cast (@i as varchar(20)),
		5326559632 + @i, 'city' + cast(@RAND as varchar(2))
	SET @i +=1
END;




---- we check top 10

SELECT top 10*
from website_visitor


SET STATISTICS IO on
SET STATISTICS TIME on



--- Without any index, we condition the visitor_id and call the whole table

SELECT *
FROM
website_visitor
where
visitor_id = 100



----- we create an index based on visitor_id column

CREATE CLUSTERED INDEX CLS_INX_1 ON website_visitor (visitor_id)

SELECT visitor_id
FROM
website_visitor
where
visitor_id = 100


SELECT *
FROM
website_visitor
where
visitor_id = 100

SELECT *
FROM
website_visitor
where
ad = 'visitor_name1'


---- 
---- NON CLUSTERED INDEX 

--- city. 
ALTER INDEX CLS_INX_1 ON website_visitor DISABLE
ALTER INDEX CLS_INX_1 ON website_visitor REBUILD
DROP INDEX CLS_INX_1 ON website_visitor


CREATE NONCLUSTERED INDEX NONCLS_INX_3 ON website_visitor (city)

SELECT *
FROM
website_visitor
where
city = 'city4'


SELECT city
FROM
website_visitor
where
city = 'city4'

-----

