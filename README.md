--ADBMS Stock Management System

<p align="center">
  <strong>A complete full-stack inventory management web application built as an ADBMS project.</strong><br>
  ASP.NET Core MVC • C# • Entity Framework Core • SQL Server • Bootstrap
</p>

## About the Project
ADBMS Stock Management System is a full-stack web application developed to demonstrate how Advanced Database Management System concepts can be applied to a real-world inventory business workflow.

The system provides a centralized platform for managing:
1. Products and inventory
2. Categories
3. Suppliers
4. Customers
5. Purchases
6. Sales
7. Stock, sales and purchase reports
8. Users and authentication
9. Audit logs
10. Advanced SQL Server database features

The application follows the ASP.NET Core MVC architecture and uses Entity Framework Core to communicate with a Microsoft SQL Server database.

 ## Key Features

1. Authentication

Login, registration, logout and role-based authorization

2. Dashboard

Business overview with stock, sales, purchases and low-stock statistics

3. Product Management

Add, search, edit and delete products

4. Category Management

Manage product categories

5. Supplier Management

Manage supplier information

6. Customer Management

Manage customer information

7. Purchase Management

Record purchases and increase inventory

8. Sales Management

Record sales and decrease inventory

9. Reports

Stock, sales and purchase reporting

10. Audit Logging

Records important system activities

11. ADBMS Features

Views, stored procedures, functions, triggers, indexes and transactions

--Responsive UI

Bootstrap-based responsive interface with a clean light-blue theme

## Technology Stack

1. Frontend
HTML5
CSS3
Bootstrap 5.3.3
Bootstrap Icons
JavaScript
Razor Views

2. Backend

C#
ASP.NET Core MVC
.NET 8
Entity Framework Core 8
Database
Microsoft SQL Server
SQL Server Express
T-SQL

3. Development Tools

Visual Studio / VS Code
SQL Server Management Studio (SSMS)

## Application Architecture

The project follows the Model–View–Controller (MVC) pattern:

                 ┌─────────────────────┐
                 │       Browser       │
                 │ HTML / CSS / JS      │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │      Controllers    │
                 │   ASP.NET Core MVC  │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │       Models        │
                 │   C# / EF Core      │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │    SQL Server DB    │
                 │  StockManagementDB  │
                 └─────────────────────┘

## Screenshots

Project screenshots are available in the `docs/screenshots/` folder.

# Pages & Functionalities

## Home Page

Controller: HomeController

View: Views/Home/Index.cshtml

The Home page introduces the system and provides navigation into the application.

--> Functions

Displays the application introduction

Provides navigation to authentication

Provides access to the main system after login

Includes access-denied and error pages

## Authentication

Controller: AuthController

--> Login

View: Views/Auth/Login.cshtml

Validates email and password

Checks whether the account is active

Verifies the hashed password

Creates an authentication cookie

Redirects users according to their role

--> Register

View: Views/Auth/Register.cshtml

Creates a new user account

Validates email uniqueness

Hashes the password before storing it

Assigns the default Staff role

--> Logout

Ends the authenticated session

Removes the authentication cookie

## Admin Dashboard

Controller: AdminController

View: Views/Admin/Dashboard.cshtml

The dashboard provides a quick overview of the current business state.

--> Displays

Total products

Total categories

Total suppliers

Total customers

Low-stock product count

Today's sales

Today's purchases

Low-stock products

Recent sales

This gives administrators and managers a centralized view of inventory activity.

## Product Management

Controller: ProductsController

--> Pages

Products/Index

Products/Create

Products/Edit

--> Functions

View products

Search products by name or SKU

Add products

Edit products

Delete products

Assign products to categories

Set unit and selling price

Set reorder level

Track current stock

Set product status

Database Integrity

Unique SKU

Category foreign key

Validation rules

Relational mapping through Entity Framework Core

# Category Management

Controller: CategoriesController

--> Functions

View categories

Add categories

Edit categories

Delete categories

Store category descriptions

Connect products with categories

## Supplier Management

Controller: SuppliersController

--> Functions

View suppliers

Search suppliers

Add suppliers

Edit supplier information

Delete suppliers

Store email, phone and address

Activate/deactivate suppliers

Suppliers are linked to purchase records through a foreign key relationship.

## Customer Management

Controller: CustomersController

--> Functions

View customers

Add customers

Edit customers

Delete customers

Store customer name, email and phone

Customers can be associated with sales transactions.

## Purchase Management

Controller: PurchasesController

--> Pages

Purchases/Index

Purchases/Create

Purchases/Details

Functions

View purchase history

Create new purchases


Select an active supplier

Add multiple product lines

Enter quantity

Enter unit cost

Calculate purchase totals

Generate invoice numbers

View complete purchase details

Increase product stock

Maintain stock transaction history

--> Purchase Workflow

Supplier
   ↓
New Purchase
   ↓
Purchase Details
   ↓
Product + Quantity + Cost
   ↓
Database Transaction
   ↓
Stock IN
   ↓
Stock Transaction / Audit History

Purchase creation is wrapped in a database transaction so the operation can be rolled back if an error occurs.

## Sales Management

Controller: SalesController

--> Pages

Sales/Index

Sales/Create

Sales/Details

--> Functions

View sales history

Create new sales

Select customers

Add products to a sale

Enter quantities

Set selling prices

Calculate sale totals

Generate invoice numbers

Check available stock

Reduce inventory after a sale

Maintain stock movement history

--> Sales Workflow

Customer
   ↓
New Sale
   ↓
Sale Details
   ↓
Product + Quantity + Price
   ↓
Stock Validation
   ↓
Database Transaction
   ↓
Stock OUT
   ↓
Stock Transaction / Audit History

## Reports

Controller: ReportsController

--> Stock Report

Displays product inventory information including current stock and reorder levels.

--> Sales Report

Displays sales from the recent reporting period and calculates the sales total.

--> Purchase Report

Displays purchases from the recent reporting period and calculates the purchase total.

--These reports provide database-driven information for inventory and transaction monitoring.

## Administration

Controller: AdminController

--> User Management

View: Views/Admin/Users.cshtml

View registered users

View user roles

Activate/deactivate users

--> Audit Logs

View: Views/Admin/AuditLogs.cshtml

View recent system activity

Identify the affected entity

Identify the action performed

View the user responsible

View activity date/time

## Audit Logging

The project contains an AuditService for recording important application activities.

Audit records include:

Entity name

Action type

Description

User responsible

Date/time

Examples of audited operations include product, category, supplier and purchase-related changes.

## Database Design

--> Database name:
StockManagementDB

--> Main Tables

AppUsers

Categories

Products

Suppliers

Customers

Purchases

PurchaseDetails

Sales

SaleDetails

StockTransactions

AuditLogs

--> Main Relationships

Categories
    │
    └── Products
          │
          ├── PurchaseDetails ── Purchases ── Suppliers
          │
          └── SaleDetails ───── Sales ────── Customers
          │
          └── StockTransactions

AppUsers ─────────── Authentication / Administration

AuditLogs ────────── System Activity History



#  ADBMS Concepts Implemented

This project was specifically designed to demonstrate database concepts beyond basic CRUD.


### 1. Primary Keys

Each major table uses a unique primary key, such as:

ProductId

CategoryId

SupplierId

CustomerId

PurchaseId

SaleId


### 2. Foreign Keys

Relationships are maintained using foreign keys.

Examples:

Products.CategoryId → Categories.Id

Purchases.SupplierId → Suppliers.Id

PurchaseDetails.PurchaseId → Purchases.Id

PurchaseDetails.ProductId → Products.Id

Sales.CustomerId → Customers.Id

SaleDetails.SaleId → Sales.Id

SaleDetails.ProductId → Products.Id


### 3. Referential Integrity

Foreign-key relationships protect data consistency and prevent invalid references.

Purchase and sale detail records use cascading behavior with their parent transaction records where appropriate.


### 4. Unique Constraints & Indexes

The database uses unique constraints and indexes for faster and safer data access.

Examples:
Products.SKU

Categories.Name

AppUsers.Email

Purchases.InvoiceNo

Sales.InvoiceNo

--Additional indexes support:

Product/category lookups

Product name searches

Sales date searches

Purchase date searches

Stock transaction history


### 5. Database Transactions

Purchase and sales processing use transaction-based operations.

Conceptually:

BEGIN TRANSACTION
        ↓
Validate data
        ↓
Create transaction
        ↓
Update inventory
        ↓
Save related records
        ↓
COMMIT

If an operation fails:

ROLLBACK

This helps prevent incomplete updates.


### 6. Database Views

The database provides reusable views:

vw_CurrentStock

vw_SalesSummary

vw_PurchaseSummary

These views simplify reporting queries and provide a reusable database layer.


### 7. Stored Procedures

The project includes stored procedures such as:

sp_GetLowStockProducts

sp_GetSalesByDate

sp_RecordStockTransaction

These demonstrate server-side procedural database logic.


### 8. User-Defined Functions

The database includes:

fn_ProductStockValue

fn_LowStockProducts

These demonstrate both scalar and table-valued SQL functions.


### 9. Database Triggers

The project includes triggers:

trg_PurchaseDetail_Audit

trg_SaleDetail_Audit

These triggers automatically create stock transaction records when purchase or sale detail records are inserted.

This also demonstrates how database-level automation can complement application-level business logic.


### 10. Decimal Precision

Financial values such as purchase costs, selling prices and totals use decimal precision suitable for monetary calculations.


## Complete Business Workflow

                    ┌───────────────┐
                    │     Login     │
                    └───────┬───────┘
                            ↓
                    ┌───────────────┐
                    │   Dashboard   │
                    └───────┬───────┘
                            │
          ┌─────────────────┼──────────────────┐
          ↓                 ↓                  ↓
     Products          Suppliers          Customers
          │                 │                  │
          ↓                 ↓                  ↓
      Categories        Purchases            Sales
                              │                  │
                              ↓                  ↓
                         Stock IN            Stock OUT
                              │                  │
                              └────────┬─────────┘
                                       ↓
                              Stock Transactions
                                       ↓
                                  Reports
                                       ↓
                                  Audit Logs

## Security & Validation

The application includes:

Cookie-based authentication,
Password hashing,
Role-based authorization,
Active-user validation,
Anti-forgery validation for POST operations,
Model validation,
Unique email validation,
Unique SKU validation,
Foreign-key constraints,
Transaction handling,
Audit logging,
Access-denied handling

Security note: Do not commit real production credentials, passwords, API keys or private connection strings to GitHub.

## UI / Design

The interface is built with Bootstrap 5, Bootstrap Icons, Razor Views and custom CSS.

Current Design,
Clean light-blue theme,
White content cards,
Responsive layouts,
Clear navigation,
Consistent buttons and forms,
Dashboard-style statistics,
User-friendly tables and forms

--> Main UI files:

Views/Shared/_Layout.cshtml

wwwroot/css/site.css

wwwroot/js/site.js

# Project Structure

ADBMS_STOCKMANAGEMENT_PROJECT/

│
├── 📁 database/

│   ├── StockManagementDB.sql

│   └── ADBMS_Features.sql

│
├── 📁 docs/
│   └── ADBMS_FEATURES.md

│
├── 📁 src/

│   └── 📁 StockManagement/

│       │
│       ├── 📁 Controllers/

│       │   ├── AdminController.cs

│       │   ├── AuthController.cs

│       │   ├── CategoriesController.cs

│       │   ├── CustomersController.cs

│       │   ├── HomeController.cs

│       │   ├── ProductsController.cs

│       │   ├── PurchasesController.cs

│       │   ├── ReportsController.cs

│       │   ├── SalesController.cs

│       │   └── SuppliersController.cs

│       │
│       ├── 📁 Data/

│       │   ├── ApplicationDbContext.cs

│       │   └── DbInitializer.cs

│       │
│       ├── 📁 Models/

│       │   └── Models.cs
│       │
│       ├── 📁 Services/

│       │   ├── AuditService.cs

│       │   └── PasswordService.cs
│       │
│       ├── 📁 Views/

│       │   ├── Admin/

│       │   ├── Auth/

│       │   ├── Categories/

│       │   ├── Customers/

│       │   ├── Home/

│       │   ├── Products/

│       │   ├── Purchases/

│       │   ├── Reports/

│       │   ├── Sales/

│       │   ├── Shared/

│       │   └── Suppliers/

│       │
│       ├── 📁 wwwroot/

│       │   ├── css/

│       │   └── js/
│       │

│       ├── appsettings.json

│       ├── Program.cs

│       └── StockManagement.csproj
│

├── StockManagement.sln

└── README.md

⚙️ How to Run

Prerequisites

Make sure the following are installed:

.NET 8 SDK

Microsoft SQL Server / SQL Server Express

SQL Server Management Studio (SSMS)

Visual Studio 2022 or VS Code

### Clone the Repository

git clone YOUR_GITHUB_REPOSITORY_URL

cd ADBMS_STOCKMANAGEMENT_PROJECT

### Configure SQL Server

Open:

src/StockManagement/appsettings.json

Configure the connection string according to your SQL Server instance.

Example local SQL Server Express configuration:

Server=localhost\SQLEXPRESS;

Database=StockManagementDB;

Trusted_Connection=True;

TrustServerCertificate=True;

MultipleActiveResultSets=true

### Database Setup

The repository contains:

database/StockManagementDB.sql

database/ADBMS_Features.sql

You can execute the database scripts using SQL Server Management Studio.

The application also contains an initializer that creates the database and inserts demo data when the database is initialized through the application.

### Run the Application

Open a terminal in:

src/StockManagement

Run:

dotnet restore

dotnet build

dotnet run

Then open the local URL shown in the terminal.

### Demo Accounts

The development database initializer provides demo accounts:

Role

Email

Password

1. Admin

admin@stock.local
Admin@12345

2.Manager

manager@stock.local
Manager@12345

3.Staff

staff@stock.local
Staff@12345

These credentials are for local/demo use only. Change or remove them before deploying the application publicly.

# Future Enhancements

Possible future improvements include:

Advanced filtering and pagination

Interactive dashboard charts

PDF/Excel report export

Barcode/QR-code support

Automated low-stock notifications

Supplier purchase history

Customer sales history

More granular permissions

Automated database backups

Cloud deployment

Automated testing

REST API integration



# Academic Learning Outcomes

This project demonstrates practical understanding of:

Relational database design

Database normalization

Primary and foreign keys

Referential integrity

Constraints and indexes

CRUD operations

Database transactions

SQL Server views

Stored procedures

User-defined functions

Database triggers

Audit logging

Inventory management

Entity Framework Core

ASP.NET Core MVC

Authentication and authorization



## Project Summary

ADBMS Stock Management System demonstrates how a relational database can power a complete business-oriented web application.

The project connects frontend UI → MVC controllers → Entity Framework Core → SQL Server and applies advanced database techniques to real inventory workflows such as purchasing, selling, stock tracking, reporting and auditing.

### Technologies at a Glance

C#

ASP.NET Core MVC

.NET 8

Entity Framework Core 8

Microsoft SQL Server

T-SQL

Bootstrap 5

HTML5

CSS3

JavaScript

Git & GitHub

<p align="center">
  <strong>📦 ADBMS Stock Management System</strong><br>
  Built as a full-stack academic project to demonstrate practical database and web development concepts.
</p>
