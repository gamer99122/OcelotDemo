FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 複製 solution 和專案檔案
COPY ["OcelotDemo.slnx", "."]
COPY ["ServiceA/ServiceA.csproj", "ServiceA/"]

# 還原依賴
RUN dotnet restore "ServiceA/ServiceA.csproj"

# 複製原始程式碼
COPY ["ServiceA/", "ServiceA/"]

# 構建
WORKDIR "/src/ServiceA"
RUN dotnet build "ServiceA.csproj" -c Release -o /app/build

# 發佈
FROM build AS publish
RUN dotnet publish "ServiceA.csproj" -c Release -o /app/publish

# 執行階段
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=publish /app/publish .

EXPOSE 5056

ENTRYPOINT ["dotnet", "ServiceA.dll"]
