----  SQL Retails Sales Analysis - P1 --
-- creating table --

create table retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales;

SELECT COUNT(*) FROM retail_sales;


-- data cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL OR
	sale_date IS NULL OR
	sale_time IS NULL OR
	customer_id IS NULL OR
	gender IS NULL OR
	age IS NULL OR
	category IS NULL OR
	quantiy IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL;

-- deleting all records which are having null values

DELETE FROM retail_sales
WHERE transactions_id IS NULL OR
	sale_date IS NULL OR
	sale_time IS NULL OR
	customer_id IS NULL OR
	gender IS NULL OR
	age IS NULL OR
	category IS NULL OR
	quantiy IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL;
	
-- data exploration

-- how many transactions we have ?
select count(*) from retail_sales;

-- how many customers we have ?
select count(distinct customer_id) from retail_sales;

-- how many category we have ?
select count(distinct category) from retail_sales;
select distinct category from retail_sales;


-- Business Problems and answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
--the quantity sold is more than 10 in the month of Nov-2022?
select * from retail_sales
where category ='Clothing' and quantiy >2 and
TO_CHAR(sale_date,'YYYY-MM')='2022-11';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select
category,
sum(total_sale) as total_sales
from retail_sales
group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select
avg(age) from retail_sales
where category ='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select
gender,
category,
count(transactions_id) as total_transaction_by_each_gend
from retail_sales
group by 1,2

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?
select month,year,avg_sale from (
select 
 extract(year from sale_date) as year,
 extract(month from sale_date) as month,
 avg(total_sale) as avg_sale,
 Rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rnk
 from retail_sales
 group by 1,2
)
 where rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select
customer_id,
sum(total_sale) as highest_sales
from retail_sales
group by 1
order by 2 desc limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select
category,
count(distinct customer_id) as unique_customer
from retail_sales
group by 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale as (
select 
*,
case when extract(hour from sale_time) <=12 then 'Morning'
	when extract(hour from sale_time) between 12 and 17 then 'AfterNoon'
	else 'evening'  end as shift
from retail_sales
)
select 
shift,
count(transactions_id) as total_hourly_sales
from hourly_sale
group by 1;


select extract(hour from current_time)
				 


