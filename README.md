# Ocelot 路由網關範例解決方案

本專案展示如何使用 **Ocelot** 作為 API 網關，實現微服務架構中的請求路由和轉發。

## 📚 技術棧

- **.NET 8** / **.NET 10**（取決於開發環境）
- **Ocelot 24.1.0** - 輕量級 API 網關
- **ASP.NET Core Web API**

## 📁 專案結構

```
OcelotDemo/
├── OcelotDemo.sln              (解決方案文件)
├── ApiGateway/                 (API 網關 - 埠 5000)
│   ├── ApiGateway.csproj
│   ├── Program.cs              (Ocelot 中介軟體配置)
│   ├── ocelot.json             (路由規則配置)
│   ├── appsettings.json
│   └── Properties/
│       └── launchSettings.json
├── ServiceA/                   (微服務 A - 埠 5056)
│   ├── ServiceA.csproj
│   ├── Program.cs
│   ├── Controllers/
│   │   └── TestController.cs   (測試端點)
│   ├── appsettings.json
│   └── Properties/
│       └── launchSettings.json
└── ServiceB/                   (微服務 B - 埠 5111)
    ├── ServiceB.csproj
    ├── Program.cs
    ├── Controllers/
    │   └── TestController.cs   (測試端點)
    ├── appsettings.json
    └── Properties/
        └── launchSettings.json
```

## 🔧 API 路由配置

Ocelot 在 **ocelot.json** 中定義了以下路由規則：

| 外部路徑 | 內部服務 | 埠號 |
|---------|--------|------|
| `/api/a/*` | ServiceA | 5056 |
| `/api/b/*` | ServiceB | 5111 |

### 路由配置示例

```json
{
  "Routes": [
    {
      "UpstreamPathTemplate": "/api/a/{everything}",
      "DownstreamPathTemplate": "/api/{everything}",
      "DownstreamScheme": "http",
      "DownstreamHostAndPorts": [
        {
          "Host": "localhost",
          "Port": 5056
        }
      ],
      "UpstreamHttpMethod": ["Get", "Post", "Put", "Delete"]
    }
  ]
}
```

## 🚀 快速開始

### 前置條件
- .NET 8 或 .NET 10 SDK
- Visual Studio 2022 或 Visual Studio Code（可選）

### 建置專案

```bash
cd OcelotDemo
dotnet build
```

### 一鍵啟動所有服務（推薦）✨

#### Windows (PowerShell)
```powershell
.\start-all.ps1
```

#### Linux / macOS (Bash)
```bash
chmod +x start-all.sh
./start-all.sh
```

#### 使用 Docker Compose
```bash
docker-compose up --build
```

---

### 手動運行服務（開發模式）

在不同的終端視窗中分別執行：

**終端 1 - 啟動 ApiGateway（網關）**
```bash
dotnet run --project ApiGateway
# 監聽: http://localhost:5000
```

**終端 2 - 啟動 ServiceA**
```bash
dotnet run --project ServiceA
# 監聽: http://localhost:5056
```

**終端 3 - 啟動 ServiceB**
```bash
dotnet run --project ServiceB
# 監聽: http://localhost:5111
```

## 📋 啟動方式對比

| 方式 | 命令 | 優點 | 適用場景 |
|------|------|------|--------|
| **一鍵啟動（推薦）** | `.\start-all.ps1` 或 `./start-all.sh` | 簡單、快速、視覺化 | 日常開發 |
| **Docker Compose** | `docker-compose up --build` | 隔離環境、跨平台 | CI/CD、部署 |
| **手動啟動** | 3 個終端分別運行 | 完整日誌、易於調試 | 深度開發調試 |
| **Visual Studio** | F5（設置多啟動專案） | 集成開發、斷點調試 | IDE 開發 |

> 📖 詳細啟動指南請參考 **[STARTUP-GUIDE.md](./STARTUP-GUIDE.md)**

---

## 📡 測試 API

### 直接訪問服務

```bash
# ServiceA
curl http://localhost:5056/api/hello

# ServiceB
curl http://localhost:5111/api/hello
```

### 透過 ApiGateway 路由（推薦）

```bash
# 路由到 ServiceA
curl http://localhost:5000/api/a/hello

# 路由到 ServiceB
curl http://localhost:5000/api/b/hello
```

### 預期響應

```json
{
  "message": "This is Service A",
  "timestamp": "2026-03-06T00:08:00.000Z"
}
```

取得服務信息：

```bash
# 透過 Gateway 路由到 ServiceA
curl http://localhost:5000/api/a/info

# 響應
{
  "service": "ServiceA",
  "version": "1.0",
  "status": "running"
}
```

## 🔑 關鍵代碼

### Program.cs - ApiGateway 配置

```csharp
using Ocelot.DependencyInjection;
using Ocelot.Middleware;

var builder = WebApplication.CreateBuilder(args);

// 添加 Ocelot 配置
builder.Configuration.AddJsonFile("ocelot.json", optional: false, reloadOnChange: true);

// 添加 Ocelot 服務
builder.Services.AddOcelot(builder.Configuration);

builder.Services.AddControllers();

var app = builder.Build();

// 使用 Ocelot 中介軟體
await app.UseOcelot();

app.MapControllers();

app.Run();
```

### TestController - 服務端點

```csharp
[ApiController]
[Route("api")]
public class TestController : ControllerBase
{
    [HttpGet("hello")]
    public IActionResult GetHello()
    {
        return Ok(new { message = "This is Service A", timestamp = DateTime.UtcNow });
    }

    [HttpGet("info")]
    public IActionResult GetInfo()
    {
        return Ok(new { service = "ServiceA", version = "1.0", status = "running" });
    }
}
```

## 🎯 架構優勢

1. **集中路由管理** - 所有 API 路由在單一 JSON 配置檔中管理
2. **服務解耦** - 外部客戶端無需知道各個微服務的具體埠號
3. **易於擴展** - 添加新服務只需在 ocelot.json 中增加路由規則
4. **動態重載** - 修改 ocelot.json 後無需重啟網關
5. **輕量級** - Ocelot 開銷小，性能高效

## 📝 常見操作

### 添加新路由

編輯 `ApiGateway/ocelot.json`，在 Routes 陣列中添加新的路由規則：

```json
{
  "UpstreamPathTemplate": "/api/c/{everything}",
  "DownstreamPathTemplate": "/api/{everything}",
  "DownstreamHostAndPorts": [{"Host": "localhost", "Port": 5172}],
  "UpstreamHttpMethod": ["Get", "Post", "Put", "Delete"]
}
```

### 修改服務埠號

1. 修改相應服務的 `Properties/launchSettings.json`
2. 更新 `ApiGateway/ocelot.json` 中的埠號配置

## 🛠️ 開發提示

- 所有服務應該在 Development 環境下運行，以便於調試
- Ocelot 支援請求/響應轉換、驗證、限流等高級功能
- 可使用 Ocelot 的 QoS（Quality of Service）功能實現熔斷和重試

## 📂 核心文件說明

| 檔案/目錄 | 說明 |
|----------|------|
| `OcelotDemo.slnx` | Visual Studio 解決方案文件 |
| `ocelot.json` | Ocelot 路由配置文件 |
| `start-all.ps1` | Windows 一鍵啟動腳本 |
| `start-all.sh` | Linux/macOS 一鍵啟動腳本 |
| `docker-compose.yml` | Docker Compose 容器編排配置 |
| `*/Dockerfile` | 各服務的容器鏡像配置 |
| `STARTUP-GUIDE.md` | 詳細啟動指南和常見問題解答 |
| `README.md` | 本文件（快速開始指南） |

## 🐳 容器化部署

本專案支援 Docker 容器化，包含：
- 完整的 Dockerfile 配置（三層構建）
- docker-compose.yml 一鍵部署配置
- 自動化容器網路設定

詳見 **[STARTUP-GUIDE.md](./STARTUP-GUIDE.md)** 的 Docker Compose 章節。

## 📚 相關資源

- [Ocelot 官方文檔](https://ocelot.readthedocs.io/)
- [ASP.NET Core 官方文檔](https://docs.microsoft.com/aspnet/core/)
- [API 網關設計模式](https://microservices.io/patterns/apigateway.html)
- [Docker 官方文檔](https://docs.docker.com/)
- [Docker Compose 文檔](https://docs.docker.com/compose/)

## ❓ 常見問題

**Q: 如何一鍵啟動所有服務？**
A: 執行 `start-all.ps1`（Windows）或 `./start-all.sh`（Linux/macOS）

**Q: 如何用 Docker 運行？**
A: 執行 `docker-compose up --build`

**Q: 如何在 Visual Studio 中同時運行多個專案？**
A: 在 Solution Properties 中設置多啟動專案，詳見 STARTUP-GUIDE.md

**Q: 如何修改服務埠號？**
A: 修改 `Properties/launchSettings.json` 和 `ApiGateway/ocelot.json`

更多常見問題解答請參考 **[STARTUP-GUIDE.md](./STARTUP-GUIDE.md)**

## 📄 授權

本專案作為教育範例提供，可自由使用和修改。

---

**建立日期**: 2026-03-06
**最後更新**: 2026-03-06
