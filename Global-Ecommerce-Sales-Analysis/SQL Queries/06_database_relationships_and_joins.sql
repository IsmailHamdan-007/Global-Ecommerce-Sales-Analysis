USE GlobalEcommerceDB;

SELECT * FROM Global_sales;

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Sales;

-- =========================== INNER JOINS ===========================

-- 1.Customer Order Details.
SELECT 
	O.Order_ID,
	O.Order_Date,
	C.Customer_Name
FROM Orders O
INNER JOIN Customers C
ON O.Customer_ID = C.Customer_ID;

-- 2.Product Sales Analysis.
SELECT 
	P.Product_Name,
	P.Product_Category,
	S.Quantity,
	S.Total_Sales,
	S.Profit
FROM  Sales S 
INNER JOIN Products P
ON S.Product_ID = P.Product_ID;

-- 3.Revenue by Customer.
SELECT
	C.Customer_ID,
	C.Customer_Name,
	SUM(S.Total_Sales) AS revenue
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID = O.Customer_ID
INNER JOIN Sales S
ON O.Order_ID = S.Order_ID
GROUP BY C.Customer_ID,C.Customer_Name;

-- 4.Profit by Product Category.
SELECT 
	P.Product_Category,
	SUM(Profit) AS profit
FROM Products P
INNER JOIN Sales S
ON P.Product_ID = S.Product_ID
GROUP BY P.Product_Category;

-- 5.Regional Revenue Analysis.
SELECT 
	C.Region,
	SUM(S.Total_Sales) AS revenue
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID = O.Customer_ID
INNER JOIN Sales S
ON O.Order_ID = S.Order_ID
GROUP BY C.Region;

-- 6.Top Selling Products.
WITH top_products AS (
SELECT
	P.Product_Name,
	SUM(S.Total_Sales) AS sales,
	RANK() OVER(
		ORDER BY SUM(S.Total_Sales) DESC) AS ranks
FROM Products P
INNER JOIN Sales S
ON P.Product_ID = S.Product_ID
GROUP BY P.Product_Name
)
SELECT * 
FROM top_products
WHERE ranks <= 3;

-- 7.Customer Purchase Frequency.
SELECT 
	C.Customer_ID,
	C.Customer_Name,
	COUNT(O.Order_ID) AS Counts
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID = O.Customer_ID
GROUP BY C.Customer_ID,C.Customer_Name;

-- 8.Monthly Revenue Trends.
SELECT 
	MONTH(O.Order_Date) AS Months,
	SUM(S.Total_Sales) AS Revenue
FROM Orders O
INNER JOIN Sales S
ON O.Order_ID = S.Order_ID
GROUP BY MONTH(O.Order_Date)
ORDER BY Months ASC;

-- 9.Average Order Value by Region.
SELECT 
	C.Region,
	AVG(S.Total_Sales) AS avg_order_value
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID = O.Customer_ID
INNER JOIN Sales S
ON O.Order_ID = S.Order_ID
GROUP BY C.Region;

-- 10. Top Customers by Profit.
WITH top_cust AS 
(
SELECT
	C.Customer_Name,
	SUM(Profit) AS profit,
	RANK() OVER(
		ORDER BY SUM(S.Profit) DESC) AS ranks
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID = O.Customer_ID
INNER JOIN Sales S 
ON O.Order_ID = S.Order_ID
GROUP BY C.Customer_Name
)
SELECT * 
FROM top_cust
WHERE ranks < = 10;


-- ========================================= LEFT JOINS ======================================== --

-- 11.Customers Who Never Ordered.
SELECT 
	C.Customer_ID,
	C.Customer_Name,
	O.Order_ID
FROM Customers C
LEFT JOIN Orders O
ON C.Customer_ID = O.Customer_ID
WHERE O.Order_ID IS NULL;

-- 12.Products Never Sold.
SELECT 
	P.Product_ID,
	P.Product_Name,
	S.Total_Sales
FROM Products P
LEFT JOIN Sales S
ON P.Product_ID = S.Product_ID
WHERE S.Total_Sales IS NULL;

-- 13.Orders Without Sales.
SELECT 
	O.Order_ID,
	S.Total_Sales
FROM Orders O
LEFT JOIN Sales S
ON O.Order_ID = S.Order_ID
WHERE S.Total_Sales IS NULL;

-- 14.Most Profitable Product by Country.
WITH profit_prod AS
(
	SELECT 
		C.Country,
		P.Product_Name,
		SUM(S.Profit) AS Profit,
		RANK() OVER(
			PARTITION BY C.Country ORDER BY SUM(S.Profit) DESC) AS ranks
	FROM Customers C
	LEFT JOIN Orders O
	ON C.Customer_ID = O.Customer_ID 
	LEFT JOIN Sales S
	ON O.Order_ID = S.Order_ID
	LEFT JOIN Products P
	ON S.Product_ID = P.Product_ID
	GROUP BY C.Country, P.Product_Name
)
SELECT * 
FROM profit_prod
WHERE ranks <= 2;


-- ==================================== ADVANCED JOINS =======================================

-- 15.Best Selling Product in Each Region.
WITH BSP AS
(
	SELECT 
		C.Region,
		P.Product_Name,
		SUM(S.Total_Sales) AS Sales,
		RANK() OVER(
			PARTITION BY C.Region ORDER BY SUM(S.Total_Sales) DESC) AS ranks
	FROM Customers C
	INNER JOIN Orders O
	ON C.Customer_ID = O.Customer_ID
	INNER JOIN Sales S
	ON O.Order_ID = S.Order_ID
	INNER JOIN Products P
	ON S.Product_ID = P.Product_ID
	GROUP BY C.Region, P.Product_Name
)
SELECT * 
FROM BSP
WHERE ranks <= 3;

-- 16.Customer Lifetime Value.
SELECT 
	C.Customer_ID,
	C.Customer_Name,
	SUM(S.Total_Sales) AS CLV
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID = O.Customer_ID
INNER JOIN Sales S
ON O.Order_ID = S.Order_ID
GROUP BY C.Customer_ID, C.Customer_Name
ORDER BY CLV DESC;

-- 17.Repeat Customer Analysis.
SELECT 
	C.Customer_ID,
	C.Customer_Name,
	COUNT(O.Order_ID) AS cust_counts
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID = O.Customer_ID
GROUP BY C.Customer_ID,C.Customer_Name
ORDER BY cust_counts DESC;

-- 18.Revenue Contribution Percentage.
SELECT
	P.Product_Category,
	SUM(S.Total_Sales) AS revenue,
	ROUND(SUM(S.Total_Sales) * 100.00 / SUM(SUM(S.Total_Sales)) OVER(), 2) AS Rvenue_share
FROM Products P
INNER JOIN Sales S
ON P.Product_ID = S.Product_ID
GROUP BY P.Product_Category;

-- 19.Product Profit Margin Analysis.
SELECT
	P.Product_Name,
	P.Product_Category,
	SUM(S.Total_Sales) AS revenue,
	ROUND(SUM(S.Profit) * 100.00 / SUM(S.Total_Sales), 2) AS product_margin
FROM Products P 
INNER JOIN Sales S
ON p.Product_ID = S.Product_ID
GROUP BY P.Product_Name, P.Product_Category;









