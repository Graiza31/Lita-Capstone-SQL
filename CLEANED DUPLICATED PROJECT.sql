 select * from [dbo].[SALES DATA CLEANED DUPLICATED]

 select * from [dbo].[CUSTOMER DATA CLEANED DUPLICATED]



---- NO 1. To retrieve the total sales for each category


SELECT product, sum([Total_Sales]) AS Total_Sales
FROM [dbo].[SALES DATA CLEANED DUPLICATED]
GROUP BY product
ORDER BY SUM([Total_Sales]) DESC;


-----  No 2. find the number of sales transactions in each region

SELECT Region , COUNT([Quantity]) AS Count_Sales
FROM [dbo].[SALES DATA CLEANED DUPLICATED]
GROUP BY Region
ORDER BY COUNT([Quantity])


----  NO 3. fInd the highest selling product by total sales value

SELECT TOP 1 PRODUCT, SUM(quantity*[UnitPrice]) AS Total_Revenue
FROM [dbo].[SALES DATA CLEANED DUPLICATED]
GROUP BY product


---- NO 4. Calculate total revenue per product
 
 SELECT Product, SUM([Total_Sales]) AS Revenue
 FROM [dbo].[SALES DATA CLEANED DUPLICATED] 
 GROUP BY  product
 ORDER BY Sum([Total_Sales]) ASC;


 ---NO 5. calculate monthly sales totals for the current year.

select Month(Orderdate) As Month,
Sum([Total_Sales]) As Monthly_Sales
from [dbo].[SALES DATA CLEANED DUPLICATED]
where 
Year(Orderdate) = YEAR([OrderDate])
GROUP BY
    MONTH(Orderdate)
ORDER BY
   Month;



   --- NO 6. Find the top 5 customers by total purchase amount.

SELECT TOP 5 [Customer_Id], SUM([Total_Sales]) AS total_purchase_amount
FROM [dbo].[SALES DATA CLEANED DUPLICATED]
GROUP BY [Customer_Id]
ORDER BY SUM([Total_Sales]) DESC;


 ----NO.7  To calculate the percentage of total sales contributed by each region---

SELECT 
    Region, 
    SUM(Quantity * UnitPrice) AS Regional_Sales,
    (SUM(Quantity * UnitPrice) * 1.0 / (SELECT SUM(Quantity * UnitPrice) 
	FROM [dbo].[SALES DATA CLEANED DUPLICATED])) * 100 AS Percentage_of_Total_Sales
FROM 
    [dbo].[SALES DATA CLEANED DUPLICATED]
GROUP BY 
    Region
ORDER BY 
    Regional_Sales DESC;





---NO 8 identify products with no sales in the last quarter.


SELECT Product FROM [dbo].[SALES DATA CLEANED DUPLICATED]
GROUP BY Product
HAVING SUM(CASE 
WHEN OrderDate BETWEEN '2024-06-01' AND '2024-08-31' 
THEN 1 ELSE 0 END) = 0



Select distinct product
From [dbo].[SALES DATA CLEANED DUPLICATED]
Where product Not In(
Select product
From [dbo].[SALES DATA CLEANED DUPLICATED]
Where OrderDate >= DateAdd(quarter, -1, GetDate()) and OrderDate < GetDate());






---No. 1. Total number of customer for each region

SELECT Region,
COUNT(CustomerId) AS Number_of_Customer 
FROM [dbo].[CUSTOMER DATA CLEANED DUPLICATED]
GROUP BY Region


----No. 2. Popular subcription type by the number of customers

SELECT SubscriptionType,
COUNT(CustomerId) AS Customer
FROM [dbo].[CUSTOMER DATA CLEANED DUPLICATED]
GROUP BY [SubscriptionType]

----No. 3. Customers whoc cancelled their subscription within 6mnths----



SELECT CustomerID
FROM [dbo].[CUSTOMER DATA CLEANED DUPLICATED]
WHERE datediff(month, subscriptionstart, subscriptionend)<=6


-------No.4. Average subcription duration for all customers---

SELECT Avg(datediff(day,[SubscriptionStart],[SubscriptionEnd])) AS AVG_Duration
FROM [dbo].[CUSTOMER DATA CLEANED DUPLICATED]
WHERE [SubscriptionEnd] is not null


----No.5. Customers with subscription longer than 12months

SELECT [CustomerID]
FROM [dbo].[CUSTOMER DATA CLEANED DUPLICATED]
WHERE datediff(month,Subscriptionstart, Subscriptionend)>12 


-----NO.6. Total Revenue by subscription type

SELECT [SubscriptionType],
SUM (Revenue) AS Total_Revenue
FROM [dbo].[CUSTOMER DATA CLEANED DUPLICATED]
GROUP BY [SubscriptionType]


---NO. 7. Top 3 Regions by subscription cancellation

SELECT Region,
COUNT(*) AS [Canceled]
FROM [dbo].[CUSTOMER DATA CLEANED DUPLICATED]
WHERE Subscriptionend is not null
GROUP BY [Region]
ORDER BY [Canceled] DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY



----NO.8. Total number of active and cancelled subscription 

SELECT 
    COUNT(CASE WHEN [SubscriptionEnd] IS NULL THEN 1 END) AS Active,
    COUNT(CASE WHEN [SubscriptionEnd] IS NOT NULL THEN 1 END) AS Canceled
FROM 
 [dbo].[CUSTOMER DATA CLEANED DUPLICATED];


