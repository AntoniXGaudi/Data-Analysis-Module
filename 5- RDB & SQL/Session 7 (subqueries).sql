
--Question: Write a query that shows all employees in the store where Davis Thomas works.

select *
from sale.staff 
where store_id =
	(	select store_id
		from sale.staff
		where first_name='Davis'
		and last_name='Thomas')


--Question: Write a query that shows the employees for whom Charles Cussona is a first-degree manager. (To which employees are Charles Cussona a first-degree manager?)



select *
from sale.staff
where manager_id=(
					select staff_id
					from sale.staff
					where first_name='Charles' and last_name='Cussona'
				  )



--Question: Write a query that returns the customers located where ‘The BFLO Store' is located.

select first_name,last_name,city
from sale.customer
where city = (
				select city
				from sale.store
				where store_name like '%BFLO%'
			   )


--Question: Write a query that returns the list of products that are more expensive than the product named 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'

select *
from product.product
where list_price > (

					select list_price
					from product.product
					where product_name='Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
					)
order by list_price asc


--Question: Write a query that returns the customer names, last names, and order dates. The customers whose order are before the order date of Hassan Pope.

select A.first_name,A.last_name, B.order_date
from sale.customer A, sale.orders B
where A.customer_id=B.customer_id
and B.order_date < (

					select B.order_date
					from sale.customer A, sale.orders B
					where A.customer_id=B.customer_id
					and A.first_name='Hassan' 
					and A.last_name='Pope'
					)

--Question: Write a query that returns customer first names, last names and order dates. The customers who are order on the same dates as Laurel Goldammer.


select A.first_name, A.last_name, B.order_date
from sale.customer A,sale.orders B
where A.customer_id=B.customer_id
and B.order_date IN (

				select B.order_date
				from sale.customer A,sale.orders B
				where A.customer_id=B.customer_id
				and A.first_name='Laurel' and A.last_name='Goldammer'
				)


--Question: List the products that ordered in the last 10 orders in Buffalo city.

select distinct B.product_name
from sale.order_item A,product.product B
where A.product_id=B.product_id
and A.order_id in (
					select top 10 B.order_id
					from sale.customer A,sale.orders B
					where A.customer_id=B.customer_id
					and A.city ='Buffalo'
					order by order_id desc
					)




--Question: Write a query that returns the product_names that were made in 2021. (Exclude the categories that match Game, gps, or Home Theater )

select product_name,list_price
from product.product
where category_id not in(

						select category_id
						from product.category
						where category_name in ('Game', 'gps', 'Home Theater')
						) and model_year=2021