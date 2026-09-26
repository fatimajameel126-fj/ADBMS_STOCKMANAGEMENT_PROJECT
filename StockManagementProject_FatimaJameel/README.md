# Stock Management System – ADBMS Project

A complete ASP.NET Core MVC stock/inventory management project adapted from the same general structure and visual style as the supplied HiSUP project.

## Technology
- ASP.NET Core MVC / .NET 8
- C#
- Entity Framework Core 8
- Microsoft SQL Server / SQL Server Express
- Bootstrap 5 + Bootstrap Icons
- Cookie Authentication

## Modules
- Login / Registration
- Admin Dashboard
- Products and inventory
- Categories
- Suppliers
- Customers
- Purchases / stock-in
- Sales / stock-out
- Stock, sales and purchase reports
- User management
- Audit logs

## ADBMS features
The `database/StockManagementDB.sql` file demonstrates:
- Primary and foreign keys
- Unique constraints
- Indexes
- Views
- Stored procedures
- User-defined functions
- Triggers
- Transactions
- Decimal precision
- Referential integrity

## Run the project
1. Install .NET 8 SDK and SQL Server Express.
2. Open `src/StockManagement/StockManagement.csproj` in Visual Studio 2022 or Rider.
3. Check the connection string in `src/StockManagement/appsettings.json`.
4. Run the application. The app automatically creates the EF Core database and inserts demo data on first run.
5. Alternatively, execute `database/StockManagementDB.sql` in SQL Server Management Studio for the full database/ADBMS script.

## Demo accounts
- Admin: `admin@stock.local` / `Admin@12345`
- Manager: `manager@stock.local` / `Manager@12345`
- Staff: `staff@stock.local` / `Staff@12345`

## Important
If you execute the SQL script manually, make sure the database name and connection string match. If the application is allowed to create the database itself, the initial demo data is seeded automatically.


### Purchase/Sales trigger fix
EF Core is configured for the SQL Server triggers on `PurchaseDetails` and `SaleDetails`, preventing the SQL Server `OUTPUT`-clause error when saving purchases or sales. Stock transaction rows are created by the database triggers, so the controllers no longer insert duplicate stock-transaction rows.
