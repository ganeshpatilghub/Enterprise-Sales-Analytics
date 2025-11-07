USE EnterpriseSalesDB
GO

--Top 3 Products by Profit
SELECT TOP 3
    p.ProductID,
    p.ProductName,
    CAST((
        SUM(((p.SellingPrice - p.CostPrice) * s.Quantity) * (1 - ISNULL(s.DiscountPercent, 0)/100.0))
    ) AS DECIMAL(18,2)) AS TotalProfit
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalProfit DESC;
