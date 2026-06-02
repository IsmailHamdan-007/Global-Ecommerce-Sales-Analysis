USE GlobalEcommerceDB;

-- 1. Customer Revenue View.
CREATE VIEW vw_top_customers AS
SELECT
    C.Customer_Name,
    SUM(S.Total_Sales) AS Revenue
FROM Customers C
INNER JOIN Orders O
    ON C.Customer_ID = O.Customer_ID
INNER JOIN Sales S
    ON O.Order_ID = S.Order_ID
GROUP BY C.Customer_Name;

SELECT * FROM vw_top_customers;

-- 2. Regional Revenue View.
CREATE VIEW regional_revenue_views AS 
SELECT 
	C.Region,
	SUM(S.Total_Sales) AS total_sales,
	SUM(S.Profit) AS total_profits,
	COUNT(DISTINCT O.Order_ID) AS total_orders
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID = O.Customer_ID
INNER JOIN Sales S
ON O.Order_ID = S.Order_ID
GROUP BY C.Region;

SELECT * FROM regional_revenue_views;

-- 3. Product Performance View
CREATE VIEW product_performance_view AS
SELECT 
	P.Product_ID,
	P.Product_Name,
	P.Product_Category,
	SUM(S.Quantity) AS total_qty,
	SUM(S.Total_Sales) AS total_revenue,
	SUM(S.Profit) AS total_profit
FROM Products P
INNER JOIN Sales S
ON P.Product_ID = S.Product_ID
GROUP BY P.Product_ID,P.Product_Name,P.Product_Category;

SELECT * FROM product_performance_view
ORDER BY Product_ID ASC;

-- 4. Customer Lifetime Value View.
CREATE VIEW cust_lifetime_value AS
SELECT
	C.Customer_ID,
	C.Customer_Name,
	COUNT(DISTINCT O.Order_ID) AS total_orders,
	SUM(S.Total_Sales) AS Customer_Lifetime_Value
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID = O.Customer_ID
INNER JOIN Sales S
ON O.Order_ID = S.Order_ID
GROUP BY C.Customer_ID,C.Customer_Name;

SELECT * FROM cust_lifetime_value;

-- 5. Monthly Revenue View.
CREATE VIEW monthly_revenue_view AS 
SELECT 
	MONTH(O.Order_Date) AS months,
	YEAR(O.Order_Date) AS years,
	SUM(S.Total_Sales) AS revenue,
	SUM(S.Profit) AS profit
FROM Orders O
INNER JOIN Sales S
ON O.Order_ID = S.Order_ID
GROUP BY MONTH(O.Order_Date), YEAR(O.Order_Date);

SELECT * FROM monthly_revenue_view
ORDER BY months, years ASC;

-- 6.Top Product Category View.
CREATE VIEW top_product_view AS 
SELECT
	P.Product_Category,
	SUM(S.Total_Sales) AS revenue,
	SUM(S.Profit) AS profit,
	ROUND(SUM(S.Profit) * 100.00/ SUM(S.Total_Sales), 2) 
	AS profit_margin
FROM Products P
INNER JOIN Sales S
ON P.Product_ID = S.Product_ID
GROUP BY P.Product_Category;

SELECT * FROM top_product_view;

-- 7. Repeat Customer View.
CREATE VIEW repeated_cust AS
SELECT
	C.Customer_ID,
	C.Customer_Name,
	COUNT(DISTINCT O.Order_ID) AS total_orders
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID = O.Customer_ID
INNER JOIN Sales S
ON O.Order_ID = S.Order_ID
GROUP BY C.Customer_ID,C.Customer_Name
HAVING COUNT(DISTINCT O.Order_ID) > 1;

SELECT * FROM repeated_cust;

-- 8.Product Profitability View.
CREATE VIEW prod_profits AS 
SELECT
	P.Product_Name,
	SUM(S.Total_Sales) AS revenue,
	SUM(S.Profit) AS profit,
	ROUND(SUM(S.Profit) * 100.00/ SUM(S.Total_Sales), 2) 
	AS profit_margin
FROM Products P
INNER JOIN Sales S
ON P.Product_ID = S.Product_ID
GROUP BY P.Product_Name;

SELECT * FROM prod_profits;

-- 9.Country Performance View.
CREATE VIEW country_perf_view AS 
SELECT
	C.Country,
	SUM(S.Total_Sales) AS revenue,
	SUM(S.Profit) AS profit,
	ROUND(SUM(S.Profit) * 100.00/ SUM(S.Total_Sales), 2) 
	AS country_profit_margin
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID = O.Customer_ID
INNER JOIN Sales S
ON O.Order_ID = S.Order_ID 
GROUP BY C.Country;

SELECT * FROM country_perf_view;

-- 10. Executive Summary View.
CREATE VIEW  executive_summary_view AS
SELECT 
	C.Region,
	SUM(S.Total_Sales) AS revenue,
	SUM(S.Profit) AS profit,
	COUNT(DISTINCT C.Customer_ID) AS cust_counts,
	COUNT(DISTINCT O.Order_ID) AS order_counts,
	 ROUND(SUM(S.Profit) * 100.0 /
        SUM(S.Total_Sales),2) AS profit_margin_pct
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID = O.Customer_ID
INNER JOIN Sales S
ON O.Order_ID = S.Order_ID
GROUP BY C.Region;

SELECT * FROM executive_summary_view;

-- 11.Top 10 customers by revenue.
SELECT TOP 10 Customer_Name,Revenue FROM vw_top_customers
ORDER BY Revenue DESC;

-- 12.Top 5 products by profit.
SELECT TOP 5 
	Product_Name,
	SUM(profit) AS Profits
FROM prod_profits
GROUP BY Product_Name
ORDER BY Profits DESC;

-- 13.Regions contributing more than 20% of total revenue.
WITH region_share AS
(
	SELECT 
		Region,
		SUM(total_sales) AS Revenue
FROM regional_revenue_views
GROUP BY Region
),
region_pert AS
(
SELECT 
	Region,
	Revenue,
	ROUND(
		Revenue * 100.00 /
		 SUM(Revenue) OVER(), 2) AS cont_pert
FROM region_share
)
SELECT *
FROM region_pert
WHERE cont_pert > 20;

-- 14.Highest revenue month.
SELECT 
	months,
	years,
	SUM(revenue) AS highest_revenue
FROM monthly_revenue_view
GROUP BY months, years
ORDER BY highest_revenue DESC;









