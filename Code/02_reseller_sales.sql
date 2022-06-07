-- Similar analysis for Reseller sales with the following columns:
-- Category, Model, CalendarYear, FiscalYear, Month, OrderNumber, Quantity, Amount.
-- Where the RevenueGroup are categorized based on "Low", "Middle", "High" and "Very High".
-- As well as the RselerSize, "Small", "Mid", "Large" and "Very Large".

SELECT 
       pc.EnglishProductCategoryName AS ProductCategory, 
       p.ModelName,
       rsales.ResellerKey, 
	   st.SalesTerritoryRegion AS SalesRegion, 
	   d.CalendarYear, 
	   d.FiscalYear, 
	   d.EnglishMonthName AS SaleMonth,
       rsales.SalesOrderNumber, 
	   rsales.OrderQuantity, 
	   FORMAT(rsales.SalesAmount, 'C2') AS SalesAmount,

(CASE 
	WHEN r.AnnualRevenue = 30000 THEN 'Low'
	WHEN r.AnnualRevenue >= 80000 AND r.AnnualRevenue <= 100000 THEN 'Middle'
	WHEN r.AnnualRevenue = 150000 THEN 'High'
	ELSE 'Very High' 
END) AS RevenueGroup,

(CASE 
	WHEN r.NumberEmployees <= 25 THEN 'Small'
	WHEN r.NumberEmployees > 25 AND r.NumberEmployees <= 50 THEN 'Mid'
	WHEN r.NumberEmployees > 50 AND r.NumberEmployees <= 75 THEN 'Large'
	ELSE 'Very Large' 
END) AS ResellerSize

FROM dbo.FactResellerSales AS rsales
INNER JOIN dbo.DimProduct AS p
	ON p.ProductKey = rsales.ProductKey
LEFT OUTER JOIN dbo.DimProductSubcategory AS ps
	ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
LEFT OUTER JOIN dbo.DimProductCategory AS pc
	ON pc.ProductCategoryKey = ps.ProductCategoryKey
LEFT OUTER JOIN dbo.DimSalesTerritory AS st
	ON st.SalesTerritoryKey = rsales.SalesTerritoryKey
INNER JOIN dbo.DimDate AS d
	ON d.DateKey = rsales.OrderDateKey
INNER JOIN dbo.DimReseller AS r
	ON r.ResellerKey = rsales.ResellerKey

ORDER BY pc.EnglishProductCategoryName, 
         p.ModelName, 
		 d.FiscalYear DESC,
		 rsales.SalesOrderNumber;