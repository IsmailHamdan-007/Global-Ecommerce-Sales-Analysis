USE GlobalEcommerceDB;

SELECT * FROM Global_sales;

-- ======================= WINDOW FUNCTION ==========================
-- 1.Assign Row Numbers to Customers Based on Sales.
--highest sales customer should get row number 1
SELECT Customer_Name,
	SUM(Total_Sales),
	ROW_NUMBER() OVER(
	ORDER BY SUM(Total_Sales) DESC) AS row_s
FROM Global_sales
GROUP BY Customer_Name;

-- 2.Rank Products Based on Total Revenue(same sales → same rank).
SELECT 
	Product_Name,
	SUM(Total_Sales) AS Total_Revenue,
	DENSE_RANK() OVER(
	ORDER BY SUM(Total_Sales) DESC) AS ranks
FROM Global_sales
GROUP BY Product_Name;

-- 3.Rank Countries by Profit Without Skipping Ranks.
SELECT 
	Country,
	SUM(Profit) AS profits,
	DENSE_RANK() OVER(
	ORDER BY SUM(Profit) DESC) AS ranks
FROM Global_sales
GROUP BY Country;

-- 4.Find Top 3 Customers in Each Region.
WITH CustomerRanks AS (
SELECT 
	Customer_Name,
	Region,
	SUM(Total_Sales) AS Sales,
	RANK() OVER(
	PARTITION BY Region
	ORDER BY SUM(Total_Sales) DESC) AS ranks
    FROM Global_sales
    GROUP BY Customer_Name,Region)
SELECT * FROM
CustomerRanks WHERE
ranks <= 3;

-- 5.Calculate Running Monthly Sales Total.(cumulative revenue).
SELECT 
	MONTH(Order_Date) AS Months,
	SUM(Total_Sales) AS Sales,
	SUM(SUM(Total_Sales)) OVER(
	ORDER BY MONTH(Order_Date)) AS cumulative_revenue
	FROM Global_sales
	GROUP BY MONTH(Order_Date);

-- 6.Compare Current Month Sales with Previous Month Sales.
WITH MonthlySales AS (
	SELECT 
	MONTH(Order_Date) AS Months,
	SUM(Total_Sales) AS Sales
	FROM Global_sales
	GROUP BY MONTH(Order_Date))
SELECT
	Months,
	Sales,
	LAG(Sales) OVER(
	ORDER BY Months) AS  Previous_Month_Sales
	FROM MonthlySales;
	
-- 7.Show Next Month Sales Beside Current Month Sales.
WITH CurrentMonthlySales AS (
	SELECT 
	MONTH(Order_Date) AS Months,
	SUM(Total_Sales) AS Sales
	FROM Global_sales
	GROUP BY MONTH(Order_Date))
SELECT
	Months,
	Sales,
	LEAD(Sales) OVER(
	ORDER BY Months) AS  Current_Month_Sales
	FROM CurrentMonthlySales;

----8.Find Difference Between Current and Previous Sales.
WITH Sales_Diff AS (
	SELECT 
	MONTH(Order_Date) AS months,
	SUM(Total_Sales) AS Sales
	FROM Global_sales
	GROUP BY MONTH(Order_Date)) 
SELECT 
	months,
	Sales,
	LAG(Sales) OVER(
	ORDER BY months) AS previous_sales,
	Sales-
	LAG(Sales) OVER(
	ORDER BY months) AS previous_sales 
	FROM Sales_Diff;

-- 9. Find Top Profit Order Per Country.
WITH Top_profit AS (
	SELECT 
	Country,
	SUM(Profit) AS Profits
	FROM Global_sales
	GROUP BY Country)
SELECT 
	Country,
	Profits,
	RANK() OVER(
	ORDER BY Profits DESC) AS Ranks
	FROM Top_profit;

-- 10.Calculate Running Profit Total.
SELECT 
	MONTH(Order_Date) AS Months,
	SUM(Profit) AS Total_profit,
	SUM(SUM(Profit)) OVER(
		ORDER BY MONTH(Order_Date))
	AS running_profit
	FROM Global_sales
	GROUP BY MONTH(Order_Date);

-- 11.Find Average Sales Within Each Region.
WITH Sales_region AS (
	SELECT 
	Region,
	AVG(Total_Sales) AS Avg_Sales
	FROM Global_Sales
	GROUP BY Region)
SELECT *
FROM Sales_region;

-- 12.Find Highest Sales Order in Each Category.
WITH High_sales AS (
	SELECT 
		Product_Category,
		Product_Name,
		SUM(Total_Sales) AS Sales,
		RANK() OVER(
		PARTITION BY Product_Category
			ORDER BY SUM(Total_Sales) DESC) AS Ranks
	FROM Global_sales
	GROUP BY Product_Category,Product_Name)
SELECT *
FROM High_sales
WHERE Ranks <= 3;
	
-- 13.Find Lowest Profit Product in Each Region.
WITH LPG AS (
	SELECT 
		Product_Name,
		SUM(Profit) AS Lowest_profit,
		Region,
		DENSE_RANK() OVER(
			PARTITION BY Region
				ORDER BY SUm(Profit) ASC) AS Ranks
	FROM Global_sales
	GROUP BY Product_Name,Region)
SELECT * 
FROM LPG
WHERE Ranks = 1;

-- 14.Rank Customers Within Each Country.
WITH customer_ranks AS (
	SELECT 
		Customer_Name,
		Country,
		SUM(Total_Sales) AS Sales,
		RANK() OVER(
			PARTITION BY Country
				ORDER BY SUM(Total_Sales) DESC) AS Ranks
	FROM Global_sales
	GROUP BY Customer_Name,Country)
SELECT * 
FROM customer_ranks
WHERE Ranks <= 3;



























