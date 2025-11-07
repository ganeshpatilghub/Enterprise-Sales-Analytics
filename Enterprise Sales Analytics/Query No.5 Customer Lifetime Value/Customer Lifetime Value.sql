USE EnterpriseSalesDB
GO

--Customer Lifetime Value

SELECT 
    c.CustomerID,
    c.CustomerName,
    MIN(s.SaleDate) AS FirstPurchaseDate,
    MAX(s.SaleDate) AS LastPurchaseDate,
    CAST(SUM((p.SellingPrice * s.Quantity) * (1 - ISNULL(s.DiscountPercent,0)/100.0)) AS DECIMAL(18,2)) AS TotalSpent
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpent DESC;

