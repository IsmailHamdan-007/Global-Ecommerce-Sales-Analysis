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
SELECT 
	Order_Date,
	Ship_Date,
	DATEDIFF(DAY, Order_Date, Ship_Date) AS No_Of_Days
FROM Global_Sales
GROUP BY Order_Date;

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

-- ==========================================================
-- QUARTERLY ANALYSIS
-- ==========================================================

-- 21. Find Quarterly Revenue
SELECT 
	YEAR(Order_Date) AS Years,
	DATEPART(QUARTER, Order_Date) AS Quarters,
	SUM(Total_Sales) AS Revenue
FROM Global_sales
GROUP BY YEAR(Order_Date),DATEPART(QUARTER, Order_Date)
ORDER BY Years, Quarters;

-- 22. Find Quarterly Profit
SELECT 
	YEAR(Order_Date) AS Years,
	DATEPART(QUARTER, Order_Date) AS Quarters,
	SUM(Profit) AS Profits
FROM Global_sales
GROUP BY YEAR(Order_Date),DATEPART(QUARTER, Order_Date)
ORDER BY Years, Quarters;

-- 23. Find Previous Quarter Revenue using LAG()
SELECT 
	YEAR(Order_Date) AS Years,
	DATEPART(QUARTER, Order_Date) AS Quarters,
	SUM(Total_Sales) AS Revenue,
	LAG(SUM(Total_Sales)) OVER(
		ORDER BY DATEPART(QUARTER, Order_Date), YEAR(Order_Date) ASC)
	AS Prev_Qtr_Revenue
FROM Global_sales
GROUP BY YEAR(Order_Date),DATEPART(QUARTER, Order_Date)
ORDER BY Years, Quarters;

-- 24. Find Quarter-over-Quarter Revenue Growth %
WITH QoQ_Rev_Growth AS
(
	SELECT 
		YEAR(Order_Date) AS Years,
		DATEPART(QUARTER, Order_Date) AS Qtr,
		SUM(Total_Sales) AS Current_Qtr_Rev,
		LAG(SUM(Total_Sales)) OVER(
			ORDER BY YEAR(Order_Date),
				DATEPART(QUARTER, Order_Date) ASC)
		AS Prev_Qtr_Rev
	FROM Global_sales
	GROUP BY YEAR(Order_Date),DATEPART(QUARTER, Order_Date)
)
SELECT 
	Years,
	Qtr,
	Current_Qtr_Rev,
	Prev_Qtr_Rev,
	ROUND((Current_Qtr_Rev - Prev_Qtr_Rev) * 100.00 /
		Prev_Qtr_Rev, 2) AS Growth_Pert
FROM QoQ_Rev_Growth;
		
-- 25. Find Previous Quarter Profit using LAG()
SELECT 
	YEAR(Order_Date) AS Years,
	DATEPART(QUARTER, Order_Date) AS Quarters,
	SUM(Profit) AS Profits,
	LAG(SUM(Profit)) OVER(
		ORDER BY DATEPART(QUARTER, Order_Date), YEAR(Order_Date) ASC)
	AS Prev_Qtr_Profit
FROM Global_sales
GROUP BY YEAR(Order_Date),DATEPART(QUARTER, Order_Date)
ORDER BY Years, Quarters;

-- 26. Find Quarter-over-Quarter Profit Growth %
WITH QoQ_Prof_Growth AS
(
	SELECT 
		YEAR(Order_Date) AS Years,
		DATEPART(QUARTER, Order_Date) AS Qtr,
		SUM(Profit) AS Current_Qtr_Prof,
		LAG(SUM(Profit)) OVER(
			ORDER BY YEAR(Order_Date),
				DATEPART(QUARTER, Order_Date) ASC)
		AS Prev_Qtr_Prof
	FROM Global_sales
	GROUP BY YEAR(Order_Date),DATEPART(QUARTER, Order_Date)
)
SELECT 
	Years,
	Qtr,
	Current_Qtr_Prof,
	Prev_Qtr_Prof,
	ROUND((Current_Qtr_Prof - Prev_Qtr_Prof) * 100.00 /
		Prev_Qtr_Prof, 2) AS Growth_Pert
FROM QoQ_Prof_Growth;

-- 27. Find Quarter with Highest Revenue
WITH Qtr_Highest_Revenue AS
(
	SELECT 
		YEAR(Order_Date) AS Years,
		DATEPART(QUARTER, Order_Date) AS Qtr,
		SUM(Total_Sales) AS Current_Qtr_Rev,
		LAG(SUM(Total_Sales)) OVER(
			ORDER BY YEAR(Order_Date),
				DATEPART(QUARTER, Order_Date) ASC)
		AS Prev_Qtr_Rev
	FROM Global_sales
	GROUP BY YEAR(Order_Date),DATEPART(QUARTER, Order_Date)
)
SELECT TOP 1
	Years,
	Qtr,
	Current_Qtr_Rev,
	Prev_Qtr_Rev,
	ROUND((Current_Qtr_Rev - Prev_Qtr_Rev) * 100.00 /
		Prev_Qtr_Rev, 2) AS Growth_Pert
FROM Qtr_Highest_Revenue
ORDER BY Growth_Pert DESC;

-- 28. Find Quarter with Highest Profit
WITH Qtr_Highest_Profit AS
(
	SELECT 
		YEAR(Order_Date) AS Years,
		DATEPART(QUARTER, Order_Date) AS Qtr,
		SUM(Profit) AS Current_Qtr_Prof,
		LAG(SUM(Profit)) OVER(
			ORDER BY YEAR(Order_Date),
				DATEPART(QUARTER, Order_Date) ASC)
		AS Prev_Qtr_Prof
	FROM Global_sales
	GROUP BY YEAR(Order_Date),DATEPART(QUARTER, Order_Date)
)
SELECT TOP 1
	Years,
	Qtr,
	Current_Qtr_Prof,
	Prev_Qtr_Prof,
	ROUND((Current_Qtr_Prof - Prev_Qtr_Prof) * 100.00 /
		Prev_Qtr_Prof, 2) AS Growth_Pert
FROM Qtr_Highest_Profit
ORDER BY Growth_Pert DESC;

-- ==========================================================
-- YEAR OVER YEAR (YoY) ANALYSIS
-- ==========================================================

-- 29. Find Yearly Revenue
SELECT 
	YEAR(Order_Date) AS Years,
	SUM(Total_Sales) AS Revenue
FROM Global_sales
GROUP BY YEAR(Order_Date)
ORDER BY Years ASC;

-- 30. Find Previous Year Revenue using LAG()
SELECT 
	YEAR(Order_Date) AS Years,
	SUM(Total_Sales) AS Revenue,
	LAG(SUM(Total_Sales)) OVER(
		ORDER BY YEAR(Order_Date) ASC) AS Prev_Year_Rev
FROM Global_sales
GROUP BY YEAR(Order_Date);

-- 31. Find Year-over-Year Revenue Growth %
WITH YoY_Rev_Growth AS
(
	SELECT 
	YEAR(Order_Date) AS Years,
	SUM(Total_Sales) AS Cur_Year_Revenue,
	LAG(SUM(Total_Sales)) OVER(
		ORDER BY YEAR(Order_Date) ASC) AS Prev_Year_Rev
FROM Global_sales
GROUP BY YEAR(Order_Date)
)
SELECT 
	Years,
	Cur_Year_Revenue,
	Prev_Year_Rev,
	ROUND((Cur_Year_Revenue - Prev_Year_Rev) * 100 /
		Prev_Year_Rev, 2) AS Growht_Pert
FROM YoY_Rev_Growth;

-- 32. Find Yearly Profit
SELECT 
	YEAR(Order_Date) AS Years,
	SUM(Profit) AS Profit
FROM Global_sales
GROUP BY YEAR(Order_Date)
ORDER BY Years ASC;

-- 33. Find Previous Year Profit using LAG()
SELECT 
	YEAR(Order_Date) AS Years,
	SUM(Profit) AS Profit,
	LAG(SUM(Profit)) OVER(
		ORDER BY YEAR(Order_Date) ASC) AS Prev_Year_Prof
FROM Global_sales
GROUP BY YEAR(Order_Date);

-- 34. Find Year-over-Year Profit Growth %
WITH YoY_Rev_Growth AS
(
	SELECT 
	YEAR(Order_Date) AS Years,
	SUM(Profit) AS Cur_Year_Prof,
	LAG(SUM(Profit)) OVER(
		ORDER BY YEAR(Order_Date) ASC) AS Prev_Year_Prof
FROM Global_sales
GROUP BY YEAR(Order_Date)
)
SELECT 
	Years,
	Cur_Year_Prof,
	Prev_Year_Prof,
	ROUND((Cur_Year_Prof - Prev_Year_Prof) * 100 /
		Prev_Year_Prof, 2) AS Growht_Pert
FROM YoY_Rev_Growth;

-- ==========================================================
-- CONTRIBUTION ANALYSIS
-- ==========================================================

-- 35. Find Region Revenue Contribution %
SELECT 
	Region,
	SUM(Total_Sales) AS Revenue,
	ROUND(SUM(Total_Sales) * 100.00 /
		SUM(SUM(Total_Sales)) OVER(), 2) 
	AS Contribution_Pert
FROM Global_sales
GROUP BY Region
ORDER BY Contribution_Pert DESC;

-- 36. Find Product Revenue Contribution %
SELECT 
	Product_Name,
	SUM(Total_Sales) AS Revenue,
	ROUND(SUM(Total_Sales) * 100.00 /
		SUM(SUM(Total_Sales)) OVER(), 2) 
	AS Contribution_Pert
FROM Global_sales
GROUP BY Product_Name
ORDER BY Contribution_Pert DESC;

-- 37. Find Customer Revenue Contribution %
SELECT 
	Customer_Name,
	SUM(Total_Sales) AS Revenue,
	ROUND(SUM(Total_Sales) * 100.00 /
		SUM(SUM(Total_Sales)) OVER(), 2) 
	AS Contribution_Pert
FROM Global_sales
GROUP BY Customer_Name
ORDER BY Contribution_Pert DESC;

-- 38. Find Category Revenue Contribution %
SELECT 
	Product_Category,
	SUM(Total_Sales) AS Revenue,
	ROUND(SUM(Total_Sales) * 100.00 /
		SUM(SUM(Total_Sales)) OVER(), 2) 
	AS Contribution_Pert
FROM Global_sales
GROUP BY Product_Category
ORDER BY Contribution_Pert DESC;

-- 39. Find Regions Contributing More Than 20% Revenue
WITH Region_Cont_MT20 AS
(
	SELECT 
	Region,
	SUM(Total_Sales) AS Revenue,
	ROUND(SUM(Total_Sales) * 100.00 /
		SUM(SUM(Total_Sales)) OVER(), 2) 
	AS Contribution_Pert
FROM Global_sales
GROUP BY Region
)
SELECT * 
FROM Region_Cont_MT20
WHERE Contribution_Pert > 20
ORDER BY Contribution_Pert DESC;

-- 40. Find Products Contributing More Than 10% Revenue
WITH Prod_Cont_MT10 AS
(
	SELECT 
	Product_Name,
	SUM(Total_Sales) AS Revenue,
	ROUND(SUM(Total_Sales) * 100.00 /
		SUM(SUM(Total_Sales)) OVER(), 2) 
	AS Contribution_Pert
FROM Global_sales
GROUP BY Product_Name
)
SELECT *
FROM Prod_Cont_MT10
WHERE Contribution_Pert > 10
ORDER BY Contribution_Pert DESC;

-- 41. Find Top 5 Customers by Revenue Contribution %
SELECT TOP 5 
	Customer_Name,
	SUM(Total_Sales) AS Revenue,
	ROUND(SUM(Total_Sales) * 100.00 /
		SUM(SUM(Total_Sales)) OVER(), 2) 
	AS Contribution_Pert
FROM Global_sales
GROUP BY Customer_Name
ORDER BY Contribution_Pert DESC;


-- ==========================================================
-- CUSTOMER RETENTION ANALYSIS
-- ==========================================================

-- 42. Find Repeat Customers (More Than One Order)
SELECT 
	Customer_Name,
	COUNT(DISTINCT Order_ID) AS Counts
FROM Global_sales
GROUP BY Customer_Name
HAVING COUNT(DISTINCT Order_ID) > 1;

-- 43. Find Customers With Only One Order
SELECT 
	Customer_Name,
	COUNT(DISTINCT Order_ID) AS Counts
FROM Global_sales
GROUP BY Customer_Name
HAVING COUNT(DISTINCT Order_ID) = 1;

-- 44. Find Customer First Purchase Date
SELECT DISTINCT
	Customer_Name,
	MIN(Order_Date) AS  First_Purchase_Date
FROM Global_sales
GROUP BY Customer_Name, Order_Date;

-- 45. Find Customer Last Purchase Date
SELECT 
	Customer_Name,
	MAX(Order_Date) AS  Last_Purchase_Date
FROM Global_sales
GROUP BY Customer_Name, Order_Date;

-- 46. Find Customer Lifetime Value (CLV)
SELECT 
	Customer_Name,
	COUNT(DISTINCT Order_ID) AS Counts,
	SUM(Total_Sales) AS Revenue,
	SUM(Profit) AS CLV
FROM Global_sales
GROUP BY Customer_Name
ORDER BY CLV DESC;

-- 47. Find Customers Ordering Across Multiple Months
SELECT 
	Customer_Name,
	COUNT(DISTINCT 
		FORMAT(Order_Date, 'YYYY-MM'))
	AS Mul_Months_Ordered
FROM Global_sales
GROUP BY Customer_Name
HAVING COUNT(DISTINCT 
		FORMAT(Order_Date, 'YYYY-MM')) > 1
ORDER BY Mul_Months_Ordered DESC;

-- 48. Find Customers Inactive For More Than 90 Days
SELECT 
	Customer_Name,
	MAX(Order_Date) AS Last_Purchase_Date,
	DATEDIFF(DAY, MAX(Order_Date), GETDATE())
	AS Day_Diff
FROM Global_sales
GROUP BY Customer_Name
HAVING DATEDIFF(DAY, MAX(Order_Date), GETDATE()) > 90
ORDER BY Day_Diff DESC;

-- 49. Find Top 10 Customers By CLV
WITH Top_10s_Cust AS
(
SELECT 
	Customer_Name,
	COUNT(DISTINCT Order_ID) AS Counts,
	SUM(Total_Sales) AS Revenue,
	SUM(Profit) AS CLV,
	ROW_NUMBER() OVER(
		ORDER BY SUM(Profit) DESC) AS TOP_10s
FROM Global_sales
GROUP BY Customer_Name
)
SELECT *
FROM Top_10s_Cust
WHERE TOP_10s <= 10;

-- ==========================================================
-- WINDOW FUNCTION PRACTICE
-- ==========================================================

-- 50. Assign ROW_NUMBER() to Customers by Revenue
SELECT 
	Customer_Name,
	SUM(Total_Sales) AS Revenue,
	ROW_NUMBER() OVER(
		ORDER BY SUM(Total_Sales) DESC)
	AS RN
FROM Global_sales
GROUP BY Customer_Name;

-- 51. Assign RANK() to Customers by Revenue
SELECT 
	Customer_Name,
	SUM(Total_Sales) AS Revenue,
	RANK() OVER(
		ORDER BY SUM(Total_Sales) DESC)
	AS RANKS
FROM Global_sales
GROUP BY Customer_Name;

-- 52. Assign DENSE_RANK() to Customers by Revenue
SELECT 
	Customer_Name,
	SUM(Total_Sales) AS Revenue,
	DENSE_RANK() OVER(
		ORDER BY SUM(Total_Sales) DESC)
	AS RANKS
FROM Global_sales
GROUP BY Customer_Name;

-- 53. Find Top 5 Customers by Revenue using RANK()
WITH Top_5s_Cust AS
(
SELECT 
	Customer_Name,
	SUM(Total_Sales) AS Revenue,
	RANK() OVER(
		ORDER BY SUM(Profit) DESC) AS TOP_5s
FROM Global_sales
GROUP BY Customer_Name
)
SELECT *
FROM Top_5s_Cust
WHERE TOP_5s <= 5;

-- 54. Find Bottom 5 Customers by Revenue
WITH Bottom_5s_Cust AS
(
SELECT 
	Customer_Name,
	SUM(Total_Sales) AS Revenue,
	RANK() OVER(
		ORDER BY SUM(Profit) ASC) AS BOT_5s
FROM Global_sales
GROUP BY Customer_Name
)
SELECT *
FROM Bottom_5s_Cust
WHERE BOT_5s <= 5;

-- 55. Assign ROW_NUMBER() to Products Within Each Category
SELECT 
	Product_Category,
	Product_Name,
	SUM(Total_Sales) AS Revenue,
	ROW_NUMBER() OVER(
		PARTITION BY Product_Category
		ORDER BY SUM(Total_Sales) DESC) AS RN
FROM Global_sales
GROUP BY Product_Category,
	Product_Name;

-- 56. Find Top Product in Each Category
WITH Top_Prod_Cat AS
(
SELECT 
	Product_Category,
	Product_Name,
	SUM(Total_Sales) AS Revenue,
	ROW_NUMBER() OVER(
		PARTITION BY Product_Category
		ORDER BY SUM(Total_Sales) DESC) AS RN
FROM Global_sales
GROUP BY Product_Category,
	Product_Name
)
SELECT * 
FROM Top_Prod_Cat
WHERE RN = 1;

-- 57. Find Top Customer in Each Region
WITH Top_Cust_Region AS
(
SELECT 
	Customer_Name,
	Region,
	SUM(Total_Sales) AS Revenue,
	ROW_NUMBER() OVER(
		PARTITION BY Region
		ORDER BY SUM(Total_Sales) DESC) AS RN
FROM Global_sales
GROUP BY Customer_Name,
	Region
)
SELECT * 
FROM Top_Cust_Region
WHERE RN = 1;

-- 58. Find Bottom Customer in Each Region
WITH Top_Cust_Region AS
(
SELECT 
	Customer_Name,
	Region,
	SUM(Total_Sales) AS Revenue,
	ROW_NUMBER() OVER(
		PARTITION BY Region
		ORDER BY SUM(Total_Sales) ASC) AS RN
FROM Global_sales
GROUP BY Customer_Name,
	Region
)
SELECT * 
FROM Top_Cust_Region
WHERE RN = 1;

-- 59. Find Running Revenue using SUM() OVER()
WITH Running_Revenue AS
(
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	SUM(Total_Sales) AS Revenue
FROM Global_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
)
SELECT 
	Years,
	Months,
	Revenue,
	(SUM(Revenue) OVER(
		ORDER BY Years, Months ASC)) AS Running_revenue
FROM Running_Revenue
ORDER BY Years, Months ASC;

-- 60. Find Running Profit using SUM() OVER()
WITH Running_Profits AS
(
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	SUM(Profit) AS Profits
FROM Global_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
)
SELECT 
	Years,
	Months,
	Profits,
	(SUM(Profits) OVER(
		ORDER BY Years, Months ASC)) AS Running_Profits
FROM Running_Profits
ORDER BY Years, Months ASC;

-- 61. Find Running Order Count
WITH Running_Ord_Cnt AS
(
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	COUNT(DISTINCT Order_ID) AS Counts
FROM Global_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
)
SELECT 
	Years,
	Months,
	Counts,
	(SUM(Counts) OVER(
		ORDER BY Years, Months ASC)) AS Running_Ord_Cnt
FROM Running_Ord_Cnt
ORDER BY Years, Months ASC;

-- 62. Find Running Quantity Sold
WITH Running_Qtn_Sold AS
(
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	SUM(Quantity) AS Qtn
FROM Global_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
)
SELECT 
	Years,
	Months,
	Qtn,
	(SUM(Qtn) OVER(
		ORDER BY Years, Months ASC)) AS Running_Qtn_Sold
FROM Running_Qtn_Sold
ORDER BY Years, Months ASC;


-- 63. Find Previous Customer Revenue using LAG()
SELECT 
	Customer_Name,
	SUM(Total_Sales) AS Cur_Revenue,
	LAG(SUM(Total_Sales)) OVER(
	 ORDER BY SUM(Total_Sales) DESC) AS Prev_Cust_Rev
FROM Global_sales
GROUP BY Customer_Name
ORDER BY Prev_Cust_Rev DESC;

WITH Monthly_Customer_Revenue AS
(
    SELECT
        Customer_Name,
        YEAR(Order_Date) AS Years,
        MONTH(Order_Date) AS Months,
        SUM(Total_Sales) AS Revenue
    FROM Global_sales
    GROUP BY
        Customer_Name,
        YEAR(Order_Date),
        MONTH(Order_Date)
)

SELECT
    Customer_Name,
    Years,
    Months,
    Revenue,
    LAG(Revenue) OVER(
        PARTITION BY Customer_Name
        ORDER BY Years, Months
    ) AS Prev_Month_Revenue
FROM Monthly_Customer_Revenue;

-- 64. Find Next Customer Revenue using LEAD
SELECT 
	Customer_Name,
	SUM(Total_Sales) AS Cur_Revenue,
	LEAD(SUM(Total_Sales)) OVER(
	 ORDER BY SUM(Total_Sales) DESC) AS Next_Cust_Rev
FROM Global_sales
GROUP BY Customer_Name
ORDER BY Next_Cust_Rev DESC;

WITH Monthly_Customer_Revenue AS
(
    SELECT
        Customer_Name,
        YEAR(Order_Date) AS Years,
        MONTH(Order_Date) AS Months,
        SUM(Total_Sales) AS Revenue
    FROM Global_sales
    GROUP BY
        Customer_Name,
        YEAR(Order_Date),
        MONTH(Order_Date)
)

SELECT
    Customer_Name,
    Years,
    Months,
    Revenue,
    LEAD(Revenue) OVER(
        PARTITION BY Customer_Name
        ORDER BY Years, Months
    ) AS Next_Month_Revenue
FROM Monthly_Customer_Revenue;

-- ==========================================================
-- ADVANCED BUSINESS ANALYSIS
-- ==========================================================

-- 65. Find Top 3 Products in Each Region
WITH TOP_3_Prod AS 
(
	SELECT 
		Region,
		Product_Name,
		SUM(Total_Sales) AS Revenue,
		RANK() OVER(
			PARTITION BY Region 
			ORDER BY SUM(Total_Sales) DESC) AS Top_3s
	FROM Global_sales
	GROUP BY Region,
		Product_Name
)
SELECT *
FROM TOP_3_Prod
WHERE Top_3s < =3;


-- 66. Find Top 3 Customers in Each Region
WITH TOP_3_Cust AS 
(
	SELECT 
		Region,
		Customer_Name,
		SUM(Total_Sales) AS Revenue,
		RANK() OVER(
			PARTITION BY Region 
			ORDER BY SUM(Total_Sales) DESC) AS Top_3s
	FROM Global_sales
	GROUP BY Region,
		Customer_Name
)
SELECT *
FROM TOP_3_Cust
WHERE Top_3s < =3;

-- 67. Find Most Profitable Product in Each Category
WITH Most_Prof_Prod AS 
(
	SELECT 
		Product_Category,
		Product_Name,
		SUM(Profit) AS Profits,
		RANK() OVER(
			PARTITION BY Product_Category 
			ORDER BY SUM(Profit) DESC) AS Top_3s
	FROM Global_sales
	GROUP BY Product_Category,
		Product_Name
)
SELECT *
FROM Most_Prof_Prod
WHERE Top_3s < =3;

-- 68. Find Least Profitable Product in Each Category
WITH Most_Prof_Prod AS 
(
	SELECT 
		Product_Category,
		Product_Name,
		SUM(Profit) AS Profits,
		RANK() OVER(
			PARTITION BY Product_Category 
			ORDER BY SUM(Profit) ASC) AS Top_3s
	FROM Global_sales
	GROUP BY Product_Category,
		Product_Name
)
SELECT *
FROM Most_Prof_Prod
WHERE Top_3s < =3;

-- 69. Find Highest Revenue Generating Region
SELECT TOP 1
	Region,
	SUM(Total_Sales) AS Revenue
FROM Global_sales
GROUP BY Region
ORDER BY Revenue DESC;

-- 70. Find Lowest Revenue Generating Region
SELECT TOP 1
	Region,
	SUM(Total_Sales) AS Revenue
FROM Global_sales
GROUP BY Region
ORDER BY Revenue ASC;

-- 71. Find Most Valuable Customer in Each Region
WITH MVC AS 
(
	SELECT 
		Region,
		Customer_Name,
		SUM(Total_Sales) AS Revenue,
		RANK() OVER(
			PARTITION BY Region 
			ORDER BY SUM(Total_Sales) DESC) AS Top_Cust
	FROM Global_sales
	GROUP BY Region,
		Customer_Name
)
SELECT *
FROM MVC
WHERE Top_Cust = 1;

-- 72. Find Region with Highest Profit Margin
SELECT TOP 1
	Region,
	SUM(Total_Sales) AS Reveneu,
	SUM(Profit) AS Profits,
	ROUND(SUM(Total_Sales) * 100.00/
		SUM(Profit), 2) AS Prof_Margin
FROM Global_sales
GROUP BY Region
ORDER BY Prof_Margin DESC;

-- 73. Find Category with Highest Profit Margin
SELECT TOP 1
	Product_Category,
	SUM(Total_Sales) AS Reveneu,
	SUM(Profit) AS Profits,
	ROUND(SUM(Total_Sales) * 100.00/
		SUM(Profit), 2) AS Prof_Margin
FROM Global_sales
GROUP BY Product_Category
ORDER BY Prof_Margin DESC;

-- 74. Find Customer Segment Contributing Maximum Revenue
SELECT TOP 1
	Customer_Segment,
	SUM(Total_Sales) AS Revenue
FROM Global_sales
GROUP BY Customer_Segment
ORDER BY Revenue DESC;

-- 75. Find Revenue Trend Over Time Using Running Totals
WITH Rev_ToT AS 
(
	SELECT
		MONTH(Order_Date) AS Months,
		YEAR(Order_Date) AS Years,
		SUM(Total_Sales) AS Revenue
	FROM Global_sales
	GROUP BY YEAR(Order_Date),
		MONTH(Order_Date)
)
SELECT 
	Years,
	Months,
	Revenue,
	SUM(Revenue) OVER(
		ORDER BY Years, Months) 
	AS Running_Totals
FROM Rev_ToT
ORDER BY Years, Months;

WITH Rev_ToT AS 
(
	SELECT
		MONTH(Order_Date) AS Months,
		YEAR(Order_Date) AS Years,
		SUM(Total_Sales) AS Revenue
	FROM Global_sales
	GROUP BY YEAR(Order_Date),
		MONTH(Order_Date)
)
SELECT 
	Years,
	Months,
	Revenue,
	SUM(Revenue) OVER(
		ORDER BY Years, Months) 
	AS Running_Totals
FROM Rev_ToT
WHERE Years = 2023
ORDER BY Years, Months;
