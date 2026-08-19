using TOK.WMS.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

var connStr = builder.Configuration.GetConnectionString("TOK")
    ?? throw new InvalidOperationException("Connection string '' not found.");

builder.Services.AddInfrastructure(connStr);

builder.Services.AddControllers(options =>
{
    options.SuppressImplicitRequiredAttributeForNonNullableReferenceTypes = true;
});
builder.Services.AddSignalR();
builder.Services.AddOpenApi();

// WPF 클라이언트에서 접근할 수 있도록 CORS 허용
builder.Services.AddCors(opt =>
    opt.AddDefaultPolicy(p => p.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod()));

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.UseSwaggerUI(o => o.SwaggerEndpoint("/openapi/v1.json", "TOK.WMS.Api v1"));
}


app.UseCors();
app.UseAuthorization();
app.MapControllers();

app.Run();
