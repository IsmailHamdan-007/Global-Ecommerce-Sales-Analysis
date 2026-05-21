USE GlobalEcommerceDB;

SELECT * FROM Global_sales;

SELECT MAX(Total_Sales) FROM Global_sales;
SELECT MIN(Total_Sales) FROM Global_sales;


-- ======================== CASE-WHEN ==============================

-- 1.Categorize Sales Amount.
SELECT 
	Product_Name,
	Total_Sales,
	CASE 
		WHEN Total_Sales > 2500 THEN 'High Sales'
		WHEN Total_Sales BETWEEN 1000 AND 2500 THEN 'Medium Sales'
		ELSE 'Low Sales'
	END AS 'Sales_Category'
FROM Global_sales;

-- 2. Create Profit Status.
SELECT 
	Profit,
	CASE
		WHEN Profit > 0 THEN 'Profit'
		WHEN Profit < 0 THEN 'Loss'
		ELSE 'No Profit'
	END AS Profit_Stauts
FROM Global_sales;

-- 3. Categorize Customers by Spending.
SELECT 
	Customer_Name,
	Total_Sales,
	CASE
		WHEN Total_Sales > 500 THEN 'Premium Customers'
		WHEN Total_Sales BETWEEN 100 AND 500 THEN 'Regular Customers'
		ELSE 'Low Value Customers'
		END AS category
FROM Global_sales;

-- 4.Classify Orders by Quantity.
SELECT 
	Order_ID,
	Quantity,
	CASE 
		WHEN Quantity > 6 THEN 'Bulk_orders'
		WHEN Quantity BETWEEN 3 AND 6 THEN 'Medium_orders'
		ELSE 'Low_orders'
	END AS Orders_Category
FROM Global_sales;

-- 5. Identify High Discount Orders.
SELECT 
	Order_ID,
	Discount_Percent,
	CASE
		WHEN Discount_Percent > 20 THEN 'High_discount'
		WHEN Discount_Percent BETWEEN 10 AND 20 THEN 'Normal_discount'
		ELSE 'No_discount'
	END AS Discounts
FROM Global_sales;

-- 6. Create Regional Performance Labels.
SELECT 
	Region,
	SUM(Total_Sales) AS Revenue,
	CASE 
		WHEN SUM(Total_Sales) > 130000 THEN 'High Performing Region'
		WHEN SUM(Total_Sales) BETWEEN 120000 AND 130000 THEN 'Average Region'
		ELSE 'Low Performing Region'
	END AS Performing_Region
FROM Global_sales
GROUP BY Region;

-- 7.Create Product Profitability Status.
SELECT 
	Product_Name,
	SUM(Profit) AS Profits,
	CASE 
		WHEN SUM(Profit) > 10000 THEN 'Highly Profitable'
		WHEN SUM(Profit) BETWEEN 1000 AND 10000 THEN 'Moderately Profitable'
		WHEN SUM(Profit) < 0 THEN 'Loss Product'
		ELSE 'Low_Profitable'
	END AS Profitability_Status
FROM Global_sales
GROUP BY Product_Name
ORDER BY SUM(Profit) DESC;

-- 8.Identify Repeat Customers.
SELECT 
	Customer_Name,
	COUNT(Customer_Name) AS Counts,
	CASE
		WHEN COUNT(Customer_Name) > 1 THEN 'Repeat Customer'
		ELSE 'One-Time Customer'
	END AS repeated_customers
FROM Global_sales
GROUP BY Customer_Name;

-- 9. Categorize Months by Revenue.
SELECT  
	MONTH(Order_Date) AS MONTHS,
	SUM(Total_Sales) AS REVENUE,
	CASE 
		WHEN SUM(Total_Sales) > 40000 THEN 'Peak Sales Month'
		WHEN SUM(Total_Sales) BETWEEN 35000 AND 40000 THEN 'Average Sales Month'
		ELSE 'Low Sales Month'
	END AS CATEGORY
FROM Global_sales
GROUP BY MONTH(Order_Date)
ORDER BY REVENUE DESC;

-- 10. Create Customer Loyalty Levels.
SELECT 
	Customer_Name,
	SUM(Total_Sales) AS Purchased,
	CASE
		WHEN SUM(Total_Sales) > 500 THEN 'Gold'
		WHEN SUM(Total_Sales) BETWEEN 100 AND 500 THEN 'Silver'
		ELSE 'Bronze'
		END AS prizes
FROM Global_sales
GROUP BY Customer_Name;

-- 11.Flag Loss-Making Orders.
SELECT 
	Order_ID,
	Profit,
	CASE 
		WHEN Profit < 0 THEN 'loss'
		ELSE 'no-loss'
	END AS LOSS_FLAG
FROM Global_sales;

-- 12. Product Demand Classification.
SELECT 
	Product_Name,
	SUM(Quantity) AS total_qnt,
	SUM(Total_Sales) AS Sales,
	CASE
	 WHEN SUM(Quantity) > 200 THEN 'High Demand'
	 WHEN SUM(Quantity) BETWEEN 150 AND 200 THEN 'Medium Demand'
	 ELSE 'Low Demand'
	END AS Demands
FROM Global_sales
GROUP BY Product_Name;

-- 13. Create Revenue Contribution Labels.
SELECT 
	Country,
	Region,
	SUM(Total_Sales) AS REVENUE,
	CASE 
		WHEN SUM(Total_Sales) > 30000 THEN 'Major Contributor'
		WHEN SUM(Total_Sales) BETWEEN 15000 AND 30000 THEN 'Average Contributor'
		ELSE 'Minor Contributor'
	END AS CONTRIBUTOR
FROM Global_sales
GROUP BY Country,Region
ORDER BY REVENUE DESC ;

-- 14. Create Yearly Growth Status.
WITH growth_status AS (
SELECT 
	YEAR(Order_Date) AS Years,
	SUM(Total_Sales) AS Sales,
	LAG(SUM(Total_Sales)) OVER(
		ORDER BY YEAR(Order_Date) ASC)	AS Previous_Sales	
FROM Global_sales
GROUP BY YEAR(Order_Date)
)
SELECT
	Years,
	Sales,
	CASE 
		WHEN Sales > Previous_Sales  THEN 'Growth Year'
		ELSE 'Decline Year'
	END AS Growth_Status
FROM growth_status;












