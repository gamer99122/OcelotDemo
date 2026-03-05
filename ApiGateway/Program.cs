using Ocelot.DependencyInjection;
using Ocelot.Middleware;

var builder = WebApplication.CreateBuilder(args);

// 添加 Ocelot 配置
builder.Configuration.AddJsonFile("ocelot.json", optional: false, reloadOnChange: true);

// 添加 Ocelot 服務
builder.Services.AddOcelot(builder.Configuration);

// 添加基本服務
builder.Services.AddControllers();

var app = builder.Build();

// 使用 Ocelot 中介軟體
await app.UseOcelot();

app.MapControllers();

app.Run();
