CREATE DATABASE GlobalEcommerceDB;

USE GlobalEcommerceDB;

SELECT * FROM Global_sales;


------------------------ Data Cleaning ----------------------------

-- 1.Find total number of rows in the dataset.

SELECT COUNT(*) AS Total_rows FROM Global_sales;

-- 2.Find duplicate Order_ID values.

SELECT DISTINCT(Order_ID) AS Duplicates FROM Global_sales GROUP BY Region HAVING COUNT(*)>1 ;

-- 3.Check which columns contain NULL values.

SELECT Total_Sales,Profit,Country,Customer_Name,Order_Date FROM Global_sales
WHERE (Total_Sales IS NULL OR 
Profit IS NULL OR
Country IS NULL OR
Customer_Name IS NULL OR 
Order_Date IS NULL) ;

-- 4.Find rows where Customer_Name is empty or blank.

SELECT * FROM Global_sales WHERE TRIM(Customer_Name) IS NULL ;

-- 5.Convert Order_Date into DATE datatype using TRY_CONVERT().

ALTER TABLE Global_sales ALTER COLUMN Order_Date DATE;

-- 6.Find rows where Order_Date cannot be converted into DATE.

SELECT * FROM Global_sales WHERE TRY_CONVERT(DATE, Order_Date) IS NULL 
AND Order_Date IS NOT NULL;

-- 7. Convert Sales column into FLOAT datatype.
ALTER TABLE Global_sales ALTER COLUMN Total_Sales FLOAT;
ALTER TABLE Global_sales ALTER COLUMN Total_Sales DECIMAL(10,2);


-- 8. Find rows where Sales cannot be converted into FLOAT.
SELECT * FROM Global_sales WHERE TRY_CAST(Total_Sales AS FLOAT)  IS NULL 
AND Total_Sales IS NOT NULL;

-- 9.Remove Leading and Trailing Spaces
SELECT TRIM(Customer_Name) AS Customer_Name FROM Global_sales;


-- 10.Convert Country names into uppercase.
UPDATE Global_sales SET Country  = UPPER(Country);

-- 11.Create a new column called Clean_Sales with converted numeric values.
ALTER TABLE Global_sales ADD Cleaned_Sales DECIMAL(10,2);

UPDATE Global_sales SET Cleaned_Sales = TRY_CONVERT(DECIMAL(10,2), Total_Sales);

SELECT Total_Sales, Cleaned_Sales FROM Global_sales;

-- 12.Replace NULL Profit values with 0.
ALTER TABLE Global_sales ALTER COLUMN Profit DECIMAL(10,2);

ALTER TABLE Global_sales ALTER COLUMN Unit_Price DECIMAL(10,2);

ALTER TABLE Global_sales ALTER COLUMN Shipping_Cost DECIMAL(10,2);

ALTER TABLE Global_sales ALTER COLUMN Discount_Percent INT;

UPDATE Global_sales SET Profit = 0 
WHERE Profit IS NULL;

-- 13.Find all rows where Profit is negative.
SELECT * FROM Global_sales WHERE Profit < 0;

-- 14.Find rows where Country contains numbers
SELECT * FROM Global_sales WHERE Country LIKE '%[0-9]%';

-- 15.Find future dates
SELECT * FROM Global_sales WHERE Order_Date > GETDATE();

-- 16.Find rows with negative sales
SELECT * FROM Global_sales WHERE Total_Sales < 0;





















