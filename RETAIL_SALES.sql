/*creating database*/
create database sql_project_1;
/* initialising column*/
create table retail_sales(
   transactions_id	int primary key,
   sale_date date,	
   sale_time time,
   customer_id	int,
   gender	varchar(10),
   age	int,
   category	varchar(15),
   quantiy	int,
   price_per_unit float,	
   cogs float,
   total_sale float
   ); 
select count(*) from retail_sales;
/* data cleaning*/
select * from retail_sales 
where  
 transactions_id is null
    or
    sale_date is null
	or
    sale_time is null
    or
   customer_id	is null
   or
   gender is null
   or
   age	is null
   or
   category	is null
   or
   quantiy is null
   or
   price_per_unit is null
   or
   cogs is null
   or
   total_sale is null ;
   
/* data exploration*/
   
-- How many sales we have?--

select count(total_sale) from retail_sales;

-- Data analysis and Buisness question

-- Q1 write query to retrieve sale made on "2022-11-05"--

select * from retail_sales
where sale_date="2022-11-05";

-- Q2 write query to retrieve transaction where "clothing" and quantity sale is more than 4 in november month of 2022 --

select * from retail_sales
where category="clothing"
  and quantiy >=4 
  and DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
  
-- Q3 write query for total sale or each category --

select category,
 sum(total_sale) as net_sale
from retail_sales
group by category; 

-- Q4 query for finding average age of customer who buys beauty product--

SELECT AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'beauty';


-- Q5 write query where total_sale is greater than 1000--

select * from retail_sales
where total_sale > 1000;

-- Q6 find total number of transaction made by each gender in each category --

SELECT category,
       gender,
       count(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
order by category, gender;

-- Q7 write query for average sale of each month .also find best selling month of each year--
   
    SELECT *
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS sale_rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS ranked_sales
WHERE sale_rank = 1
ORDER BY year;

-- Q8 select top 5 customer based on total_sale --


SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- Q9 find number of customers who purchased item from each category --

SELECT customer_id
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(DISTINCT category) = (
    SELECT COUNT(DISTINCT category)
    FROM  retail_sales
);

-- Q10 write query to create each shift and number of orders( example morning<12,afternoon between 12 and 17 , evening > 17) --

SELECT
  CASE
    WHEN HOUR(sale_time) < 12 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS shift,
  COUNT(*) AS order_count
FROM retail_sales
GROUP BY shift
ORDER BY shift;

