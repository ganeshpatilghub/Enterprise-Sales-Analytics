use EnterpriseSalesDB
GO
--Total Sales and Profit per Region

SELECT 
    r.RegionName,
    CAST((SUM((p.SellingPrice * s.Quantity) * (1 - ISNULL(s.DiscountPercent, 0)/100.0)))
        AS DECIMAL(18,2)) AS TotalSalesAmount,
    CAST((SUM(((p.SellingPrice - p.CostPrice) * s.Quantity) * (1 - ISNULL(s.DiscountPercent, 0)/100.0)))
        AS DECIMAL(18,2)
    ) AS TotalProfit
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
JOIN Regions r ON c.RegionID = r.RegionID
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY r.RegionName
ORDER BY TotalProfit DESC;
