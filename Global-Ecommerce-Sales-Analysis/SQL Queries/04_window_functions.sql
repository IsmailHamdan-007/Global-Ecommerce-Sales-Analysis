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





























