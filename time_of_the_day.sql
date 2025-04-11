-- loking for the time of the day if it's "AFTERNOON" or "MORNIG"

SELECT *,
       CASE
        WHEN time::time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time::time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN time::time BETWEEN '17:00:00' AND '21:59:59' THEN 'Evening'
        ELSE 'Night (10PM-6AM)'
       END AS time_of_day
FROM store_Sales