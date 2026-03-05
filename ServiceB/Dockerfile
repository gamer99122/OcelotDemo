FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 複製 solution 和專案檔案
COPY ["OcelotDemo.slnx", "."]
COPY ["ServiceB/ServiceB.csproj", "ServiceB/"]

# 還原依賴
RUN dotnet restore "ServiceB/ServiceB.csproj"

# 複製原始程式碼
COPY ["ServiceB/", "ServiceB/"]

# 構建
WORKDIR "/src/ServiceB"
RUN dotnet build "ServiceB.csproj" -c Release -o /app/build

# 發佈
FROM build AS publish
RUN dotnet publish "ServiceB.csproj" -c Release -o /app/publish

# 執行階段
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=publish /app/publish .

EXPOSE 5111

ENTRYPOINT ["dotnet", "ServiceB.dll"]
