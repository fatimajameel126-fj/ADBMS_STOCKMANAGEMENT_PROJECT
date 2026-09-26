using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StockManagement.Data; using StockManagement.Models; using StockManagement.Services; using System.Security.Claims;
namespace StockManagement.Controllers;
public class AuthController:Controller { private readonly ApplicationDbContext _db; public AuthController(ApplicationDbContext db)=>_db=db;
[HttpGet] public IActionResult Login()=>View();
[HttpPost,ValidateAntiForgeryToken] public async Task<IActionResult> Login(string email,string password){var u=_db.Users.FirstOrDefault(x=>x.Email==email&&x.IsActive); if(u is null||!PasswordService.Verify(password,u.PasswordHash)){ModelState.AddModelError("","Invalid email or password.");return View();} var claims=new[]{new Claim(ClaimTypes.Name,u.FullName),new Claim(ClaimTypes.Email,u.Email),new Claim(ClaimTypes.Role,u.Role),new Claim("UserId",u.Id.ToString())}; await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme,new ClaimsPrincipal(new ClaimsIdentity(claims,CookieAuthenticationDefaults.AuthenticationScheme))); return u.Role switch { Roles.Admin or Roles.Manager => RedirectToAction("Dashboard", "Admin"), _ => RedirectToAction("Index", "Products") };}
[Authorize,HttpPost,ValidateAntiForgeryToken] public async Task<IActionResult> Logout(){await HttpContext.SignOutAsync();return RedirectToAction("Index","Home");}
[HttpGet] public IActionResult Register()=>View();
[HttpPost,ValidateAntiForgeryToken] public IActionResult Register(AppUser model,string password){if(_db.Users.Any(x=>x.Email==model.Email)){ModelState.AddModelError("Email","Email already exists.");return View(model);} if(!ModelState.IsValid)return View(model); model.PasswordHash=PasswordService.Hash(password); model.Role=Roles.Staff; _db.Users.Add(model);_db.SaveChanges();TempData["Success"]="Account created. Please login.";return RedirectToAction(nameof(Login));}
}
