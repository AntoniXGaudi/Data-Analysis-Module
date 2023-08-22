---- SESSIONS 4 JOIN

---- INNER JOIN

-- Make a list of products showing the product ID, product name, category ID, and category name.
SELECT A.product_id, A.product_name, A.category_id, B.category_name
FROM product.product A
INNER JOIN product.category B
ON A.category_id = B.category_id

--- OR WHERE CONDITION(SECOND WAY SOLUTION)
SELECT A.product_id, A.product_name, A.category_id, B.category_name
FROM product.product A, product.category B
WHERE A.category_id = B.category_id



-----
--List employees of stores with their store information.

SELECT A.first_name, A.last_name, B.store_name
FROM sale.staff A
INNER JOIN sale.store B
ON A.store_id = B.store_id



----- LEFT JOIN
--Write a query that returns products that have never been ordered

--- PRODUCT AND ORDER_ITEM TABLE BASED ON PRODUCT ID


SELECT A.product_id, A.product_name, B.order_id
FROM product.product A
LEFT JOIN sale.order_item B
ON A.product_id = B.product_id  --- IF YOU WANT TO UNDERSTAND HOW TO WORK LEFT JOIN



SELECT A.product_id, A.product_name, ISNULL(STR(B.product_id), 'No Ordered') AS IsOrdered
FROM product.product A
LEFT JOIN sale.order_item B
ON A.product_id = B.product_id
where B.product_id IS NULL

----
--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: product_id, product_name, store_id, product_id, quantity

---- PRODUCT TABLE AND STOCK TABLE BASED ON PRODUCT_ID COLUMN

SELECT A.product_id, A.product_name, B.*
FROM product.product A
LEFT JOIN product.stock B
ON A.product_id = B.product_id
WHERE A.product_id > 310


---- RIGHT JOIN 

--Report (AGAIN WITH RIGHT JOIN) the stock status of the products that product id greater than 310 in the stores.
--Expected columns: product_id, product_name, store_id, quantity

SELECT B.product_id, B.product_name, A.*
FROM product.stock A
RIGHT JOIN product.product B
ON A.product_id = B.product_id
--WHERE B.product_id > 310



---------Report the order information made by all staffs.

--Expected columns: staff_id, first_name, last_name, all the information about orders

-- HOW MANY DISTINCT STAFF IN THE STAFF TABLE?

SELECT COUNT (distinct staff_id)
FROM sale.staff

--- staff number with inner join

SELECT COUNT (distinct A.staff_id)
FROM sale.staff A
INNER JOIN sale.orders B
ON A.staff_id = B.staff_id


--- SOLUTION

SELECT  A.staff_id, A.first_name, A.last_name, B.*
FROM sale.staff A
LEFT JOIN sale.orders B
ON A.staff_id = B.staff_id
ORDER BY B.order_id




---- FULL OUTER JOIN

--- 
--Write a query that returns stock and order information together for all products . Return only top 100 rows.

--Expected columns: Product_id, store_id, quantity, order_id, list_price

---  USING THAT TABLES: PRODUCT, STOCK, ORDER_ITEM

SELECT TOP 100 A.product_id, B.store_id, B.quantity, C.order_id, C.list_price
FROM product.product A
FULL OUTER JOIN
product.stock B ON A.product_id = B.product_id
FULL OUTER JOIN 
sale.order_item C ON A.product_id = C.product_id
ORDER BY B.store_id



---- cross join

/*
In the stocks table, there are not all products held on the product table and you want to 
insert these products into the stock table.

You have to insert all these products for every three stores with “0 (zero)” quantity.

Write a query to prepare this data.
*/

SELECT B.store_id, A.product_id, 0 quantity
FROM product.product A
CROSS JOIN sale.store B
WHERE A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id


---- self join

--Write a query that returns the staff names with their manager names.
--Expected columns: staff first name, staff last name, manager name


SELECT	first_name, last_name, staff_id, manager_id
FROM	sale.staff


SELECT	A.first_name, A.last_name, B.first_name as manager_name
FROM	sale.staff A
LEFT JOIN sale.staff B
ON A.manager_id = B.staff_id

------

--Write a query that returns both the names of staff and the names of their 1st and 2nd managers


SELECT	A.first_name STAFF_NAME,
		B.first_name MANAGER1_NAME,
		C.first_name MANAGER2_NAME
FROM	sale.staff A
LEFT JOIN sale.staff B
ON A.manager_id = B.staff_id
LEFT JOIN sale.staff C
ON B.manager_id = C.staff_id
ORDER BY C.first_name, B.first_name

SELECT	*
FROM	sale.staff



---- VIEW 

CREATE VIEW v_customers_and_products AS
SELECT	  DISTINCT A.customer_id, A.first_name, A.last_name, B.order_id, C.product_id, D.product_name
FROM	  sale.customer A
LEFT JOIN sale.orders B ON A.customer_id = B.customer_id
LEFT JOIN sale.order_item C ON B.order_id = C.order_id
LEFT JOIN product.product D ON C.product_id = D.product_id


SELECT * 
FROM v_customers_and_products
