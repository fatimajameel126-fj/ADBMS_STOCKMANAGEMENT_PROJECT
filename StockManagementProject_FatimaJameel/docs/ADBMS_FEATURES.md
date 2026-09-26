# ADBMS Implementation Notes

## 1. Normalized relational design
Products, Categories, Suppliers, Customers, Purchases, PurchaseDetails, Sales, SaleDetails and StockTransactions are separated into related tables. Repeating groups are avoided and transaction details use foreign keys.

## 2. Referential integrity
Foreign keys connect transaction details to their parent transactions and products to categories. Restrict/cascade behavior is explicitly defined where appropriate.

## 3. Transactions
Sales and purchases are processed with an explicit database transaction. If a product is missing or stock is insufficient, the operation is rolled back.

## 4. Views
`vw_CurrentStock`, `vw_SalesSummary`, and `vw_PurchaseSummary` provide reusable query layers for reporting.

## 5. Stored procedures
`sp_GetLowStockProducts`, `sp_GetSalesByDate`, and `sp_RecordStockTransaction` demonstrate database-side programming.

## 6. Functions
`fn_ProductStockValue` is a scalar function and `fn_LowStockProducts` is a table-valued function.

## 7. Triggers
Purchase and sale detail triggers write stock movement records to `StockTransactions` for audit/history purposes.

## 8. Indexing
Indexes are provided for SKU, product category, dates and stock transaction lookups.
