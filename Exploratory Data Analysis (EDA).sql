------Exploratory Data Analysis (EDA)------

--Generic Questions--
-- 1.How many distinct cities are present in the dataset?
SELECT DISTINCT
               city
FROM store_Sales;


-- 2.How many cities are present in the dataset?
SELECT city,
       COUNT(city)
FROM store_Sales

GROUP BY 
        city;

-- 3.In which city is each branch situated?
SELECT DISTINCT
       branch,
       city
FROM store_Sales;


------Product Analysis------
-- 1.How many distinct product lines are there in the dataset?
SELECT DISTINCT
              product_line
FROM store_Sales;

-- 2.What is the most common payment method?
SELECT payment,
       COUNT(payment) AS common_payment_method
FROM store_Sales
GROUP BY
        payment
ORDER BY
        common_payment_method DESC
LIMIT 1;

-- 3.What is the most selling product line?
SELECT product_line,
       COUNT(product_line) AS common_product_line
FROM store_Sales
GROUP BY
        product_line
ORDER BY
        common_product_line DESC
LIMIT 1;

-- 4.What is the total revenue by month?
WITH month_data AS (
    SELECT
        EXTRACT(MONTH FROM date) AS month,
        total
    FROM 
        store_Sales
)
SELECT 
    month,
    SUM(total) AS total_by_month
FROM month_data
GROUP BY
    month
ORDER BY 
    total_by_month DESC;

-- 5.Which month recorded the highest Cost of Goods Sold (COGS)?
WITH month_cogs AS (
    SELECT
        EXTRACT(MONTH FROM date) AS month,
        SUM(cogs) AS total_cogs
    FROM 
        store_Sales
    GROUP BY
        EXTRACT(MONTH FROM date)
)
SELECT 
    month,
    total_cogs
FROM 
    month_cogs
ORDER BY 
    total_cogs DESC
LIMIT 1;

-- 6.Which product line generated the highest revenue?
SELECT product_line,
       SUM(total) AS highest_revenue
FROM store_Sales
GROUP BY
        product_line
ORDER BY
        highest_revenue DESC
LIMIT 1;

-- 7.Which city has the highest revenue?
SELECT city,
       SUM(total) AS highest_revenue
FROM store_Sales
GROUP BY
        city
ORDER BY
        highest_revenue DESC
LIMIT 1;

-- 8.Which product line incurred the highest VAT?
SELECT product_line,
       SUM(tax_5_percent) AS highest_VAT
FROM store_Sales
GROUP BY
        product_line
ORDER BY
        highest_VAT DESC
LIMIT 1;

-- 9.Retrieve each product line and add a column product_category, indicating 'Good' or 'Bad,'based on whether its sales are above the average.
WITH product_line_sales AS (
    SELECT 
        product_line,
        SUM(total) AS total_sales,
        AVG(SUM(total)) OVER () AS avg_sales
    FROM 
        store_Sales
    GROUP BY 
        product_line
)
SELECT 
    product_line,
    total_sales,
    CASE 
        WHEN total_sales > avg_sales THEN 'Good'
        ELSE 'Bad'
    END AS product_category
FROM 
    product_line_sales
ORDER BY 
    total_sales DESC;

/* if you want to add column to the table you use this query

ALTER TABLE store_Sales ADD COLUMN product_category VARCHAR(20);

UPDATE store_Sales 
SET product_category= 
(CASE 
	WHEN total >= (SELECT AVG(total) FROM sales) THEN "Good"
    ELSE "Bad"
END)FROM store_Sales;
*/

-- 10.Which branch sold the highest total quantity of products?
SELECT branch,
       SUM(quantity) AS total_quantity
FROM store_Sales
GROUP BY
        branch
ORDER BY
        total_quantity DESC
LIMIT 1;

-- 11.What is the most common product line by gender?
SELECT gender,
    product_line,
    COUNT(*) AS count
FROM store_Sales
GROUP BY 
    gender, product_line
ORDER BY 
    gender, count DESC;

-- 12.What is the average rating of each product line?
SELECT product_line,
      ROUND(AVG(rating), 2) AS AVG_rating
FROM store_Sales
GROUP BY 
     product_line
ORDER BY 
        AVG_rating DESC;

------Sales Analysis------
-- 1.Number of sales made in each time of the day per weekday
SELECT 
    TO_CHAR(date, 'Day') AS weekday,
    EXTRACT(DOW FROM date) AS weekday_number,
    CASE 
        WHEN time::time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time::time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN time::time BETWEEN '17:00:00' AND '21:59:59' THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(*) AS number_of_sales,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY TO_CHAR(date, 'Day')), 1) AS percentage_of_weekday_sales
FROM 
    store_Sales
GROUP BY 
    weekday, weekday_number, time_of_day
ORDER BY 
    weekday_number;


-- 2.Identify the customer type that generates the highest revenue?
SELECT customer_type,
       SUM(total) AS the_highest_revenue
FROM store_Sales
GROUP BY
        customer_type
ORDER BY
        the_highest_revenue DESC
LIMIT 1;

-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city,
       SUM(tax_5_percent) AS VAT
FROM store_Sales
GROUP BY
        city
ORDER BY
        VAT DESC
LIMIT 1;

-- 4.Which customer type pays the most in VAT?
SELECT customer_type,
       SUM(tax_5_percent) AS VAT
FROM store_Sales
GROUP BY
        customer_type
ORDER BY
        VAT DESC
LIMIT 1;

------Customer Analysis------
-- 1.How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) AS unique_customer_type
FROM store_Sales;

-- 2.How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment) AS payment_method
FROM store_Sales;

-- 3.Which is the most common customer type?
SELECT customer_type,
       COUNT(customer_type) 
FROM store_Sales
GROUP BY 
        customer_type
ORDER BY
        customer_type 
LIMIT 1;

-- 4.Which customer type buys the most?
SELECT customer_type,
       SUM(quantity) 
FROM store_Sales
GROUP BY 
        customer_type
ORDER BY
        customer_type 
LIMIT 1;

-- 5.What is the gender of most of the customers?
SELECT gender,
       COUNT(gender) 
FROM store_Sales
GROUP BY 
        gender
ORDER BY
        gender 
LIMIT 1;

-- 6.What is the gender distribution per branch?
SELECT branch,
       gender,
       COUNT(gender) AS gender_distribution
FROM store_Sales
GROUP BY 
        branch, 
        gender
ORDER BY
         branch;

-- 7.Which time of the day do customers give most ratings?
SELECT 
    CASE 
        WHEN time::time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time::time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN time::time BETWEEN '17:00:00' AND '21:59:59' THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(rating) AS total_ratings,
    ROUND(AVG(rating), 2) AS average_rating,
    ROUND(COUNT(rating) * 100.0 / (SELECT COUNT(rating) FROM store_Sales WHERE rating IS NOT NULL), 2) AS percentage_of_total
FROM 
    store_Sales
WHERE 
    rating IS NOT NULL
GROUP BY 
    time_of_day
ORDER BY 
    total_ratings DESC;

-- 8.Which time of the day do customers give most ratings per branch?
WITH branch_time_ratings AS (
    SELECT 
        branch,
        CASE 
        WHEN time::time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time::time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN time::time BETWEEN '17:00:00' AND '21:59:59' THEN 'Evening'
        ELSE 'Night'
        END AS time_of_day,
        COUNT(rating) AS total_ratings,
        ROUND(AVG(rating), 2) AS avg_rating
    FROM 
        store_Sales
    WHERE 
        rating IS NOT NULL
    GROUP BY 
        branch, time_of_day
),
ranked_times AS (
    SELECT 
        branch,
        time_of_day,
        total_ratings,
        avg_rating,
        RANK() OVER (PARTITION BY branch ORDER BY total_ratings DESC) AS rating_rank
    FROM 
        branch_time_ratings
)
SELECT 
    branch,
    time_of_day,
    total_ratings,
    avg_rating,
    ROUND(total_ratings * 100.0 / SUM(total_ratings) OVER (PARTITION BY branch), 2) AS branch_percentage
FROM 
    ranked_times
WHERE 
    rating_rank = 1
ORDER BY 
    branch, total_ratings DESC;

-- 9.Which day of the week has the best avg ratings?
SELECT 
    EXTRACT(DOW FROM date) AS day_of_week,
    TO_CHAR(date, 'Day') AS weekday_name,
    ROUND(AVG(rating), 2) AS average_rating,
    COUNT(rating) AS number_of_ratings,
    RANK() OVER (ORDER BY AVG(rating) DESC) AS rating_rank
FROM 
    store_Sales
WHERE 
    rating IS NOT NULL
GROUP BY 
    day_of_week, weekday_name
ORDER BY 
    average_rating DESC;

-- 10.Which day of the week has the best average ratings per branch?
WITH branch_daily_stats AS (
    SELECT
        branch,
        EXTRACT(DOW FROM date) AS day_num,
        TO_CHAR(date, 'Day') AS day_name,
        AVG(rating) AS mean_rating,
        COUNT(rating) AS rating_count,
        MIN(rating) AS min_rating,
        MAX(rating) AS max_rating,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rating) AS median_rating,
        STDDEV(rating) AS rating_stddev
    FROM
        store_Sales
    WHERE
        rating IS NOT NULL
    GROUP BY
        branch, day_num, day_name
    HAVING
        COUNT(rating) >= 5  -- Minimum ratings threshold
),
ranked_days AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY branch ORDER BY mean_rating DESC) AS rank_by_avg,
        RANK() OVER (PARTITION BY branch ORDER BY median_rating DESC) AS rank_by_median
    FROM
        branch_daily_stats
)
SELECT
    branch,
    day_num,
    TRIM(day_name) AS weekday,
    mean_rating AS average_rating,
    median_rating,
    rating_count,
    rating_stddev AS standard_deviation,
    ROUND(rating_count * 100.0 / SUM(rating_count) OVER (PARTITION BY branch), 1) AS percentage_of_ratings,
    CASE
        WHEN rank_by_avg = 1 AND rank_by_median = 1 THEN 'Consistent Best Day'
        WHEN rank_by_avg = 1 THEN 'Best by Average (check median)'
        WHEN rank_by_median = 1 THEN 'Best by Median (check average)'
        ELSE 'Review Needed'
    END AS rating_quality_note
FROM
    ranked_days
WHERE
    rank_by_avg = 1 OR rank_by_median = 1
ORDER BY
    branch, mean_rating DESC;

















