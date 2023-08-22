------- Windows function

---- May 17 
-- ANALYTIC NAVIGATION FUNCTION : FIRST_VALUE, LAST_VALUE, LAG, LEAD



--FIRST_VALUE() - 

--Write a query that returns one of the most stocked product in each store.

SELECT distinct store_id,

	FIRST_VALUE(product_id) OVER(PARTITION BY store_id order by quantity desc) most_stocked_product
FROM product.stock


--Write a query that returns customers and their most valuable order with total amount of it.

WITH T1 AS 
(
SELECT customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) NET_PRICE
FROM sale.order_item A, sale.orders B
WHERE A.order_id = B.order_id
GROUP BY customer_id, B.order_id
)
SELECT distinct customer_id,
		FIRST_VALUE(order_id) OVER(PARTITION BY customer_id order by NET_PRICE desc) mv_order,
		FIRST_VALUE(NET_PRICE) OVER(PARTITION BY customer_id order by NET_PRICE desc) mvorder_net_price
FROM T1 



-------
---Write a query that returns first order date by month, BY YEAR

SELECT distinct YEAR(order_date) [year], MONTH(order_date) [month],
		FIRST_VALUE(order_date) OVER (PARTITION BY MONTH(order_date), YEAR(order_date) order by order_date ASC) first_order_date
FROM sale.orders

-----------

---- LAST VALUE

--Write a query that returns most stocked product in each store. (Use Last_Value)

SELECT DISTINCT store_id,

	LAST_VALUE(product_id) OVER(PARTITION BY store_id order by quantity ASC, product_id DESC range BETWEEN CURRENT ROW 
	AND UNBOUNDED FOLLOWING) MOST_STOCKED_PRODUCT

FROM product.stock




------ LAG Function ---- LEAD Function

--Write a query that returns the order date of the one previous sale of each staff (use the LAG function)

SELECT distinct A.order_id, B.staff_id, B.first_name, B.last_name, order_date,

	LAG(order_date, 1) OVER(PARTITION BY B.staff_id order by order_id) previous_order_date

FROM sale.orders A, sale.staff B
where A.staff_id = B.staff_id


-------
--Write a query that returns the order date of the one next sale of each staff (use the LEAD function)


SELECT distinct A.order_id, B.staff_id, B.first_name, B.last_name, order_date,

	LEAD(order_date, 1) OVER(PARTITION BY B.staff_id order by order_id) next_order_date 

FROM sale.orders A, sale.staff B
where A.staff_id = B.staff_id


---------///////

--Write a query that returns the difference order count between the current month and the next month for eachh year.

WITH T1 AS(
SELECT DISTINCT YEAR(order_date) ORD_YEAR, MONTH(order_date) ORD_MONTH,
	COUNT(order_id) OVER(PARTITION BY YEAR(order_date), MONTH(order_date)) CNT_ORDER
FROM sale.orders
)
SELECT ORD_YEAR, ORD_MONTH, CNT_ORDER,

		LEAD(ORD_MONTH) OVER(PARTITION BY ORD_YEAR ORDER BY ORD_YEAR, ORD_MONTH) NEXT_MONTH,
		LEAD(CNT_ORDER) OVER(PARTITION BY ORD_YEAR ORDER BY ORD_YEAR, ORD_MONTH) NEXT_MONTH_ORDER_CNT,
		CNT_ORDER-LEAD(CNT_ORDER) OVER(PARTITION BY ORD_YEAR ORDER BY ORD_YEAR, ORD_MONTH) DIFFERENCES
FROM T1

 --------- 

 -- 3. ANALYTIC NUMBERING FUNCTIONS --

	
--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()


--Write a query that returns how many days are between the third and fourth order dates of each staff.

WITH T1 AS(
SELECT distinct A.order_id, B.staff_id, B.first_name, B.last_name, order_date,
	LAG(order_date, 1) OVER(PARTITION BY B.staff_id ORDER BY order_date, order_id) previous_order_date,
	ROW_NUMBER() OVER(PARTITION BY B.staff_id ORDER BY order_id) ord_number

FROM sale.orders A, sale.staff B
where A.staff_id = B.staff_id
)
SELECT *, DATEDIFF (DAY, previous_order_date, order_date) DAY_DIFF
FROM T1
WHERE ord_number = 4


-----

--Assign an ordinal number to the product prices for each category in ascending order

SELECT category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id order by list_price) [row_number]
FROM product.product


---/////
-- Lets try previous query again using RANK() function.
SELECT category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id order by list_price) [row_number],
		RANK() OVER(PARTITION BY category_id order by list_price) Rank_number
FROM product.product



----//////
-- Lets try previous query again using DENSE_RANK() function.

SELECT category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id order by list_price) [row_number],
		RANK() OVER(PARTITION BY category_id order by list_price) Rank_number,
		DENSE_RANK() OVER(PARTITION BY category_id order by list_price) DENSE_RANK_NUM
FROM product.product



------
----- -- Write a query that returns the cumulative distribution of the list price in product table by brand.

SELECT brand_id, list_price,

		ROUND(CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) as cum_dist
FROM product.product

