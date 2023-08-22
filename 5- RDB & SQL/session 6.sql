--List the products sold in the cities of Charlotte and Aurora
select distinct p.product_name
from [sale].[customer] c
inner join [sale].[orders] o on c.customer_id = o.customer_id
inner join [sale].[order_item] oi on oi.order_id = o.order_id
inner join [product].[product] p on p.product_id = oi.product_id
where c.city IN ('Charlotte', 'Aurora' )


SELECT	*
FROM	product.brand
UNION
SELECT	*
FROM	product.category


SELECT	city, 'STATE' AS STATE
FROM	sale.store

UNION ALL

SELECT	state, 1 as city
FROM	sale.store


SELECT	city, 'Clean' AS street
FROM	sale.store

UNION ALL

SELECT	city
FROM	sale.store;


select c.first_name, c.last_name
from sale.customer c
where c.first_name = 'Thomas'

union

select c.first_name, c.last_name
from sale.customer c
where c.last_name = 'Thomas'



--Write a query that returns all brands with products 
--for both 2018 and 2020 model year.

select *
from [product].[product] p
where p.product_name in
	(select p.product_name  
	from [product].[brand] b 
	inner join [product].[product] p on b.brand_id = p.brand_id
	where p.model_year = 2018

	intersect

	select p.product_name 
	from [product].[brand] b 
	inner join [product].[product] p on b.brand_id = p.brand_id
	where p.model_year = 2020)

--Write a query that returns the first and the last names of the customers 
--who placed orders in all of 2018, 2019, and 2020.

select c.first_name, c.last_name
from [sale].[customer] c
inner join [sale].[orders] o on c.customer_id = o.customer_id
where year(order_date) = 2018

intersect

select c.first_name, c.last_name
from [sale].[customer] c
inner join [sale].[orders] o on c.customer_id = o.customer_id
where year(order_date) = 2019

intersect

select c.first_name, c.last_name
from [sale].[customer] c
inner join [sale].[orders] o on c.customer_id = o.customer_id
where year(order_date) = 2020

--alternative
select first_name, last_name
from
	(select distinct c.first_name, c.last_name, year(order_date) as order_year
	from [sale].[customer] c
	inner join [sale].[orders] o on c.customer_id = o.customer_id
	where year(order_date) in (2018, 2019, 2020)) x
group by first_name, last_name
having count(*) > 2

--Write a query that returns the brands have  
--2018 model products but not 2019 model products.
select b.brand_id, b.brand_name 
from [product].[product] p
inner join [product].[brand] b on p.brand_id = b.brand_id
where p.model_year = 2018

except 

select b.brand_id, b.brand_name 
from [product].[product] p
inner join [product].[brand] b on p.brand_id = b.brand_id
where p.model_year = 2019

--alternative
select distinct b.brand_id, b.brand_name 
from [product].[product] p
inner join [product].[brand] b on p.brand_id = b.brand_id
where p.model_year = 2018 
	  and b.brand_id not in 
		(select b.brand_id
		from [product].[product] p
		inner join [product].[brand] b on p.brand_id = b.brand_id
		where p.model_year = 2019)

--Write a query that contains only products ordered in 2019 
--(Result not include products ordered in other years)

select p.product_name
from [product].[product] p 
inner join  [sale].[order_item] oi on p.product_id = oi.product_id
inner join  [sale].[orders] o on o.order_id = oi.order_id
where year(order_date) = 2019

except

select p.product_name
from [product].[product] p 
inner join  [sale].[order_item] oi on p.product_id = oi.product_id
inner join  [sale].[orders] o on o.order_id = oi.order_id
where year(order_date) != 2019


--Create  a new column with the meaning of the  values in the 
--Order_Status column. 
--1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

select	  order_id
		, order_status 
		, case order_status 
			when 1 then 'Pending'
			when 2 then 'Processing'
			when 3 then 'Rejected'
			when 4 then 'Completed'
		  end as order_status_desc
from [sale].[orders]

select	  order_id
		, order_status 
		, case  
			when order_status = 1 and year(order_date) = 2018 then 'Pending-2018'
			when order_status = 2 and year(order_date) = 2018 then 'Processing-2018'
			when order_status = 3 and year(order_date) = 2018 then 'Rejected-2018'
			when order_status = 4 and year(order_date) = 2018 then 'Completed-2018'
		    else 'Not a 2018 order'
		  end as order_status_desc
from [sale].[orders]


--Create a new column with the names of the stores to be 
--consistent with the values in the store_ids column
--1 = Davi techno Retail; 2 = The BFLO Store; 3 = Burkes Outlet
select    first_name
		, last_name
		, store_id 
		, case store_id 
			when 1 then 'Davi techno Retail'
			when 2 then 'The BFLO Store'
			when 3 then 'Burkes Outlet'
		  end as store_name
from [sale].[staff]

select	  order_id
		, order_status 
		, case order_status 
			when 1 then 'Pending'
			when 2 then 'Processing'
			when 3 then 'Rejected'
			when 4 then 'Completed'
		  else 'missing'
		  end as order_status_desc
from [sale].[orders]

select	  order_id
		, order_status 
		, case  
			when order_status = 1 then 'Pending'
			when order_status = 2 then 'Processing'
			when order_status = 3 then 'Rejected'
			when order_status = 4 then 'Completed'
		  else 'missing'
		  end as order_status_desc
from [sale].[orders]


select list_price, case 
		when list_price < 100 then 'low'
		when list_price < 500 then 'middle'
		when list_price >= 500 then 'high'
	   end 
from [product].[product]


--Create a new column that shows which email service provider 
--("Gmail", "Hotmail", "Yahoo" or "Other" ).
select  first_name, 
		last_name, 
		email,
		case 
			when email like '%gmail.com' then 'gmail'
			when email like '%hotmail.com' then 'hotmail'
			when email like '%yahoo.com' then 'yahoo'
			else 'other'
		end as email_service_provider
from [sale].[customer]

--Write a query that gives the first and last names of customers 
--who have ordered products from the 
--computer accessories, speakers, and mp4 player categories 
--in the same order.

select c.customer_id, c.first_name, c.last_name, o.order_id
from [sale].[customer] c
inner join [sale].[orders] o on c.customer_id = o.customer_id
inner join [sale].[order_item] oi on o.order_id = oi.order_id
inner join [product].[product] p on p.product_id = oi.product_id
inner join [product].[category] ca on ca.category_id = p.category_id
where ca.category_name = 'Computer Accessories'

intersect

select c.customer_id, c.first_name, c.last_name, o.order_id
from [sale].[customer] c
inner join [sale].[orders] o on c.customer_id = o.customer_id
inner join [sale].[order_item] oi on o.order_id = oi.order_id
inner join [product].[product] p on p.product_id = oi.product_id
inner join [product].[category] ca on ca.category_id = p.category_id
where ca.category_name = 'Speakers'

intersect

select c.customer_id, c.first_name, c.last_name, o.order_id
from [sale].[customer] c
inner join [sale].[orders] o on c.customer_id = o.customer_id
inner join [sale].[order_item] oi on o.order_id = oi.order_id
inner join [product].[product] p on p.product_id = oi.product_id
inner join [product].[category] ca on ca.category_id = p.category_id
where ca.category_name = 'mp4 player'


--Question: By creating a new column, label the orders according to the instructions below:

--Label the products as 'Not Shipped' if they were NOT shipped.
--Label the products as 'Fast' if they were shipped on the day of order.
--Label the products as 'Normal' if they were shipped within two days of the order date.
--Label the products as 'Slow' if they were shipped later than two days after the order date.

select *, case
			when shipped_date is null then 'not shipped'
			when shipped_date = order_date then 'fast'
			when datediff(day, order_date, shipped_date) <= 2 then 'normal'
			else 'slow'
		end as order_label
from [sale].[orders]

--Write a query that returns the count of the orders 
--day by day in a pivot table format that has been shipped two days later.

select 
	sum(case when datename(dw, order_date) = 'Monday' then 1 else 0 end) Monday,
	sum(case when datename(dw, order_date) = 'Tuesday' then 1 else 0 end) Tuesday,
	sum(case when datename(dw, order_date) = 'Wednesday' then 1 else 0 end) Wednesday,
	sum(case when datename(dw, order_date) = 'Thursday' then 1 else 0 end) Thursday,
	sum(case when datename(dw, order_date) = 'Friday' then 1 else 0 end) Friday,
	sum(case when datename(dw, order_date) = 'Saturday' then 1 else 0 end) Saturday,
	sum(case when datename(dw, order_date) = 'Sunday' then 1 else 0 end) Sunday
from [sale].[orders]
where datediff(day, order_date, shipped_date) > 2

