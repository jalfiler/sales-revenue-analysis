-- Customer demographics to consider for analysis: 
-- Age, Gender, Education, Geographics, Household Income and Income Level.

-- Customer Age Group.
SELECT 
    c.CustomerKey, 
    CAST(DATEDIFF(DD,c.BirthDate, GETDATE())/365.25 - 12 AS INT) AS Age,
(CASE 
    WHEN CAST((DATEDIFF(DD,c.BirthDate, GETDATE()) / 365.25) - 12 AS INT) > 29 
    AND CAST((DATEDIFF(DD,c.BirthDate, GETDATE()) / 365.25) - 12 AS INT) < 40 THEN 'Thirties'
    WHEN CAST((DATEDIFF(DD,c.BirthDate, GETDATE()) / 365.25) - 12 AS INT) >= 40 
    AND CAST((DATEDIFF(DD,c.BirthDate, GETDATE()) / 365.25) - 12 AS INT) < 50 THEN 'Fourties'
    WHEN CAST((DATEDIFF(DD,c.BirthDate, GETDATE()) / 365.25) - 12 AS INT) >= 50 
    AND CAST((DATEDIFF(DD,c.BirthDate, GETDATE()) / 365.25) - 12 AS INT) < 60 THEN 'Fifties'
    WHEN CAST((DATEDIFF(DD,c.BirthDate, GETDATE()) / 365.25) - 12 AS INT) >= 60 THEN 'Senior'
    ELSE 'Twenties' 
END) AS AgeGroup

FROM dbo.DimCustomer AS c
ORDER BY AgeGroup;


-- Customer demographics on Education, Marital Status and Income by Gender.
SELECT 
    c.EnglishEducation AS EnglishEducationLevel, 
    c.MaritalStatus,
    c.Gender,
	FORMAT(AVG(c.YearlyIncome), 'C2') AS AvgIncome, 
	COUNT(DISTINCT isales.CustomerKey) AS NumOfCustomers,
	COUNT(isales.SalesOrderNumber) AS NumOfOrders,
	AVG(CAST(c.NumberCarsOwned AS decimal(10,2))) AS AvgCarsPerCustomer,
	AVG(CAST(c.TotalChildren AS decimal(10,2))) AS AvgChildrenPerCustomer,
	COUNT(isales.SalesOrderNumber) / COUNT(DISTINCT isales.CustomerKey) AS OrdersPerCustomer,
	FORMAT(SUM(isales.SalesAmount) / COUNT(DISTINCT isales.CustomerKey), 'C2') AS AvgRevenuePerCustomer

FROM dbo.FactInternetSales AS isales
INNER JOIN dbo.DimCustomer AS c
    ON isales.CustomerKey = c.CustomerKey

GROUP BY c.EnglishEducation, c.MaritalStatus, c.Gender
ORDER BY EnglishEducationLevel, NumOfCustomers DESC;


-- Customer Group Income Level. 
SELECT 
    FORMAT(c.YearlyIncome, 'C2') AS AnnualIncome,
    (CASE 
		WHEN c.YearlyIncome < 40000 THEN 'Low'
		WHEN c.YearlyIncome > 60000 THEN 'High'
		ELSE 'Moderate' 
    END) AS IncomeGroup

FROM dbo.DimCustomer AS c
ORDER By YearlyIncome DESC;


-- Customer Geographics based on Average income, Number of customers, Orders and Revenue per customer. 
SELECT g.StateProvinceName, 
       g.EnglishCountryRegionName,
	  FORMAT(AVG(c.YearlyIncome), 'C2') AS AvgIncome,
	  COUNT(DISTINCT isales.CustomerKey) AS NumOfCustomers,
	  COUNT(isales.SalesOrderNumber) AS NumberOfOrders,
	  FORMAT(SUM(isales.SalesAmount) / COUNT(DISTINCT isales.CustomerKey), 'C2') AS AvgRevenuePerCustomer

FROM dbo.FactInternetSales AS isales
INNER JOIN dbo.DimCustomer AS c
	ON isales.CustomerKey = c.CustomerKey
INNER JOIN dbo.DimGeography AS g
	ON g.GeographyKey = c.GeographyKey

GROUP BY g.StateProvinceName, 
         g.EnglishCountryRegionName

ORDER BY NumOfCustomers DESC, 
         NumberOfOrders DESC, 
		 AvgRevenuePerCustomer DESC;


-- Count of Customer Orders by Product Category ranked by sales.
SELECT 	DISTINCT pc.EnglishProductCategoryName,
        g.StateProvinceName, 
        g.EnglishCountryRegionName,
        COUNT(DISTINCT isales.CustomerKey) AS NumOfCustomers,
	    COUNT(isales.SalesOrderNumber) AS NumberOfOrders,
		FORMAT(SUM(isales.UnitPrice * isales.OrderQuantity), 'C2') AS Sales, 
		FORMAT(SUM(isales.ProductStandardCost), 'C2') AS ProductCosts, 
		FORMAT(SUM(isales.UnitPrice * isales.OrderQuantity) - SUM(isales.ProductStandardCost), 'C2') AS Profit, 
		RANK() OVER(ORDER BY SUM(isales.UnitPrice * isales.OrderQuantity) DESC) AS Rank

From dbo.FactInternetSales AS isales
 INNER JOIN dbo.DimProduct AS p 
    ON p.ProductKey = isales.ProductKey
 INNER JOIN DimProductSubCategory AS psc
    ON psc.ProductSubcategoryKey = p.ProductSubcategoryKey
 INNER JOIN DimProductCategory AS pc 
    ON psc.ProductCategoryKey = pc.ProductCategoryKey
 INNER JOIN dbo.DimCustomer AS c 
    ON isales.CustomerKey = c.CustomerKey
 INNER JOIN DimGeography AS g 
    ON g.GeographyKey = c.GeographyKey

GROUP BY pc.EnglishProductCategoryName, 
         g.StateProvinceName, 
         g.EnglishCountryRegionName

ORDER BY Rank;



-- Key points:
-- Customers who account for > 5000 orders lives in one of the top 5 State Province (CA, WA, England, British Columbia, Wales).
-- The AvgIncome of Customers in the top 5 State Province seems to be in the Moderate to High Income Group. 
-- A large number of our customers hold a Bachelor's degree, primarily male (3,748) then female (2,628).
-- Top 5 ranked Product Category by Sales is Bikes showing US, AUS and UK as the top consumer by region.