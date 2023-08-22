
SELECT * FROM [dbo].[CUSTMOER_PRODUCT]


------ 2 questions solving from previous class

-- 1.Question 
--List the stores whose turnovers are under the average store turnovers in 2018.

SELECT  C.store_name, SUM(list_price*quantity*(1-discount)) STORE_EARN
FROM sale.orders A, sale.order_item B, sale.store C
WHERE A.order_id = B.order_id
AND A.store_id = C.store_id
AND YEAR(A.order_date) = 2018  
GROUP BY C.store_name




WITH T1 AS(
SELECT  C.store_name, SUM(list_price*quantity*(1-discount)) STORE_EARN
FROM sale.orders A, sale.order_item B, sale.store C
WHERE A.order_id = B.order_id
AND A.store_id = C.store_id
AND YEAR(A.order_date) = 2018  
GROUP BY C.store_name
), T2 AS (
SELECT AVG(STORE_EARN) AVG_EARN
FROM T1
)
SELECT *
FROM T1, T2
WHERE T2.AVG_EARN > T1.STORE_EARN


------- 2.QUESTION

---- -- Write a query that returns the net amount of their first order for 
--- customers who placed their first order after 2019-10-01.
--- USING DATE 
--- USING CUSTOMER INFORMATION
--- USING ORDER INFORMATION
--- WHICH TABLE WE ARE GONNA USE: SALE.CUSTOMER ---> CUSTOMER, SALE.ORDERS ---> ORDER_dATE
 ---- ---- SALE.ORDER_ITEM TO REACH PRICE, QUANTITY

WITH T1 AS (
SELECT customer_id, MIN(order_date) first_order_date, MIN(order_id) first_order
FROM sale.orders
GROUP BY customer_id
HAVING MIN(order_date) > '2019-10-01'
)
SELECT T1.customer_id, B.first_name, B.last_name, A.order_id, SUM(quantity*list_price*(1-discount)) net_amount
FROM T1, sale.order_item A, sale.customer B
WHERE T1.first_order = A.order_id
AND T1.customer_id = B.customer_id
GROUP BY T1.customer_id, B.first_name, B.last_name, A.order_id
ORDER BY 1


----- 
-------- WINDOWS FUNCTION ------------------

---- LET'S LOOK AT DIFFERENCES BETWEEN GROUP BY AN WF

--Write a query that returns the total stock amount of each product in the stock table.
--- PRODUCT.STOCK

SELECT * 
FROM [product].[stock]

---- GROUP BY

SELECT product_id, SUM(quantity) TOTAL_STOCK
FROM [product].[stock]
GROUP BY product_id
ORDER BY product_id



---- WF

SELECT *,
	SUM(quantity) OVER(PARTITION BY product_id) total_stock
FROM [product].[stock]
ORDER BY product_id


-- Write a query that returns average product prices of brands. 
--- USING PRODUCT.PRODUCT

---- group by

SELECT brand_id, AVG(list_price) avg_price
FROM product.product
GROUP BY brand_id
order by brand_id



--- wf
SELECT brand_id, product_id, AVG(list_price) over(partition by brand_id) avg_price
FROM product.product
order by brand_id

-----------------------------------------


---------------------------------
---- -- 1. ANALYTIC AGGREGATE FUNCTIONS --
--MIN() - MAX() - AVG() - SUM() - COUNT()

-- -- What is the cheapest product price for each category?

select  distinct category_id,
	MIN(list_price) OVER(PARTITION BY category_id) cheapest_by_category 

from product.product
order by category_id


-- How many different product in the product table? --- 520

select DISTINCT
		COUNT(product_id) OVER() NUM_OF_PRODUCT
from product.product



------ How many different product in the order_item table?
SELECT
		COUNT(DISTINCT product_id) 
FROM sale.order_item



---- -- Write a query that returns how many products are in each order? --- sum quantity by order_id

select distinct order_id,
	SUM(quantity) OVER(PARTITION BY order_id) cnt_product
from sale.order_item

-------- -- How many different product are in each brand in each category?

select distinct category_id, brand_id,
	COUNT(product_id) OVER(PARTITION BY category_id, brand_id) num_of_prod
from product.product
order by category_id, brand_id


-------- 
--Question:

--Can we calculate how many different brands are in each category in this query with WF?

select distinct category_id, brand_id,
	COUNT(product_id) OVER(PARTITION BY category_id, brand_id) num_of_prod
from product.product
order by category_id, brand_id

---- no we couldn't calculate. we can not use distinct in wf
--- we need to use subquery, CTE, ...

SELECT DISTINCT category_id, count (brand_id) over (partition by category_id)
FROM
(
SELECT	DISTINCT category_id, brand_id
FROM	product.product
) A
ORDER BY category_id


--- or

SELECT	category_id, count (DISTINCT brand_id)
FROM	product.product
GROUP BY category_id




-----------
--- WINDOWS FRAME

SELECT	*
FROM	sale.order_item

SELECT	*, 
	SUM(list_price) over(partition by order_id)
FROM	sale.order_item







