USE EnterpriseSalesDB
GO

--Dynamic Pivot for Category-wise Profit per Region
SELECT * 
FROM 
(
SELECT 
R.RegionName , P.Category ,(p.SellingPrice - p.CostPrice) * s.Quantity AS Profit
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
JOIN Regions R ON C.RegionID = R.RegionID
JOIN Products P ON S.ProductID = P.ProductID
) AS Sourcetable
PIVOT
(
    SUM(Profit)
    FOR RegionName IN ([North], [South], [East], [West], [Central])
) AS PivotTable;

   