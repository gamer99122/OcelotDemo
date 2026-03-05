# 🚀 Ocelot 範例解決方案 - 啟動指南

本文檔提供多種方式來啟動 Ocelot 微服務路由網關範例。

---

## 📋 前置條件

### 基本要求
- **.NET 8 或更高版本** 已安裝
  ```bash
  dotnet --version
  ```

### 可選要求
- **Visual Studio 2022** 或 **Visual Studio Code**
- **Docker Desktop**（用於容器化啟動）
- **PowerShell 5.0+**（Windows）

---

## 方式 1️⃣: 一鍵啟動所有服務（推薦）

### Windows (PowerShell)

1. 打開 PowerShell
2. 進入專案目錄：
   ```powershell
   cd C:\Users\Lin\Desktop\AI_APIGetway\OcelotDemo
   ```
3. 執行啟動腳本：
   ```powershell
   .\start-all.ps1
   ```

**預期結果：**
```
========================================
啟動 Ocelot 微服務路由網關範例
========================================

✓ 檢測到 .NET SDK: 8.0.101

啟動服務中...

1️⃣  啟動 ServiceA (埠 5056)...
2️⃣  啟動 ServiceB (埠 5111)...
3️⃣  啟動 ApiGateway (埠 5000)...

========================================
✓ 所有服務已啟動！
========================================
```

### Linux / macOS (Bash)

1. 打開終端
2. 進入專案目錄：
   ```bash
   cd ~/OcelotDemo
   ```
3. 讓腳本可執行：
   ```bash
   chmod +x start-all.sh
   ```
4. 執行啟動腳本：
   ```bash
   ./start-all.sh
   ```

---

## 方式 2️⃣: 使用 Docker Compose（容器化）

### 前置條件
- 已安裝 **Docker Desktop**
- Docker 守護進程正在運行

### 啟動步驟

1. 進入專案目錄：
   ```bash
   cd OcelotDemo
   ```

2. 構建並啟動容器：
   ```bash
   docker-compose up --build
   ```

3. 首次可能需要較長時間（下載基礎鏡像、NuGet 套件等）

### 停止容器

按 `Ctrl+C` 或在另一個終端執行：
```bash
docker-compose down
```

### 優勢
✓ 隔離環境，不污染本地系統
✓ 容易在不同機器上重現
✓ 便於 CI/CD 集成

---

## 方式 3️⃣: 手動啟動（開發者模式）

### 在不同終端視窗中分別執行

**終端 1 - 啟動 ServiceA：**
```bash
cd OcelotDemo
dotnet run --project ServiceA
```

**終端 2 - 啟動 ServiceB：**
```bash
cd OcelotDemo
dotnet run --project ServiceB
```

**終端 3 - 啟動 ApiGateway：**
```bash
cd OcelotDemo
dotnet run --project ApiGateway
```

**預期輸出：**
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
```

### 優勢
✓ 完整的調試日誌輸出
✓ 可以逐個調試每個服務
✓ 便於開發和修改代碼

---

## 方式 4️⃣: Visual Studio 多啟動專案

### 設置步驟

1. 用 Visual Studio 2022 打開 `OcelotDemo.slnx`

2. **方法 A: 使用 Visual Studio UI**
   - 在 Solution Explorer 中右鍵點擊解決方案
   - 選擇 **Properties**（或 **Set Startup Projects**）
   - 選擇 **Multiple startup projects**
   - 為三個專案設置 **Action** 為 **Start**

   ```
   □ ApiGateway         → Start
   □ ServiceA           → Start
   □ ServiceB           → Start
   ```

3. 按 **F5** 或點擊 **Start** 按鈕

### 預期結果
三個專案同時啟動，且可在 Visual Studio 的 Output 窗格中查看所有日誌。

### 優勢
✓ 集中在 Visual Studio 中管理
✓ 完整的調試功能
✓ 斷點調試

---

## 🧪 測試 API 端點

### 方式 A: 使用 curl

```bash
# 透過 Gateway 路由到 ServiceA
curl http://localhost:5000/api/a/hello

# 透過 Gateway 路由到 ServiceB
curl http://localhost:5000/api/b/hello

# 直接訪問 ServiceA
curl http://localhost:5056/api/hello

# 直接訪問 ServiceB
curl http://localhost:5111/api/hello
```

### 方式 B: 使用 PowerShell

```powershell
# 測試 Gateway 路由
Invoke-RestMethod -Uri "http://localhost:5000/api/a/hello"

# 或
(Invoke-WebRequest -Uri "http://localhost:5000/api/a/hello").Content | ConvertFrom-Json
```

### 方式 C: 使用瀏覽器

直接訪問以下網址：
- `http://localhost:5000/api/a/hello`
- `http://localhost:5000/api/b/hello`
- `http://localhost:5056/api/hello`
- `http://localhost:5111/api/hello`

### 預期響應

```json
{
  "message": "This is Service A",
  "timestamp": "2026-03-06T00:08:00Z"
}
```

---

## 📡 API 端點快速參考

| 說明 | URL | 埠號 |
|------|-----|------|
| ApiGateway | `http://localhost:5000` | 5000 |
| ServiceA (直接) | `http://localhost:5056` | 5056 |
| ServiceB (直接) | `http://localhost:5111` | 5111 |
| ServiceA (透過 Gateway) | `http://localhost:5000/api/a/*` | 5000 |
| ServiceB (透過 Gateway) | `http://localhost:5000/api/b/*` | 5000 |

---

## 🛑 停止服務

### PowerShell 腳本啟動
- 關閉彈出的 PowerShell 視窗
- 或按 `Ctrl+C`

### Bash 腳本啟動
- 按 `Ctrl+C` 在終端中

### Docker Compose 啟動
```bash
docker-compose down
```

### Manual 啟動（多終端）
- 在每個終端中按 `Ctrl+C`

### Visual Studio 啟動
- 點擊 **Stop Debugging**（Shift+F5）
- 或關閉 Visual Studio

---

## 🔍 常見問題

### Q1: 埠號被占用

**問題：** 啟動時出現 "Address already in use" 錯誤

**解決方案：**
1. 檢查是否有其他進程使用該埠：
   ```bash
   # Windows
   netstat -ano | findstr :5000

   # Linux/macOS
   lsof -i :5000
   ```
2. 關閉占用埠的進程
3. 或修改 `Properties/launchSettings.json` 中的埠號

### Q2: .NET SDK 未安裝

**問題：** "dotnet: command not found"

**解決方案：**
1. 下載並安裝 .NET SDK: https://dotnet.microsoft.com/download
2. 重啟終端並重試

### Q3: Docker 鏡像構建失敗

**問題：** Docker 構建時出錯

**解決方案：**
```bash
# 清除 Docker 快取
docker system prune -a

# 重新構建
docker-compose up --build
```

### Q4: 服務互相無法通訊

**問題：** 透過 Gateway 路由時出現連接錯誤

**解決方案：**
1. 確保所有三個服務都已啟動
2. 使用 Docker Compose 時，檢查網路設定
3. 檢查 `ocelot.json` 中的埠號配置

---

## 📚 進階用法

### 修改埠號

編輯相應服務的 `Properties/launchSettings.json`：

```json
{
  "profiles": {
    "http": {
      "applicationUrl": "http://localhost:YOUR_PORT"
    }
  }
}
```

然後更新 `ApiGateway/ocelot.json` 中的下游埠號配置。

### 添加新微服務

1. 建立新的 Web API 專案：
   ```bash
   dotnet new webapi -n ServiceC
   ```

2. 將其加入解決方案：
   ```bash
   dotnet sln add ServiceC/ServiceC.csproj
   ```

3. 在 `ocelot.json` 中添加路由規則

4. 更新啟動腳本（如使用腳本方式）

---

## 📝 日誌和調試

### 查看詳細日誌

設置環境變數：

**Windows (PowerShell):**
```powershell
$env:ASPNETCORE_ENVIRONMENT = "Development"
$env:Logging__LogLevel__Default = "Debug"
```

**Linux/macOS:**
```bash
export ASPNETCORE_ENVIRONMENT=Development
export Logging__LogLevel__Default=Debug
```

然後啟動服務。

---

## ✅ 驗證一切正常

1. ✓ 所有三個服務已啟動
2. ✓ 能透過 Gateway 成功路由請求
3. ✓ 能直接訪問各個微服務
4. ✓ 收到預期的 JSON 響應

**恭喜！** 🎉 您的 Ocelot 微服務網關已準備就緒！

---

**建立日期**: 2026-03-06
**最後更新**: 2026-03-06
