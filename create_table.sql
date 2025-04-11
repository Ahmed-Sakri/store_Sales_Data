CREATE TABLE store_Sales (
    Invoice_ID VARCHAR(30) PRIMARY KEY,
    Branch VARCHAR(10),
    City VARCHAR(50),
    Customer_type VARCHAR(15),
    Gender VARCHAR(15),
    Product_line VARCHAR(255),
    Unit_price DECIMAL(10,2),
    Quantity INT,
    Tax_5_percent DECIMAL(10,2),
    Total DECIMAL(10,2),
    Date DATE,
    Time TIME,
    Payment VARCHAR(50),
    cogs DECIMAL(10,2),
    gross_margin_percentage DECIMAL(5,2),
    gross_income DECIMAL(10,2),
    Rating DECIMAL(3,1)
);


-- Set ownership of the tables to the postgres user
ALTER TABLE public.store_Sales OWNER to postgres;

-- Create indexes on foreign key columns for better performance
CREATE INDEX idx_store_Sales ON public.store_Sales (Invoice_ID);
