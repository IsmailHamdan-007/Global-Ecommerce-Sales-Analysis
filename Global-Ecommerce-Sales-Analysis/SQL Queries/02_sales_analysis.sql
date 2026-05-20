USE GlobalEcommerceDB;

SELECT * FROM Global_sales;

-- ======================== Sales_Analysis ==================================

-- 1.Find total sales revenue.
SELECT SUM(Total_Sales) AS TOTAL_REVENUE FROM Global_sales;

-- 2. Find total profit.
SELECT SUM(Profit) AS TOTAL_PROFIT FROM Global_sales;

-- 3.Find top 10 customers with highest sales.
SELECT TOP 10 Customer_Name, MAX(Total_Sales)
AS HIGHEST_SALES FROM Global_sales
GROUP BY Customer_Name
ORDER BY MAX(Total_Sales) DESC;
-- BUSINESS ANALYSIS
SELECT TOP 10 Customer_Name, SUM(Total_Sales)
AS HIGHEST_SALES FROM Global_sales
GROUP BY Customer_Name
ORDER BY MAX(Total_Sales) DESC;


-- 4.Find top countries generating highest revenue.
SELECT Country, SUM(Total_Sales) AS HIGHEST_REVENUE
FROM Global_sales 
GROUP BY Country
ORDER BY SUM(Total_Sales) DESC;

-- 5. Find category with highest profit.
SELECT Product_Category, SUM(Profit) AS highest_profit 
FROM Global_sales
GROUP BY Product_Category
ORDER BY highest_profit DESC;

-- ===================== Date Functions =====================

-- 6.Find monthly sales trend using YEAR() and MONTH().
SELECT YEAR(Order_Date) AS Years,
MONTH(Order_Date) AS Months,
SUM(Total_Sales) AS Total_Sales
FROM Global_sales
GROUP BY YEAR(Order_Date),MONTH(Order_Date) 
ORDER BY Years,Months ASC;

-- 7.Find month with highest revenue.
SELECT MONTH(Order_Date) AS Months,
SUM(Total_Sales) AS HIGHEST_REVENUE 
FROM Global_sales
GROUP BY MONTH(Order_Date)
ORDER BY HIGHEST_REVENUE DESC;

SELECT TOP 1
DATENAME(MONTH, Order_Date) AS MONTH_Name,
SUM(Total_Sales) AS Highest_revenue
FROM Global_sales 
GROUP BY DATENAME(MONTH, Order_Date),MONTH(Order_Date)
ORDER BY Highest_revenue DESC;

-- 8.Count number of orders each year.
SELECT YEAR(Order_Date) AS Year, COUNT(*) AS TOTAL_COUNT 
FROM Global_sales
GROUP BY YEAR(Order_Date)
ORDER BY YEAR;

-- 9.Find average sales per order.
SELECT AVG(Total_Sales) AS AVG_Sales
FROM Global_sales;

SELECT ROUND(AVG(Total_Sales), 2) AS AVG_Sales
FROM Global_sales;
 
-- 10.Analyze sales by customer segment.
SELECT Customer_Segment,SUM(Total_Sales) AS Sales
FROM Global_sales
GROUP BY Customer_Segment
ORDER BY Sales DESC;

-- 11.Find top 5 products generating highest sales revenue.
SELECT TOP 5
Product_Name,
SUM(Total_Sales) AS highest_sales_revenue
FROM Global_sales
GROUP BY Product_Name
ORDER BY highest_sales_revenue DESC; 

-- 12.Find products with lowest profit.
SELECT Product_Name, 
SUM(Profit) AS lowest_profit 
FROM Global_sales
GROUP BY Product_Name
ORDER BY lowest_profit ASC;

-- 13.Find total sales and profit for each region.
SELECT
	Region,
	SUM(Total_Sales) AS Total_Sale,
	SUM(Profit) AS Total_Profit
FROM Global_sales
GROUP BY Region
ORDER BY Total_Sale DESC;

-- 14.Find average discount percentage for each product category.
SELECT 
	Product_Category,
	AVG(Discount_Percent) AS average_discount_percentage
FROM Global_sales
GROUP BY Product_Category
ORDER BY average_discount_percentage DESC;

-- 15.Find customers who placed more than 3 orders.
SELECT 
	Customer_Name,
	COUNT(Order_ID) AS Orders
FROM Global_sales
GROUP BY Customer_Name
HAVING COUNT(Order_ID) > 3;

-- 16.Find Highest Revenue Country Each Year.
SELECT
	Country,
	YEAR(Order_Date) AS Years,
	SUM(Total_Sales) AS Highest_revenue
FROM Global_sales
GROUP BY YEAR(Order_Date),Country
ORDER BY Years,Highest_revenue DESC;



























