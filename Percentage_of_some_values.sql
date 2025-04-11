-- finding the percentage of the Branch, customer_type, gender, product_line

--finding the percentage of the Branch

SELECT branch,
       COUNT(branch),
       ROUND(COUNT(branch) * 100.0 / SUM(COUNT(branch)) OVER(), 2) AS percentage_of_the_Branch
FROM store_Sales

GROUP BY 
         branch
ORDER BY
        percentage_of_the_Branch DESC;

-- finding the percentage of the customer_type

SELECT customer_type,
       COUNT(customer_type),
       ROUND(COUNT(customer_type) * 100.0 / SUM(COUNT(customer_type)) OVER(), 2) AS percentage_of_customer_type
FROM store_Sales

GROUP BY 
         customer_type
ORDER BY
        percentage_of_customer_type  DESC;

-- finding the percentage of the gender

SELECT gender,
       COUNT(gender),
       ROUND(COUNT(gender) * 100.0 / SUM(COUNT(gender)) OVER(), 2) AS percentage_of_gender
FROM store_Sales

GROUP BY 
         gender
ORDER BY
        percentage_of_gender  DESC;

-- finding the percentage of product_line


SELECT product_line,
       COUNT(product_line),
       ROUND(COUNT(product_line) * 100.0 / SUM(COUNT(product_line)) OVER(), 2) AS percentage_of_product_line
FROM store_Sales

GROUP BY 
         product_line
ORDER BY
        percentage_of_product_line  DESC;
