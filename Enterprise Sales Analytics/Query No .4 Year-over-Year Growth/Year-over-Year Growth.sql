USE EnterpriseSalesDB
GO

--YOY Growth
SELECT 
    YEAR(s.SaleDate) AS SalesYear,
    CAST(SUM((p.SellingPrice * s.Quantity) * 
         (1 - ISNULL(s.DiscountPercent,0)/100.0)) AS DECIMAL(18,2)) AS TotalSales
INTO #YearlySales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY YEAR(s.SaleDate);

SELECT 
    y1.SalesYear,
    y1.TotalSales,
    CAST((
        (y1.TotalSales - y2.TotalSales) / NULLIF(y2.TotalSales,0) * 100
    ) AS DECIMAL(5,2)) AS YoYGrowthPercent

FROM #YearlySales y1
LEFT JOIN #YearlySales y2 
    ON y1.SalesYear = y2.SalesYear + 1
ORDER BY y1.SalesYear;

DROP TABLE #YearlySales;








