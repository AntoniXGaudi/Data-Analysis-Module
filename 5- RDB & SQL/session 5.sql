
select count(*)
from [product].[product]

select  category_id, count(*) 
from [product].[product]
group by category_id

select *
from [product].[category]

select  b.category_name, count(*) as num_products
from [product].[product] a 
left join [product].[category] b on a.category_id = b.category_id
group by b.category_name
having  count(*) > 5
 





select product_id, count(*) as num_product
from [product].[product]
group by product_id
having  count(*) > 1

--Write a query that returns category ids with conditions 
--max list price above 4000 or a min list price below 500.


select category_id
	, max(list_price) as max_price
	, min(list_price) as min_price
from [product].[product]
group by category_id
having max(list_price) > 4000 AND min(list_price) < 500
order by category_id

--Find the average product prices of the brands. 
--Display brand name and average prices in descending order.
select b.brand_name, avg(p.list_price) as avg_list_price
from [product].[product] p 
inner join [product].[brand] b on p.brand_id = b.brand_id
group by b.brand_name
order by avg(p.list_price) desc

--Write a query that returns the list of brands whose average 
--product prices are more than 1000
select b.brand_name, avg(p.list_price) as avg_list_price
from [product].[product] p 
inner join [product].[brand] b on p.brand_id = b.brand_id
group by b.brand_name
having avg(p.list_price) > 1000


--Write a query that returns the list of each order id 
--and that order's total net price 
--(please take into consideration of discounts and quantities)


select order_id, sum(quantity * list_price * (1 - discount))
from [sale].[order_item]
group by order_id

select 2 *	99.99 * (1 - 0.07)



--Write a query that returns monthly order counts of the States.

select c.state
	, year(o.order_date) as order_year
	, month(o.order_date) as order_month
	, count(*) as total
from [sale].[customer] c 
inner join [sale].[orders] o on c.customer_id = o.customer_id
group by c.state, year(o.order_date), month(o.order_date)


select *,  year(order_date), month(order_date)
from [sale].[orders]


select *
into new_table
from source_table



SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year

select * 
from [sale].[sales_summary]

select sum(total_sales_price)
from [sale].[sales_summary]

select brand, sum(total_sales_price)
from [sale].[sales_summary]
group by brand

select brand, category, sum(total_sales_price)
from [sale].[sales_summary]
group by brand, category

select brand, category, sum(total_sales_price)
from [sale].[sales_summary]
group by grouping sets (
						(brand, category) ,
						(brand),
						(category),
						()
						)

select brand, category, sum(total_sales_price)
from [sale].[sales_summary]
group by brand, category

union all 

select  brand, null as category, sum(total_sales_price)
from [sale].[sales_summary]
group by brand 

union all

select  null as brand, category, sum(total_sales_price)
from [sale].[sales_summary]
group by category 

union all 

select  null as brand, null as category, sum(total_sales_price)
from [sale].[sales_summary]





select brand, category, model_year, sum(total_sales_price) 
from [sale].[sales_summary]
group by 
		rollup(brand, category, model_year)
order by brand, category, model_year

select brand, category, model_year, sum(total_sales_price) 
from [sale].[sales_summary]
group by 
		cube(brand, category, model_year)
order by brand, category, model_year




select a.brand, total_count as audio_count
from 
	(select brand
	from [sale].[sales_summary]
	group by brand) a
left join (select brand, category, count(total_sales_price) as total_count
		from [sale].[sales_summary]
		where category = 'Audio & Video Accessories'
		group by brand, category 
		) b on a.brand = b.brand 




select category, model_year, sum(total_sales_price) 
from [sale].[sales_summary]
group by category, model_year



select *
from 
	(select category, model_year, total_sales_price
	from sale.[sales_summary]) as a
pivot
	(
		sum(total_sales_price)
		for model_year
		in ([2018],[2019],[2020],[2021])
	) as pvt

select category, model_year, sum(total_sales_price) 
from [sale].[sales_summary]
group by category, model_year
order by category, model_year


--Write a query that returns count of the orders day by day 
--in a pivot table format that has been shipped two days later.
select *
from 
	(select order_id, datename(DW, order_date) as day_of_week
	from [sale].[orders]
	where datediff(day, order_date, shipped_date) > 2 ) a
pivot (
		count(order_id)
		for day_of_week
		in ([Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday])
		) as pivot_table


select first_name
from 	(--some complicated query
		select *
		from [sale].[customer]) x
inner join (--another complicated query
		select *
		from sale.orders
		) y 
		on x.customer_id = y.customer_id


--for each given state, how many customers?
select state, count(*) 
from [sale].[customer]
group by state
order by count(*) desc 

--for each given state and city, how many customers?
select state, city, count(*) 
from [sale].[customer]
group by state, city
order by count(*) desc

--find me states and cities with more than 20 customers.
select state, city, count(*) 
from [sale].[customer]
group by state, city
having count(*) > 20
order by count(*) desc

select *
from 
	(select state, city, count(*) as total
	from [sale].[customer]
	group by state, city ) x
where total > 20


select state, 
	   case when city is null then 'TOTAL'
			else city end as city,
	   total
	   from 
		(select state, city, count(*) as total
		from [sale].[customer]
		group by rollup (state, city) ) x
