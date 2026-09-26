using StockManagement.Data;
using StockManagement.Models;
namespace StockManagement.Services;
public class AuditService { private readonly ApplicationDbContext _db; public AuditService(ApplicationDbContext db)=>_db=db; public void Add(string entity,string action,string description,string by){_db.AuditLogs.Add(new AuditLog{EntityName=entity,ActionType=action,Description=description,ChangedBy=string.IsNullOrWhiteSpace(by)?"System":by}); _db.SaveChanges();} }
