CREATE DATABASE StockManagementDB;
GO
USE StockManagementDB;
GO
CREATE TABLE Categories(Id INT IDENTITY PRIMARY KEY,Name NVARCHAR(80) NOT NULL UNIQUE,Description NVARCHAR(200) NULL);
CREATE TABLE Products(Id INT IDENTITY PRIMARY KEY,SKU NVARCHAR(30) NOT NULL UNIQUE,Name NVARCHAR(120) NOT NULL,CategoryId INT NOT NULL,Unit NVARCHAR(30) NOT NULL,UnitPrice DECIMAL(18,2) NOT NULL,ReorderLevel INT NOT NULL DEFAULT 0,CurrentStock INT NOT NULL DEFAULT 0,Status NVARCHAR(30) NOT NULL DEFAULT 'Active',CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),CONSTRAINT FK_Products_Categories FOREIGN KEY(CategoryId) REFERENCES Categories(Id));
CREATE TABLE Suppliers(Id INT IDENTITY PRIMARY KEY,Name NVARCHAR(120) NOT NULL,Email NVARCHAR(150),Phone NVARCHAR(30),Address NVARCHAR(250),IsActive BIT NOT NULL DEFAULT 1);
CREATE TABLE Customers(Id INT IDENTITY PRIMARY KEY,Name NVARCHAR(120) NOT NULL,Email NVARCHAR(150),Phone NVARCHAR(30));
CREATE TABLE AppUsers(Id INT IDENTITY PRIMARY KEY,FullName NVARCHAR(100) NOT NULL,Email NVARCHAR(150) NOT NULL UNIQUE,PasswordHash NVARCHAR(500) NOT NULL,Role NVARCHAR(30) NOT NULL,IsActive BIT NOT NULL DEFAULT 1);
CREATE TABLE Purchases(Id INT IDENTITY PRIMARY KEY,SupplierId INT NOT NULL,PurchaseDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,Status NVARCHAR(30) NOT NULL DEFAULT 'Completed',InvoiceNo NVARCHAR(60) NOT NULL UNIQUE,FOREIGN KEY(SupplierId) REFERENCES Suppliers(Id));
CREATE TABLE PurchaseDetails(Id INT IDENTITY PRIMARY KEY,PurchaseId INT NOT NULL,ProductId INT NOT NULL,Quantity INT NOT NULL,UnitCost DECIMAL(18,2) NOT NULL,FOREIGN KEY(PurchaseId) REFERENCES Purchases(Id) ON DELETE CASCADE,FOREIGN KEY(ProductId) REFERENCES Products(Id));
CREATE TABLE Sales(Id INT IDENTITY PRIMARY KEY,CustomerId INT NULL,SaleDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,Status NVARCHAR(30) NOT NULL DEFAULT 'Completed',InvoiceNo NVARCHAR(60) NOT NULL UNIQUE,FOREIGN KEY(CustomerId) REFERENCES Customers(Id));
CREATE TABLE SaleDetails(Id INT IDENTITY PRIMARY KEY,SaleId INT NOT NULL,ProductId INT NOT NULL,Quantity INT NOT NULL,UnitPrice DECIMAL(18,2) NOT NULL,FOREIGN KEY(SaleId) REFERENCES Sales(Id) ON DELETE CASCADE,FOREIGN KEY(ProductId) REFERENCES Products(Id));
CREATE TABLE StockTransactions(Id INT IDENTITY PRIMARY KEY,ProductId INT NOT NULL,TransactionType NVARCHAR(10) NOT NULL,Quantity INT NOT NULL,UnitCost DECIMAL(18,2) NOT NULL,TransactionDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),ReferenceNo NVARCHAR(60),FOREIGN KEY(ProductId) REFERENCES Products(Id));
CREATE TABLE AuditLogs(Id INT IDENTITY PRIMARY KEY,EntityName NVARCHAR(100) NOT NULL,ActionType NVARCHAR(50) NOT NULL,Description NVARCHAR(500) NOT NULL,ChangedBy NVARCHAR(100) NOT NULL,ChangedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME());
GO
CREATE INDEX IX_Products_CategoryId ON Products(CategoryId);
CREATE INDEX IX_Products_Name ON Products(Name);
CREATE INDEX IX_Sales_SaleDate ON Sales(SaleDate);
CREATE INDEX IX_Purchases_PurchaseDate ON Purchases(PurchaseDate);
CREATE INDEX IX_StockTransactions_ProductDate ON StockTransactions(ProductId,TransactionDate);
GO
CREATE VIEW vw_CurrentStock AS SELECT p.Id,p.SKU,p.Name,c.Name AS Category,p.CurrentStock,p.ReorderLevel,p.UnitPrice,p.CurrentStock*p.UnitPrice AS StockValue,CASE WHEN p.CurrentStock<=p.ReorderLevel THEN 'LOW' ELSE 'OK' END AS StockStatus FROM Products p INNER JOIN Categories c ON c.Id=p.CategoryId;
GO
CREATE VIEW vw_SalesSummary AS SELECT s.Id,s.InvoiceNo,s.SaleDate,c.Name AS Customer,s.TotalAmount,s.Status FROM Sales s LEFT JOIN Customers c ON c.Id=s.CustomerId;
GO
CREATE VIEW vw_PurchaseSummary AS SELECT p.Id,p.InvoiceNo,p.PurchaseDate,s.Name AS Supplier,p.TotalAmount,p.Status FROM Purchases p INNER JOIN Suppliers s ON s.Id=p.SupplierId;
GO
CREATE FUNCTION fn_ProductStockValue(@ProductId INT) RETURNS DECIMAL(18,2) AS BEGIN DECLARE @v DECIMAL(18,2);SELECT @v=CurrentStock*UnitPrice FROM Products WHERE Id=@ProductId;RETURN ISNULL(@v,0);END;
GO
CREATE FUNCTION fn_LowStockProducts() RETURNS TABLE AS RETURN(SELECT Id,SKU,Name,CurrentStock,ReorderLevel FROM Products WHERE CurrentStock<=ReorderLevel);
GO
CREATE PROCEDURE sp_GetLowStockProducts AS SELECT * FROM vw_CurrentStock WHERE StockStatus='LOW' ORDER BY CurrentStock; 
GO
CREATE PROCEDURE sp_GetSalesByDate @FromDate DATE,@ToDate DATE AS SELECT * FROM vw_SalesSummary WHERE CAST(SaleDate AS DATE) BETWEEN @FromDate AND @ToDate ORDER BY SaleDate DESC;
GO
CREATE PROCEDURE sp_RecordStockTransaction @ProductId INT,@TransactionType NVARCHAR(10),@Quantity INT,@UnitCost DECIMAL(18,2),@ReferenceNo NVARCHAR(60) AS BEGIN SET NOCOUNT ON; BEGIN TRAN; INSERT INTO StockTransactions(ProductId,TransactionType,Quantity,UnitCost,ReferenceNo) VALUES(@ProductId,@TransactionType,@Quantity,@UnitCost,@ReferenceNo); UPDATE Products SET CurrentStock=CurrentStock+CASE WHEN @TransactionType='IN' THEN @Quantity ELSE -@Quantity END WHERE Id=@ProductId; COMMIT; END;
GO
CREATE TRIGGER trg_PurchaseDetail_Audit ON PurchaseDetails AFTER INSERT AS BEGIN SET NOCOUNT ON; INSERT INTO StockTransactions(ProductId,TransactionType,Quantity,UnitCost,ReferenceNo) SELECT ProductId,'IN',Quantity,UnitCost,CONVERT(NVARCHAR(60),PurchaseId) FROM inserted; END;
GO
CREATE TRIGGER trg_SaleDetail_Audit ON SaleDetails AFTER INSERT AS BEGIN SET NOCOUNT ON; INSERT INTO StockTransactions(ProductId,TransactionType,Quantity,UnitCost,ReferenceNo) SELECT ProductId,'OUT',Quantity,UnitPrice,CONVERT(NVARCHAR(60),SaleId) FROM inserted; END;
GO
