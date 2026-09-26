using Microsoft.EntityFrameworkCore;
using StockManagement.Models;

namespace StockManagement.Data;
public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options):base(options){}
    public DbSet<AppUser> Users => Set<AppUser>();
    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Product> Products => Set<Product>();
    public DbSet<Supplier> Suppliers => Set<Supplier>();
    public DbSet<Customer> Customers => Set<Customer>();
    public DbSet<Purchase> Purchases => Set<Purchase>();
    public DbSet<PurchaseDetail> PurchaseDetails => Set<PurchaseDetail>();
    public DbSet<Sale> Sales => Set<Sale>();
    public DbSet<SaleDetail> SaleDetails => Set<SaleDetail>();
    public DbSet<StockTransaction> StockTransactions => Set<StockTransaction>();
    public DbSet<AuditLog> AuditLogs => Set<AuditLog>();
    protected override void OnModelCreating(ModelBuilder b)
    {
        // The SQL script creates AppUsers, while EF Core convention would map AppUser to Users.
        // Explicitly map the entity to the existing database table.
        b.Entity<AppUser>().ToTable("AppUsers");
        b.Entity<Product>().Property(x=>x.UnitPrice).HasPrecision(18,2);
        b.Entity<Purchase>().Property(x=>x.TotalAmount).HasPrecision(18,2);
        b.Entity<PurchaseDetail>().Property(x=>x.UnitCost).HasPrecision(18,2);
        b.Entity<Sale>().Property(x=>x.TotalAmount).HasPrecision(18,2);
        b.Entity<SaleDetail>().Property(x=>x.UnitPrice).HasPrecision(18,2);
        b.Entity<StockTransaction>().Property(x=>x.UnitCost).HasPrecision(18,2);
        // These tables have SQL Server AFTER INSERT triggers. Declaring them here makes
        // EF Core avoid the OUTPUT clause that is incompatible with tables containing triggers.
        b.Entity<PurchaseDetail>().ToTable("PurchaseDetails", tb => tb.HasTrigger("trg_PurchaseDetail_Audit"));
        b.Entity<SaleDetail>().ToTable("SaleDetails", tb => tb.HasTrigger("trg_SaleDetail_Audit"));
        b.Entity<PurchaseDetail>().HasOne(x=>x.Purchase).WithMany(x=>x.Details).HasForeignKey(x=>x.PurchaseId).OnDelete(DeleteBehavior.Cascade);
        b.Entity<SaleDetail>().HasOne(x=>x.Sale).WithMany(x=>x.Details).HasForeignKey(x=>x.SaleId).OnDelete(DeleteBehavior.Cascade);
        b.Entity<Product>().HasOne(x=>x.Category).WithMany(x=>x.Products).HasForeignKey(x=>x.CategoryId).OnDelete(DeleteBehavior.Restrict);
        b.Entity<Product>().HasIndex(x=>x.SKU).IsUnique();
        b.Entity<AppUser>().HasIndex(x=>x.Email).IsUnique();
        b.Entity<Product>().Property(x=>x.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
    }
}
