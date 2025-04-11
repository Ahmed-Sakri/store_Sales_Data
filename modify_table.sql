/*
# if you are having a problem with {ERROR: permission denied}
DO THIS STEPS:
1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `your database name` database
3. Right-click `your database namee` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy store_Sales FROM '[Insert File Path]\store_Sales_Data.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/


COPY store_Sales
FROM 'C:\Users\pc\Desktop\store_sales_data\store_Sales_Data.csv'
WITH (FORMAT CSV, HEADER true, DELIMITER ',', ENCODING 'UTF-8');