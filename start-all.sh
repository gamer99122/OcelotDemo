#!/bin/bash
# Ocelot 範例解決方案 - 一鍵啟動所有服務 (Bash)
# 用法: bash start-all.sh 或 ./start-all.sh

set -e

echo "========================================"
echo "啟動 Ocelot 微服務路由網關範例"
echo "========================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 檢查 .NET SDK 是否已安裝
if ! command -v dotnet &> /dev/null; then
    echo "✗ 錯誤: 未安裝 .NET SDK"
    exit 1
fi

DOTNET_VERSION=$(dotnet --version)
echo "✓ 檢測到 .NET SDK: $DOTNET_VERSION"
echo ""
echo "啟動服務中..."
echo ""

# 清理函數：結束時關閉所有後台進程
cleanup() {
    echo ""
    echo "⏹️  關閉所有服務..."
    kill $(jobs -p) 2>/dev/null
    exit 0
}

# 捕捉 Ctrl+C 信號
trap cleanup SIGINT SIGTERM

# 啟動 ServiceA
echo "1️⃣  啟動 ServiceA (埠 5056)..."
dotnet run --project ServiceA &
SERVICE_A_PID=$!

# 等待 ServiceA 啟動
sleep 3

# 啟動 ServiceB
echo "2️⃣  啟動 ServiceB (埠 5111)..."
dotnet run --project ServiceB &
SERVICE_B_PID=$!

# 等待 ServiceB 啟動
sleep 3

# 啟動 ApiGateway
echo "3️⃣  啟動 ApiGateway (埠 5000)..."
dotnet run --project ApiGateway &
API_GATEWAY_PID=$!

echo ""
echo "========================================"
echo "✓ 所有服務已啟動！"
echo "========================================"
echo ""
echo "📡 可用的 API 端點:"
echo "  • 透過 Gateway 路由到 ServiceA: http://localhost:5000/api/a/hello"
echo "  • 透過 Gateway 路由到 ServiceB: http://localhost:5000/api/b/hello"
echo "  • 直接訪問 ServiceA: http://localhost:5056/api/hello"
echo "  • 直接訪問 ServiceB: http://localhost:5111/api/hello"
echo ""
echo "⏹️  按 Ctrl+C 停止所有服務"
echo ""

# 等待所有後台進程
wait
