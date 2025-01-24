-- Q.1 Write a SQL query to retrive all columns for sales made on '2022-11-05

select * from Retail_Sales where sale_date ='2022-11-05'

-- Q.2 Write a SQL query to find all transactions, there category is ' Clothing', then quantity sold more then 4 or 10 and sales mon is Nov-2022
select * from Retail_Sales where category ='Clothing' and FORMAT(sale_date, 'yyyy-MM') = '2022-11' and quantiy >='4' 

--Q.3 Write a SQL query to calculate the total sales for each category

select category, SUM(total_sale) as net_sale,
count(*) as total_orders 
from Retail_Sales
group by category


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

select AVG(age) from Retail_Sales where category = 'Beauty'

-- Q.5 Write a SQL query to find all transaction  where the total_sales greater then 1000

select * from Retail_Sales where total_sale > '1000'


-- Q.6 Write a SQL Query to find the total number of transactions (transaction_id made by each gender in each category

select category, gender, count(*) as total_transaction from Retail_Sales 
group by category, gender

-- Q.7 Write a SQL query to calculate the average sale for each month. find out best selling month in each year

select * from(
				select 
				YEAR(sale_date) as year,
				MONTH(sale_date) as month,
				AVG(total_sale) as avg_sale
				from Retail_Sales 
				group by  YEAR(sale_date), MONTH(sale_date)
				
				) as t1 where RANK = 1
				order by year, month 


with bestmonth as (
select 
YEAR(sale_date) as year,
MONTH(sale_date) as month,
AVG(total_sale) as avg_sales,
RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) desc) as rank
from Retail_Sales
group by YEAR(sale_date), MONTH(sale_date)
)
select year, month,
avg_sales
from bestmonth
where rank = 1
order by year, month;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

select top(5)  customer_id, sum(total_sale) as total_sales from Retail_Sales
group by customer_id
order by total_sales desc

select customer_id, SUM(total_sale) as total_sales from Retail_Sales
group by customer_id
order by total_sales desc 
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- Q.10 Write a SQL query to create each shift and number of orders (Example morning <=12, afternoon Between 12 & 17, Evening  > 17)

with hourly_sale
as (
select 
*,
 CASE
		WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Monrning'
		WHEN DATEPART(HOUR, sale_time) between 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shifts
from Retail_Sales
)
SELECT shifts, COUNT(*) as total_orders
from hourly_sale
group by shifts
