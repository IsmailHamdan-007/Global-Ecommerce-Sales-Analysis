USE GlobalEcommerceDB;

SELECT * FROM Global_sales;

-- ================== CTEs + Subqueries ======================

-- 1.Find Products with Sales Greater Than Average Sales.
SELECT Product_Name,
	SUM(Total_Sales) AS Sales
FROM Global_sales
GROUP BY Product_Name
HAVING SUM(Total_Sales) > (
SELECT AVG(Total_Sales) FROM Global_sales)
ORDER BY Sales DESC;

SELECT Product_Name,
       SUM(Total_Sales) AS Sales
FROM Global_sales
GROUP BY Product_Name
HAVING SUM(Total_Sales) >
(
    SELECT AVG(Product_Total)
    FROM
    (
        SELECT SUM(Total_Sales) AS Product_Total
        FROM Global_sales
        GROUP BY Product_Name
    ) AS Avg_Sales
)
ORDER BY Sales DESC;

-- 2.Find Customers with Highest Total Sales.
WITH Customers AS(
	SELECT Customer_Name,
	SUM(Total_Sales) AS Highest_Sales
	FROM Global_sales
	GROUP BY Customer_Name)
SELECT * FROM Customers
ORDER BY Highest_Sales DESC;

-- 3.Find Orders Above Average Profit
WITH Orders AS(
	SELECT Order_ID,
	Profit 
	FROM Global_sales
	WHERE Profit > (SELECT AVG(Profit) FROM Global_sales))
SELECT * FROM Orders
ORDER BY Profit DESC;

-- 4.Find Countries with Total Sales Above Overall Average Revenue.
WITH Countries AS(
	SELECT Country, 
	SUM(Total_Sales) AS Total_Sale,
	AVG(Total_Sales) AS AVG_SALES
	FROM Global_sales
	GROUP BY Country
	)
SELECT * FROM Countries
WHERE Total_Sale > (
	SELECT AVG(Total_Sales) FROM
	Global_sales)
ORDER BY Total_Sale DESC;

-- 5.Find Second Highest Sales Value.
SELECT MAX(Total_Sales) AS Second_Highest_Sales
FROM Global_sales
WHERE  Total_Sales <
(SELECT MAX(Total_Sales)  
FROM Global_sales);

-- 6.Create CTE for Total Sales Per Customer
-- find top 5 customers
WITH Customer AS (
	SELECT Customer_Name,
	SUM(Total_Sales) AS Total_Sale
	FROM Global_sales
	GROUP BY Customer_Name
	)
SELECT TOP 5 * FROM Customer
ORDER BY Total_Sale DESC;

-- 7.Create CTE for Region-wise Revenue.
WITH Region_revenue AS (
	SELECT Region,
	SUM(Total_Sales) AS Revenue
	FROM Global_sales
	GROUP BY Region)
SELECT * FROM Region_revenue;

-- 8.Find Customers Above Average Revenue Using CTE.
WITH Customer_Revenue AS (
	SELECT Customer_Name,
	SUM(Total_Sales) AS Revenue
	FROM Global_sales
	GROUP BY Customer_Name)

SELECT * FROM Customer_Revenue
	WHERE Revenue > (
	SELECT AVG(Total_Sales)
	FROM Global_sales)
ORDER BY Revenue DESC;

-- 9.Create Monthly Revenue CTE
WITH Monthly_Revenue AS (
	SELECT MONTH(Order_Date) AS months_no, 
	DATENAME(MONTH, Order_Date) AS months,
	SUM(Total_Sales) AS revenue
	FROM Global_sales
	GROUP BY MONTH(Order_Date),DATENAME(MONTH, Order_Date))
SELECT * 
FROM Monthly_Revenue
ORDER BY revenue DESC;

-- 10.Find Top Product in Each Category.
WITH Top_category AS (
	SELECT 
	Product_Category,
	Product_Name,
	SUM(Total_Sales) AS Sales,
	RANK() OVER(PARTITION BY Product_Category
	ORDER BY SUM(Total_Sales) DESC) AS RANKS
	FROM Global_sales
	GROUP BY Product_Category,Product_Name)
SELECT *
	FROM Top_category
	WHERE RANKS = 1;








































