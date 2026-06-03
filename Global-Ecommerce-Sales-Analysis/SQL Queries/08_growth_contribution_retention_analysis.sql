USE GlobalEcommerceDB;
SELECT * FROM Global_sales;

-- ==========================================================
-- DATE FUNCTIONS PRACTICE
-- ==========================================================

-- 1. Extract Year from Order_Date
SELECT 
	YEAR(Order_Date) AS Years
FROM Global_sales
GROUP BY YEAR(Order_Date);

-- 2. Extract Month from Order_Date
SELECT 
	MONTH(Order_Date) AS Months,
	DATENAME(MONTH, Order_Date) AS Months_Name
FROM Global_sales
GROUP BY MONTH(Order_Date),
DATENAME(MONTH, Order_Date);

-- 3. Extract Quarter from Order_Date
SELECT 
	MONTH(Order_Date) AS Months,
	DATENAME(MONTH, Order_Date) AS Months_Name,
	DATEPART(QUARTER, Order_Date) AS Quarters
FROM Global_sales
GROUP BY MONTH(Order_Date),
DATENAME(MONTH, Order_Date),
DATEPART(QUARTER, Order_Date);

-- 4. Find the number of days between Order_Date and Ship_Date

-- 5. Find expected delivery date by adding 30 days to Order_Date
SELECT 
	Order_Date,
	DATEADD(DAY, 30, Order_Date) AS Expected_Delivery_Date
FROM Global_sales
GROUP BY Order_Date;

-- 6. Find total orders placed in each year
SELECT 
	YEAR(Order_Date) AS Years,
	COUNT(DISTINCT Order_ID) AS Total_No_Orders
FROM Global_sales
GROUP BY YEAR(Order_Date);

-- 7. Find total orders placed in each month
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	COUNT(DISTINCT Order_ID) AS Total_No_Orders
FROM Global_sales
GROUP BY MONTH(Order_Date), YEAR(Order_Date);

-- 8. Find total orders placed in each quarter
SELECT 
	YEAR(Order_Date) AS Years,
	DATEPART(QUARTER, Order_Date) AS Quarters,
	COUNT(DISTINCT Order_ID) AS Total_No_Orders
FROM Global_sales
GROUP BY YEAR(Order_Date), DATENAME(QUARTER, Order_Date);

-- ==========================================================
-- MONTHLY REVENUE ANALYSIS
-- ==========================================================

-- 9. Find Monthly Revenue.
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	SUM(Total_Sales) AS Revenue
FROM Global_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Months ASC;

-- 10. Find Monthly Profit.
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	SUM(Profit) AS Total_Profits
FROM Global_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Months ASC;

-- 11. Find Monthly Order Count
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	COUNT(DISTINCT Order_ID) AS Total_No_Orders
FROM Global_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Months ASC;

-- 12. Find Monthly Quantity Sold
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	COUNT(DISTINCT Order_ID) AS Total_No_Orders,
	SUM(Quantity) AS Qty_Sold
FROM Global_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Months ASC;

-- 13. Find the month with highest revenue
WITH highest_revenue AS 
(
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	SUM(Total_Sales) AS Revenue,
	RANK() OVER(
		ORDER BY SUM(Total_Sales) DESC) AS Ranks
FROM Global_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
)
SELECT * 
FROM highest_revenue
WHERE Ranks = 1;

-- 14. Find the month with lowest revenue
WITH lowest_revenue AS 
(
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	SUM(Total_Sales) AS Revenue,
	RANK() OVER(
		ORDER BY SUM(Total_Sales) ASC) AS Ranks
FROM Global_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
)
SELECT * 
FROM lowest_revenue
WHERE Ranks = 1;

-- ==========================================================
-- MONTH OVER MONTH (MoM) GROWTH ANALYSIS
-- ==========================================================

-- 15. Find Previous Month Revenue using LAG()
WITH Monthly_Revenue AS
(
    SELECT
        YEAR(Order_Date) AS Years,
        MONTH(Order_Date) AS Months,
        SUM(Total_Sales) AS Revenue
    FROM Global_sales
    GROUP BY YEAR(Order_Date),
        MONTH(Order_Date)
)
SELECT
    Years,
    Months,
    Revenue,
    LAG(Revenue) OVER(
        ORDER BY Years, Months
    ) AS Prev_Month_Revenue
FROM Monthly_Revenue;

-- 16. Find Monthly Revenue Growth %
WITH Monthly_Growth_Pert AS
(
    SELECT
        YEAR(Order_Date) AS Years,
        MONTH(Order_Date) AS Months,
        SUM(Total_Sales) AS Revenue,
		LAG(SUM(Total_Sales)) OVER(
        ORDER BY YEAR(Order_Date),
			MONTH(Order_Date)	
    ) AS Prev_Month_Revenue
    FROM Global_sales
    GROUP BY YEAR(Order_Date),
        MONTH(Order_Date)
)
SELECT
    Years,
    Months,
    Revenue,
    ROUND((Revenue - Prev_Month_Revenue) * 100.00 /
		Prev_Month_Revenue, 2) AS Gorwth_Pert
FROM Monthly_Growth_Pert;

-- 17. Find Previous Month Profit using LAG()
WITH Monthly_Profit_Revenue AS
(
    SELECT
        YEAR(Order_Date) AS Years,
        MONTH(Order_Date) AS Months,
        SUM(Total_Sales) AS Revenue,
		SUM(Profit) AS Profits
    FROM Global_sales
    GROUP BY YEAR(Order_Date),
        MONTH(Order_Date)
)
SELECT
    Years,
    Months,
    Revenue,
    LAG(Profits) OVER(
        ORDER BY Years, Months
    ) AS Prev_Month_Profits
FROM Monthly_Profit_Revenue;

-- 18. Find Monthly Profit Growth %
WITH Monthly_Prof_Pert AS
(
    SELECT
        YEAR(Order_Date) AS Years,
        MONTH(Order_Date) AS Months,
        SUM(Profit) AS Current_Month_Profits,
		LAG(SUM(Profit)) OVER(
        ORDER BY YEAR(Order_Date),
			MONTH(Order_Date)	
    ) AS Prev_Month_Profits
    FROM Global_sales
    GROUP BY YEAR(Order_Date),
        MONTH(Order_Date)
)
SELECT
    Years,
    Months,
    Current_Month_Profits,
	Prev_Month_Profits,
    ROUND((Current_Month_Profits - Prev_Month_Profits) * 100.00 /
		Prev_Month_Profits, 2) AS Gorwth_Pert
FROM Monthly_Prof_Pert;

-- 19. Find Month with Highest Revenue Growth %
WITH Monthly_Growth_Pert AS
(
    SELECT
        YEAR(Order_Date) AS Years,
        MONTH(Order_Date) AS Months,
        SUM(Total_Sales) AS Revenue,
		LAG(SUM(Total_Sales)) OVER(
        ORDER BY YEAR(Order_Date),
			MONTH(Order_Date)	
    ) AS Prev_Month_Revenue
    FROM Global_sales
    GROUP BY YEAR(Order_Date),
        MONTH(Order_Date)
)
SELECT TOP 1
    Years,
    Months,
    Revenue,
    ROUND((Revenue - Prev_Month_Revenue) * 100.00 /
		Prev_Month_Revenue, 2) AS Gorwth_Pert
FROM Monthly_Growth_Pert
ORDER BY Gorwth_Pert DESC;

-- 20. Find Month with Lowest Revenue Growth %
WITH Monthly_Prof_Pert AS
(
    SELECT
        YEAR(Order_Date) AS Years,
        MONTH(Order_Date) AS Months,
        SUM(Profit) AS Current_Month_Profits,
		LAG(SUM(Profit)) OVER(
        ORDER BY YEAR(Order_Date),
			MONTH(Order_Date)	
    ) AS Prev_Month_Profits
    FROM Global_sales
    GROUP BY YEAR(Order_Date),
        MONTH(Order_Date)
)
SELECT TOP 1
    Years,
    Months,
    Current_Month_Profits,
	Prev_Month_Profits,
    ROUND((Current_Month_Profits - Prev_Month_Profits) * 100.00 /
		Prev_Month_Profits, 2) AS Gorwth_Pert
FROM Monthly_Prof_Pert
ORDER BY Gorwth_Pert DESC;
