-- List of Internet Sales with the following columns:
-- Category, Model, CustomerKey, Region, IncomeGroup, CalendarYear, FiscalYear, Month, OrderNumber, Quantity, and Amount. 
-- Where the IncomeGroup are categorize based on "Low" being less than 40,000, "High" being greater than 60,000, and the rest will be "Moderate".

SELECT 
    pc.EnglishProductCategoryName AS ProductCategory,
    p.ModelName AS Model,
    c.CustomerKey AS CustomeyKey,
    st.SalesTerritoryRegion AS SalesRegion,
    d.CalendarYear AS CalendarYear,
    d.FiscalYear AS FiscalYear,
    d.EnglishMonthName AS SalesMonth,
    isales.SalesOrderNumber AS OrderNumber,
    isales.OrderQuantity AS OrderQuantity,
    FORMAT(isales.SalesAmount,'C2') AS SalesAmount,

    (CASE 
		WHEN c.YearlyIncome < 40000 THEN 'Low'
		WHEN c.YearlyIncome > 60000 THEN 'High'
		ELSE 'Moderate' 
    END) AS IncomeGroup

FROM FactInternetSales AS isales
INNER JOIN dbo.DimProduct AS p
    ON p.ProductKey = isales.ProductKey   
INNER JOIN dbo.DimProductSubCategory AS psc
    ON psc.ProductSubCategoryKey = p.ProductSubCategoryKey
INNER JOIN DimProductCategory AS pc
    ON psc.ProductCategoryKey = pc.ProductCategoryKey
INNER JOIN DimSalesTerritory AS st 
    ON isales.SalesTerritoryKey = st.SalesTerritoryKey
INNER JOIN dbo.DimDate AS d
    ON d.DateKey = isales.OrderDateKey
INNER JOIN dbo.DimCustomer AS c 
    ON c.CustomerKey = isales.CustomerKey

ORDER BY pc.EnglishProductCategoryName, 
         p.ModelName, 
		 d.FiscalYear DESC, 
		 isales.SalesOrderNumber;
