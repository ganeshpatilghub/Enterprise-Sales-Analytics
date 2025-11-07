CREATE DATABASE EnterpriseSalesDB;
GO
USE EnterpriseSalesDB;
GO

-->>Table Creattion Regions
CREATE TABLE Regions (
    RegionID INT IDENTITY(1,1) PRIMARY KEY,
    RegionName NVARCHAR(100) NOT NULL UNIQUE,
    CreatedDate DATETIME DEFAULT GETDATE()
);

INSERT INTO Regions (RegionName)
VALUES 
('North'),
('South'),
('East'),
('West'),
('Central');
GO

SELECT * FROM Regions;

GO

-->>Table Creation Customers
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(150) NOT NULL,
    Email NVARCHAR(150) UNIQUE,
    PhoneNumber NVARCHAR(15),
    RegionID INT NOT NULL,
    JoinDate DATE DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    CONSTRAINT FK_Customers_Regions FOREIGN KEY (RegionID)
        REFERENCES Regions(RegionID)
);

INSERT INTO Customers (CustomerName, Email, PhoneNumber, RegionID, JoinDate)
VALUES
('Rahul Patil', 'rahul.patil@example.com', '9876543210', 1, '2021-04-10'),
('Sneha Joshi', 'sneha.joshi@example.com', '9865412300', 2, '2022-01-05'),
('Vikas Deshmukh', 'vikas.deshmukh@example.com', '9851237890', 3, '2020-11-20'),
('Aarti Kulkarni', 'aarti.kulkarni@example.com', '9823456789', 4, '2023-03-15'),
('Prasad Shinde', 'prasad.shinde@example.com', '9812314567', 5, '2022-09-09');
GO

SELECT * FROM Customers;

GO

-->>Table Creation Products
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(150) NOT NULL,
    Category NVARCHAR(100),
    CostPrice DECIMAL(10,2) NOT NULL,
    SellingPrice DECIMAL(10,2) NOT NULL,
    LaunchDate DATE DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    CONSTRAINT CK_Product_Price CHECK (SellingPrice >= CostPrice)
);

INSERT INTO Products (ProductName, Category, CostPrice, SellingPrice, LaunchDate)
VALUES
('Laptop Model X', 'Electronics', 40000, 55000, '2022-02-10'),
('Wireless Mouse', 'Electronics', 500, 800, '2023-01-15'),
('Office Chair', 'Furniture', 3000, 4500, '2021-08-20'),
('T-Shirt Cotton', 'Clothing', 300, 700, '2022-10-05'),
('Smartwatch Pro', 'Electronics', 7000, 10500, '2023-04-01'),
('Sofa Set', 'Furniture', 10000, 14500, '2021-11-25');
GO
SELECT * FROM Products;

GO

-->>Table Creation Products
CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    SaleDate DATE DEFAULT GETDATE(),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    DiscountPercent DECIMAL(5,2) DEFAULT 0,
    CONSTRAINT FK_Sales_Customers FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Sales_Products FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);

INSERT INTO Sales (CustomerID, ProductID, SaleDate, Quantity, DiscountPercent)
VALUES
(1, 1, '2023-05-05', 2, 5.00),
(2, 3, '2023-06-10', 1, 0.00),
(3, 5, '2023-07-12', 3, 10.00),
(4, 2, '2023-08-01', 5, 0.00),
(5, 6, '2023-09-03', 1, 15.00),
(1, 4, '2023-10-09', 4, 0.00);
GO

SELECT * FROM Sales;

GO

-->>Table Creation Sales_Audit (for triggers)
CREATE TABLE Sales_Audit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    SaleID INT,
    ActionType NVARCHAR(50),
    OldAmount DECIMAL(12,2),
    NewAmount DECIMAL(12,2),
    ChangeDate DATETIME DEFAULT GETDATE()
);


GO

--Create Indexes for faster analytics
CREATE NONCLUSTERED INDEX IX_Sales_Date ON Sales(SaleDate);
CREATE NONCLUSTERED INDEX IX_Customers_Region ON Customers(RegionID);
CREATE NONCLUSTERED INDEX IX_Products_Category ON Products(Category);
GO

--Verify
SELECT 
    t.name AS TableName, 
    c.name AS ColumnName, 
    ty.name AS DataType, 
    c.max_length
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
JOIN sys.types ty ON c.user_type_id = ty.user_type_id
ORDER BY t.name;