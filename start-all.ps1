# Ocelot 範例解決方案 - 一鍵啟動所有服務 (PowerShell)
# 用法: .\start-all.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "啟動 Ocelot 微服務路由網關範例" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# 檢查 .NET SDK 是否已安裝
try {
    $dotnetVersion = dotnet --version
    Write-Host "✓ 檢測到 .NET SDK: $dotnetVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ 錯誤: 未安裝 .NET SDK" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "啟動服務中..." -ForegroundColor Yellow
Write-Host ""

# 啟動 ServiceA
Write-Host "1️⃣  啟動 ServiceA (埠 5056)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectPath'; dotnet run --project ServiceA" -NoNewWindow

# 等待 ServiceA 啟動
Start-Sleep -Seconds 3

# 啟動 ServiceB
Write-Host "2️⃣  啟動 ServiceB (埠 5111)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectPath'; dotnet run --project ServiceB" -NoNewWindow

# 等待 ServiceB 啟動
Start-Sleep -Seconds 3

# 啟動 ApiGateway
Write-Host "3️⃣  啟動 ApiGateway (埠 5000)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectPath'; dotnet run --project ApiGateway" -NoNewWindow

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ 所有服務已啟動！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "📡 可用的 API 端點:" -ForegroundColor Yellow
Write-Host "  • 透過 Gateway 路由到 ServiceA: http://localhost:5000/api/a/hello" -ForegroundColor White
Write-Host "  • 透過 Gateway 路由到 ServiceB: http://localhost:5000/api/b/hello" -ForegroundColor White
Write-Host "  • 直接訪問 ServiceA: http://localhost:5056/api/hello" -ForegroundColor White
Write-Host "  • 直接訪問 ServiceB: http://localhost:5111/api/hello" -ForegroundColor White
Write-Host ""
Write-Host "⏹️  關閉所有窗口可停止所有服務" -ForegroundColor Yellow
Write-Host ""
