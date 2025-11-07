IF OBJECT_ID('trg_Sales_Audit', 'TR') IS NOT NULL
    DROP TRIGGER trg_Sales_Audit;
GO

CREATE TRIGGER trg_Sales_Audit
ON Sales
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Handle INSERT (New Sale Added)
    INSERT INTO Sales_Audit (SaleID, ActionType, OldAmount, NewAmount)
    SELECT 
        i.SaleID,
        'INSERT',
        NULL,
        CAST((p.SellingPrice * i.Quantity) * (1 - ISNULL(i.DiscountPercent,0)/100.0) AS DECIMAL(12,2))
    FROM inserted i
    JOIN Products p ON i.ProductID = p.ProductID;

    -- Handle DELETE (Sale Removed)
    INSERT INTO Sales_Audit (SaleID, ActionType, OldAmount, NewAmount)
    SELECT 
        d.SaleID,
        'DELETE',
        CAST((p.SellingPrice * d.Quantity) * (1 - ISNULL(d.DiscountPercent,0)/100.0) AS DECIMAL(12,2)),
        NULL
    FROM deleted d
    JOIN Products p ON d.ProductID = p.ProductID;

    -- Handle UPDATE (Sale Modified)
    INSERT INTO Sales_Audit (SaleID, ActionType, OldAmount, NewAmount)
    SELECT 
        i.SaleID,
        'UPDATE',
        CAST((p.SellingPrice * d.Quantity) * (1 - ISNULL(d.DiscountPercent,0)/100.0) AS DECIMAL(12,2)),
        CAST((p.SellingPrice * i.Quantity) * (1 - ISNULL(i.DiscountPercent,0)/100.0) AS DECIMAL(12,2))
    FROM inserted i
    JOIN deleted d ON i.SaleID = d.SaleID
    JOIN Products p ON i.ProductID = p.ProductID;
END;
GO


---trigger testing

INSERT INTO Sales (CustomerID, ProductID, SaleDate, Quantity, DiscountPercent)
VALUES (1, 1, GETDATE(), 2, 10);


SELECT * FROM Sales_audit