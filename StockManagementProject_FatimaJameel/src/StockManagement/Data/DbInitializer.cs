using Microsoft.EntityFrameworkCore;
using StockManagement.Models;
using StockManagement.Services;
namespace StockManagement.Data;
public static class DbInitializer
{
 public static void Initialize(ApplicationDbContext db){db.Database.EnsureCreated(); if(db.Users.Any()) return;
 db.Users.AddRange(new AppUser{FullName="System Administrator",Email="admin@stock.local",PasswordHash=PasswordService.Hash("Admin@12345"),Role=Roles.Admin},new AppUser{FullName="Inventory Manager",Email="manager@stock.local",PasswordHash=PasswordService.Hash("Manager@12345"),Role=Roles.Manager},new AppUser{FullName="Sales Staff",Email="staff@stock.local",PasswordHash=PasswordService.Hash("Staff@12345"),Role=Roles.Staff});
 var c1=new Category{Name="Electronics",Description="Electronic items and accessories"};var c2=new Category{Name="Office Supplies",Description="Office and stationery products"};db.Categories.AddRange(c1,c2);db.SaveChanges();
 db.Products.AddRange(new Product{SKU="ELEC-001",Name="Wireless Mouse",CategoryId=c1.Id,Unit="Piece",UnitPrice=2500,ReorderLevel=10,CurrentStock=35},new Product{SKU="ELEC-002",Name="Keyboard",CategoryId=c1.Id,Unit="Piece",UnitPrice=3500,ReorderLevel=8,CurrentStock=6},new Product{SKU="OFF-001",Name="Notebook",CategoryId=c2.Id,Unit="Piece",UnitPrice=450,ReorderLevel=20,CurrentStock=80},new Product{SKU="OFF-002",Name="Printer Paper",CategoryId=c2.Id,Unit="Pack",UnitPrice=1800,ReorderLevel=15,CurrentStock=12});
 db.Suppliers.AddRange(new Supplier{Name="Tech Distributors",Email="sales@techdist.local",Phone="0300-1111111",Address="Rawalpindi"},new Supplier{Name="Office Mart",Email="orders@officemart.local",Phone="0300-2222222",Address="Islamabad"});
 db.Customers.AddRange(new Customer{Name="Walk-in Customer",Email="walkin@stock.local",Phone="0300-0000000"},new Customer{Name="ABC Traders",Email="abc@traders.local",Phone="0300-3333333"});db.SaveChanges();
 db.AuditLogs.Add(new AuditLog{EntityName="System",ActionType="Seed",Description="Initial Stock Management demo data created.",ChangedBy="System"});db.SaveChanges(); }
}
