

--Question: Write a query that returns the list of product names that were made in 2020 
--and whose prices are higher than maximum product list price of Receivers Amplifiers category.



select product_name,model_year,list_price
from product.product
where model_year='2020'
and list_price > all(
					select A.list_price
					from product.product A,product.category B
					where A.category_id=B.category_id
					and category_name='Receivers Amplifiers'
					)


--Question: Write a query that returns the list of product names that were made in 2020 and 
--whose prices are higher than minimum product list price of Receivers Amplifiers category.

select product_name,model_year,list_price
from product.product
where model_year='2020'
and list_price > any(
					select A.list_price
					from product.product A,product.category B
					where A.category_id=B.category_id
					and category_name='Receivers Amplifiers'
					)


--Question: Write a query that returns the product_names that were made in 2021. 
--(Exclude the categories that match Game, gps, or Home Theater )


select product_name,list_price
from product.product
where category_id not in (select category_id
						  from product.category
						  where category_name in ('Game', 'gps', 'Home Theater'))
						  and model_year='2021'

--solution with join
select product_name,list_price
from product.product A, product.category B
where A.category_id=B.category_id
and model_year='2021'
and B.category_name not in ('Game', 'gps', 'Home Theater')



--Correlated (Sychronized) Queries
 ---with exists

select *
from sale.customer
where exists(select 1)


select *
from sale.customer A
where exists(select 'michael'
			 from sale.orders B
			 where B.order_date > '20200101')


select *
from sale.customer A
where exists(select 1
			 from sale.orders B
			 where B.order_date > '20200101'
			 and A.customer_id=B.customer_id)


select *
from sale.customer 
where customer_id in (select customer_id
						from sale.orders 
						where order_date > '20200101'
		)

---with not exists

select *
from sale.customer
where not exists(select 1)


select *
from sale.customer A
where not exists(select 1
			 from sale.orders B
			 where B.order_date > '20200101'
			 and A.customer_id=B.customer_id)


select *
from sale.customer A
where customer_id not in (select customer_id
						from sale.orders B
						where B.order_date > '20200101'
						and A.customer_id=B.customer_id)


---Question: Write a query that returns a list of States where 
--'Apple - Pre-Owned iPad 3 - 32GB - White' product is not ordered


select distinct E.state
from sale.customer E
where not exists(
					select *
					from product.product A, sale.order_item B, sale.orders C, sale.customer D
					where A.product_id=B.product_id
					and B.order_id=C.order_id
					and C.customer_id=D.customer_id
					and A.product_name='Apple - Pre-Owned iPad 3 - 32GB - White'
					and E.state=D.state
					)


---CTE
--Ordinary CTE

--Question: List customers who have an ordered 
--prior to the last order of a customer named Jerald Berray
--and are residents of the city of Austin.

with tt as
(select MAX(A.order_date) as last_order_date
from sale.orders A,sale.customer B
where A.customer_id=B.customer_id
and B.first_name='Jerald'
and B.last_name='Berray'
)
select A.customer_id,A.first_name, A.last_name,A.city, B.order_date
from sale.customer A,sale.orders B,tt C
where A.customer_id=B.customer_id
and A.city='Austin'
and B.order_date < C.last_order_date


--Question: List all customers whose orders are on the same dates with Laurel Goldammer.

with t1 as
(select B.order_date
from sale.customer A,sale.orders B
where A.customer_id=B.customer_id
and A.first_name='Laurel'
and A.last_name='Goldammer'
)
select A.first_name,A.last_name, B.order_date
from sale.customer A, sale.orders B, t1 C
where A.customer_id=B.customer_id
and B.order_date=C.order_date

--Recursive CTE

--Question: Create a table with a number in each row in ascending order from 0 to 9.

with rtt as
		(select 0 as number
			union all
		select number+1
		from rtt
		where number< 9)
select *
from rtt


--Question: Write a query that returns all staff with their manager_ids. (Use Recursive CTE)


with t1 as 
(select staff_id,first_name,manager_id
from sale.staff
where staff_id=1
union all
select A.staff_id, A.first_name , A.manager_id
from sale.staff A, t1 B
where A.manager_id=B.staff_id
)
select *
from t1


select *
from sale.staff

CTE
1	James	NULL
2	Charles	Cussona
3	Jhon	Setamento
4	Davis	Thomas