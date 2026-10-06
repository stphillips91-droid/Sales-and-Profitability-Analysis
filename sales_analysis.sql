-- database creation 
CREATE DATABASE sales_data; 
\c sales_data;

-- create a temporary table as a landing spot for the incoming data 
CREATE TABLE sales_staging( 
    region VARCHAR(35), 
    country VARCHAR(35), 
    item_type VARCHAR(20), 
    sales_channel VARCHAR(7), 
    order_priority CHAR(1), 
    order_date DATE, 
    order_id INTEGER, 
    ship_date DATE, 
    units_sold SMALLINT, 
    unit_price DECIMAL(10,2), 
    unit_cost DECIMAL(10,2), 
    total_revenue DECIMAL(10,2), 
    total_cost DECIMAL(10,2), 
    total_profit DECIMAL(10,2) 
); 

-- load the incoming data to the sales_staging table 
COPY sales_staging(
    region, 
    country, 
    item_type, 
    sales_channel, 
    order_priority, 
    order_date, 
    order_id, 
    ship_date, 
    units_sold, 
    unit_price, 
    unit_cost, 
    total_revenue, 
    total_cost, 
    total_profit) 
FROM 'SalesRecords.csv'  
DELIMITER ',' 
CSV HEADER; 

-- break the data out into the associated tables through SELECT queries 
CREATE TABLE sales AS 
    SELECT  order_id, 
            sales_channel, 
            order_priority, 
            order_date, 
            ship_date, 
            item_type 
    FROM sales_staging
; 

CREATE TABLE locations AS 
    SELECT  order_id, 
            region, 
            country 
    FROM sales_staging
; 

CREATE TABLE order_financials AS 
    SELECT  order_id, 
            units_sold, 
            total_revenue, 
            total_cost, 
            total_profit 
    FROM sales_staging
; 

-- remove transferred data from sales_staging table 
ALTER TABLE sales_staging 
    DROP COLUMN order_id,  
    DROP COLUMN sales_channel,  
    DROP COLUMN order_priority,  
    DROP COLUMN order_date,  
    DROP COLUMN ship_date,  
    DROP COLUMN region,  
    DROP COLUMN country,  
    DROP COLUMN units_sold,  
    DROP COLUMN unit_price, 
    DROP COLUMN unit_cost, 
    DROP COLUMN total_revenue, 
    DROP COLUMN total_cost, 
    DROP COLUMN total_profit; 

-- remove duplicate item data and move to items table 
CREATE TABLE items AS 
    SELECT DISTINCT * 
    FROM sales_staging
; 

-- set up keys for all tables 
ALTER TABLE items 
ADD PRIMARY KEY (item_type); 

ALTER TABLE sales 
ADD PRIMARY KEY (order_id), ADD FOREIGN KEY (item_type) REFERENCES items(item_type); 

ALTER TABLE locations 
ADD PRIMARY KEY (order_id), ADD FOREIGN KEY (order_id) REFERENCES sales(order_id); 

ALTER TABLE order_financials 
ADD PRIMARY KEY (order_id), ADD FOREIGN KEY (order_id) REFERENCES sales(order_id); 

-- remove sales_staging table 
DROP TABLE sales_staging; 

-- count number of individual orders from each sales channel
SELECT sales_channel, COUNT(*) 
FROM sales 
GROUP BY sales_channel; 

-- total profit from offline sales channel
SELECT SUM(total_profit) 
FROM sales 
JOIN order_financials 
ON sales.order_id = order_financials.order_id 
WHERE sales_channel = 'Offline'; 

-- total profit from online sales channel
SELECT SUM (total_profit) 
FROM order_financials 
WHERE order_id IN ( 
SELECT order_id 
FROM sales 
WHERE sales_channel = 'Online' 
); 

-- calculate monthly profit and profit change for each sales channel
WITH monthly_profit AS (
    SELECT
        DATE_TRUNC('month', s.order_date)::date AS month,
        s.sales_channel,
        SUM(sr.total_profit) AS profit
    FROM sales AS s
    JOIN sales_revenue AS sr ON sr.order_id = s.order_id
    GROUP BY 1, 2
)
SELECT
    month,
    sales_channel,
    profit,
    LAG(profit) OVER (
        PARTITION BY sales_channel
        ORDER BY month
    ) AS prior_month_profit,
    profit - LAG(profit) OVER (
        PARTITION BY sales_channel
        ORDER BY month
    ) AS profit_change
FROM monthly_profit
ORDER BY sales_channel, month;

-- calculate profit by item type and rank by region
WITH item_profit AS (
    SELECT
        l.region,
        s.item_type,
        SUM(sr.total_profit) AS profit
    FROM sales AS s
    JOIN locations AS l ON l.order_id = s.order_id
    JOIN sales_revenue AS sr ON sr.order_id = s.order_id
    GROUP BY l.region, s.item_type
)
SELECT
    region,
    item_type,
    profit,
    RANK() OVER (
        PARTITION BY region
        ORDER BY profit DESC
    ) AS profit_rank
FROM item_profit
ORDER BY region, profit_rank, item_type;