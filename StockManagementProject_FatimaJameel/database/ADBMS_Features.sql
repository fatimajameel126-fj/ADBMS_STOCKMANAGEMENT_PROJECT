USE StockManagementDB;
GO
IF OBJECT_ID('vw_CurrentStock','V') IS NULL EXEC('CREATE VIEW vw_CurrentStock AS SELECT p.Id,p.SKU,p.Name,c.Name AS Category,p.CurrentStock,p.ReorderLevel,p.UnitPrice,p.CurrentStock*p.UnitPrice AS StockValue,CASE WHEN p.CurrentStock<=p.ReorderLevel THEN ''LOW'' ELSE ''OK'' END AS StockStatus FROM Products p INNER JOIN Categories c ON c.Id=p.CategoryId');
GO
IF OBJECT_ID('vw_SalesSummary','V') IS NULL EXEC('CREATE VIEW vw_SalesSummary AS SELECT s.Id,s.InvoiceNo,s.SaleDate,c.Name AS Customer,s.TotalAmount,s.Status FROM Sales s LEFT JOIN Customers c ON c.Id=s.CustomerId');
GO
IF OBJECT_ID('vw_PurchaseSummary','V') IS NULL EXEC('CREATE VIEW vw_PurchaseSummary AS SELECT p.Id,p.InvoiceNo,p.PurchaseDate,s.Name AS Supplier,p.TotalAmount,p.Status FROM Purchases p INNER JOIN Suppliers s ON s.Id=p.SupplierId');
GO
CREATE OR ALTER FUNCTION fn_ProductStockValue(@ProductId INT) RETURNS DECIMAL(18,2) AS BEGIN DECLARE @v DECIMAL(18,2);SELECT @v=CurrentStock*UnitPrice FROM Products WHERE Id=@ProductId;RETURN ISNULL(@v,0);END;
GO
CREATE OR ALTER FUNCTION fn_LowStockProducts() RETURNS TABLE AS RETURN(SELECT Id,SKU,Name,CurrentStock,ReorderLevel FROM Products WHERE CurrentStock<=ReorderLevel);
GO
CREATE OR ALTER PROCEDURE sp_GetLowStockProducts AS SELECT * FROM vw_CurrentStock WHERE StockStatus='LOW' ORDER BY CurrentStock;
GO
CREATE OR ALTER PROCEDURE sp_GetSalesByDate @FromDate DATE,@ToDate DATE AS SELECT * FROM vw_SalesSummary WHERE CAST(SaleDate AS DATE) BETWEEN @FromDate AND @ToDate ORDER BY SaleDate DESC;
GO
CREATE OR ALTER PROCEDURE sp_RecordStockTransaction @ProductId INT,@TransactionType NVARCHAR(10),@Quantity INT,@UnitCost DECIMAL(18,2),@ReferenceNo NVARCHAR(60) AS BEGIN SET NOCOUNT ON; BEGIN TRAN; INSERT INTO StockTransactions(ProductId,TransactionType,Quantity,UnitCost,ReferenceNo) VALUES(@ProductId,@TransactionType,@Quantity,@UnitCost,@ReferenceNo); UPDATE Products SET CurrentStock=CurrentStock+CASE WHEN @TransactionType='IN' THEN @Quantity ELSE -@Quantity END WHERE Id=@ProductId; COMMIT; END;
GO
CREATE OR ALTER TRIGGER trg_PurchaseDetail_Audit ON PurchaseDetails AFTER INSERT AS BEGIN SET NOCOUNT ON; INSERT INTO StockTransactions(ProductId,TransactionType,Quantity,UnitCost,ReferenceNo) SELECT ProductId,'IN',Quantity,UnitCost,CONVERT(NVARCHAR(60),PurchaseId) FROM inserted; END;
GO
CREATE OR ALTER TRIGGER trg_SaleDetail_Audit ON SaleDetails AFTER INSERT AS BEGIN SET NOCOUNT ON; INSERT INTO StockTransactions(ProductId,TransactionType,Quantity,UnitCost,ReferenceNo) SELECT ProductId,'OUT',Quantity,UnitPrice,CONVERT(NVARCHAR(60),SaleId) FROM inserted; END;
GO
