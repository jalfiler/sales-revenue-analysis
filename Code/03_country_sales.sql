-- Request to add United Kingdom as its own SalesTerritoryGroup using the following query.
-- UPDATE dbo.DimSalesTerritory
-- SET 
--    SalesTerritoryGroup = 'United Kingdom', 
--    SalesTerritoryCountry = 'United Kingdom',
--    SalesTerritoryRegion = 'United Kingdom'

-- WHERE SalesTerritoryKey = 10;


-- Show the overall total sales by year rolled up by the Territory group and country. 
SELECT st.SalesTerritoryGroup AS SalesTerritory, 
       st.SalesTerritoryCountry AS Country, 
	   d.FiscalYear, 
	   FORMAT(ROUND(SUM(isales.SalesAmount),0), 'C2') AS YearlyInternetSales, 
	   FORMAT(ROUND(SUM(rsales.SalesAmount),0), 'C2') AS YearlyResellerSales,
       FORMAT(ROUND((SUM(isales.SalesAmount) + SUM(rsales.SalesAmount)),0),'C2') AS TotalSales

FROM dbo.DimSalesTerritory AS st
INNER JOIN dbo.FactInternetSales AS isales
	ON isales.SalesTerritoryKey = st.SalesTerritoryKey
INNER JOIN dbo.FactResellerSales AS rsales
	ON rsales.SalesTerritoryKey = st.SalesTerritoryKey
INNER JOIN dbo.DimDate AS d
	ON d.DateKey = isales.OrderDateKey

GROUP BY st.SalesTerritoryGroup,
         st.SalesTerritoryCountry, 
		 d.FiscalYear

ORDER BY d.FiscalYear DESC, 
          TotalSales DESC;