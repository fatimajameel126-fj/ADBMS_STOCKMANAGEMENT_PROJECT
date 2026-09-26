using System.Security.Cryptography;
namespace StockManagement.Services;
public static class PasswordService { public static string Hash(string value)=>Convert.ToBase64String(System.Security.Cryptography.SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(value))); public static bool Verify(string value,string hash)=>Hash(value)==hash; }
