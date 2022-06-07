-- Analysis of sales performance by Promotion. 

-- Internet promotions
SELECT 
    p.EnglishPromotionCategory AS EnglishPromotionCategory,
    ProductKey, 
    p.EnglishPromotionName, 
    p.EnglishPromotionType,
    FORMAT(SUM(SalesAmount), 'C2') AS PromoSalesRevenue

FROM dbo.FactInternetSales AS isales
INNER JOIN dbo.DimPromotion AS p
    ON p.PromotionKey = isales.PromotionKey
    WHERE isales.PromotionKey!= 1

GROUP BY ProductKey, p.EnglishPromotionName, p.EnglishPromotionCategory, p.EnglishPromotionType
ORDER BY SUM(SalesAmount) DESC;

-- Reseller promotions
SELECT 
    p.EnglishPromotionCategory AS EnglishPromotionCategory,
    ProductKey, 
    p.EnglishPromotionName, 
    p.EnglishPromotionType,
    FORMAT(SUM(SalesAmount), 'C2') AS PromoSalesRevenue

FROM dbo.FactResellerSales AS rsales
INNER JOIN dbo.DimPromotion AS p
    ON p.PromotionKey = rsales.PromotionKey
    WHERE rsales.PromotionKey!= 1

GROUP BY ProductKey, p.EnglishPromotionName, p.EnglishPromotionCategory, p.EnglishPromotionType
ORDER BY SUM(SalesAmount) DESC;


-- Results for Reseller Sales by Promotion Hierarchy (Category, Type and Name).
SELECT 	p.EnglishPromotionCategory, 
        p.EnglishPromotionType, 
        p.EnglishPromotionName,
		FORMAT(SUM(rsales.UnitPrice * rsales.OrderQuantity), 'C2') AS Sales, 
		FORMAT(SUM(DiscountPct * rsales.UnitPrice * rsales.OrderQuantity), 'C2') AS Discount, 
		FORMAT(SUM(rsales.UnitPrice * rsales.OrderQuantity) - SUM(rsales.TotalProductCost), 'C2') AS 'Profit', 
		FORMAT(SUM((rsales.UnitPrice * rsales.OrderQuantity)/100), 'C2') AS 'Promotion %',
		RANK() OVER(ORDER BY SUM(rsales.UnitPrice * rsales.OrderQuantity) DESC) AS 'Rank'

FROM dbo.FactResellerSales AS rsales
INNER JOIN dbo.DimProduct dp 
    ON dp.ProductKey = rsales.ProductKey
INNER JOIN dbo.DimPromotion AS p
    ON p.PromotionKey = rsales.PromotionKey

GROUP BY p.EnglishPromotionCategory, p.EnglishPromotionType, p.EnglishPromotionName;


-- Results for Internet Sales by Promotion Hierarchy (Category, Type and Name).
SELECT 	p.EnglishPromotionCategory, 
        p.EnglishPromotionType, 
        p.EnglishPromotionName,
		FORMAT(SUM(isales.UnitPrice * isales.OrderQuantity), 'C2') AS Sales, 
		FORMAT(SUM(DiscountPct * isales.UnitPrice * isales.OrderQuantity), 'C2') AS Discount, 
		FORMAT(SUM(isales.UnitPrice * isales.OrderQuantity) - SUM(isales.TotalProductCost), 'C2') AS 'Profit', 
		FORMAT(SUM((isales.UnitPrice * isales.OrderQuantity)/100), 'C2') AS 'Promotion %',
		RANK() OVER(ORDER BY SUM(isales.UnitPrice * isales.OrderQuantity) DESC) AS 'Rank'

FROM dbo.FactInternetSales AS isales
INNER JOIN dbo.DimProduct dp 
    ON dp.ProductKey = isales.ProductKey
INNER JOIN dbo.DimPromotion AS p
    ON p.PromotionKey = isales.PromotionKey
    
GROUP BY p.EnglishPromotionCategory, p.EnglishPromotionType, p.EnglishPromotionName;


-- Geographic Contribution to Reseller Sales under promotions by Rank. 
SELECT 
    st.SalesTerritoryCountry AS Country, 
    st.SalesTerritoryGroup AS TerritoryGroup, 
    st.SalesTerritoryRegion AS Region,
    FORMAT(SUM(rsales.SalesAmount), 'C2') AS SalesAmount,
    FORMAT(SUM(rsales.UnitPrice * rsales.OrderQuantity), 'C2') Sales, 
	FORMAT(SUM(DiscountPct * rsales.UnitPrice * rsales.OrderQuantity), 'C2') AS Discount, 
	FORMAT(SUM(rsales.UnitPrice * rsales.OrderQuantity) - SUM(rsales.TotalProductCost), 'C2') AS 'Profit', 
	FORMAT(SUM((rsales.UnitPrice * rsales.OrderQuantity)/100), 'C2') AS 'Promotion %',
	RANK() OVER(ORDER BY SUM(rsales.UnitPrice * rsales.OrderQuantity) DESC) AS 'Rank'

FROM dbo.FactResellerSales AS rsales
INNER JOIN DimSalesTerritory AS st 
    ON st.SalesTerritoryKey = rsales.SalesTerritoryKey
INNER JOIN dbo.DimProduct AS dp 
    ON dp.ProductKey = rsales.ProductKey
INNER JOIN dbo.DimPromotion AS p
    ON p.PromotionKey = rsales.PromotionKey

GROUP BY st.SalesTerritoryCountry, st.SalesTerritoryGroup, st.SalesTerritoryRegion;


-- Geographic Contribution to Internet Sales under promotions by Rank. 
SELECT 
    st.SalesTerritoryCountry AS Country, 
    st.SalesTerritoryGroup AS TerritoryGroup, 
    st.SalesTerritoryRegion AS Region,
    FORMAT(SUM(isales.SalesAmount), 'C2') AS SalesAmount,
    FORMAT(SUM(isales.UnitPrice * isales.OrderQuantity), 'C2') AS Sales,
	FORMAT(SUM(DiscountPct * isales.UnitPrice * isales.OrderQuantity), 'C2') AS Discount,
	FORMAT(SUM(isales.UnitPrice * isales.OrderQuantity) - SUM(isales.TotalProductCost), 'C2') AS 'Profit',
	FORMAT(SUM((isales.UnitPrice * isales.OrderQuantity)/100), 'C2') AS 'Promotion %',
	RANK() OVER(ORDER BY SUM(isales.UnitPrice * isales.OrderQuantity) DESC) AS 'Rank'

FROM dbo.FactInternetSales AS isales
INNER JOIN DimSalesTerritory AS st 
    ON st.SalesTerritoryKey = isales.SalesTerritoryKey
INNER JOIN dbo.DimProduct AS dp 
    ON dp.ProductKey = isales.ProductKey
INNER JOIN dbo.DimPromotion AS p
    ON p.PromotionKey = isales.PromotionKey

GROUP BY st.SalesTerritoryCountry, st.SalesTerritoryGroup, st.SalesTerritoryRegion;


-- Overview of Sales Trends (by Month) under promotions for Resellers. 
SELECT 
    DATENAME(mm, rsales.OrderDate) AS OrderMonthName, 
    FORMAT(SUM(rsales.salesamount), 'C2') AS SalesAmount 

FROM FactResellerSales AS rsales
INNER JOIN dbo.DimPromotion AS p
    ON p.PromotionKey = rsales.PromotionKey

 
 GROUP BY DATENAME(mm, rsales.OrderDate)
 ORDER BY SUM(rsales.SalesAmount) DESC;


 -- Overview of Sales Trends (by Month) under promotions for Internet Sales. 
SELECT 
    DATENAME(mm, isales.OrderDate) AS OrderMonthName, 
    FORMAT(SUM(isales.salesamount), 'C2') AS SalesAmount 

FROM FactInternetSales AS isales
INNER JOIN dbo.DimPromotion AS p
    ON p.PromotionKey = isales.PromotionKey

 
 GROUP BY DATENAME(mm, isales.OrderDate)
 ORDER BY SUM(isales.SalesAmount) DESC;


-- Key points:
-- There are 32 total Internet Sales promotions.
-- There are 254 total Reseller Sales promotions.
-- Promotional Sales Revenue for Reseller that generated > $100,000 are associated with the Product Category Bikes. 
-- Promotional Sales Revenue for Internet Sales that generated > $100,000 are also associated with Bikes. 
-- The largest Reseller promotion, which generated over a million dollars, is associated with volume discounts, ranked 2nd and 3rd by promotion hierarchy (Category, Type and Name).
-- The largest Internet promotion, which generated over a million dollars, is also assoictaed with volume discounts.
-- The top 10 countries ranked by geographic contribution to Reseller sales under promotions generated over a million in ascending order (US, Canada, France, UK Germany Australia). 
-- The top 7 countries ranked by geographic contribution to Interenet sales under promotions genereted over a million in ascending order (US, UK, Germany, France, Canada).
-- Overall, the highest sales under promotions were generated by Resellers in the month of May & January, with over 9 million in revenue.
-- While for Internet, over 3 million in sales were generated in December.