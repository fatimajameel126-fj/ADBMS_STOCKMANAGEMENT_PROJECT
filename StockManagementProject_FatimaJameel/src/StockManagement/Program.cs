using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.EntityFrameworkCore;
using StockManagement.Data;
using StockManagement.Services;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllersWithViews();
builder.Services.AddDbContext<ApplicationDbContext>(o => o.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddScoped<AuditService>();
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie(o => { o.LoginPath="/Auth/Login"; o.AccessDeniedPath="/Home/AccessDenied"; o.Cookie.Name="StockManagement.Auth"; o.ExpireTimeSpan=TimeSpan.FromHours(8); o.SlidingExpiration=true; });
builder.Services.AddAuthorization();
var app = builder.Build();
using (var scope = app.Services.CreateScope()) { DbInitializer.Initialize(scope.ServiceProvider.GetRequiredService<ApplicationDbContext>()); }
if (!app.Environment.IsDevelopment()) { app.UseExceptionHandler("/Home/Error"); app.UseHsts(); }
app.UseHttpsRedirection(); app.UseStaticFiles(); app.UseRouting(); app.UseAuthentication(); app.UseAuthorization();
app.MapControllerRoute(name:"default", pattern:"{controller=Home}/{action=Index}/{id?}");
app.Run();
