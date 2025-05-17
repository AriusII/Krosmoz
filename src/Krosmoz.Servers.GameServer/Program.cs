
using Krosmoz.Core.Extensions;
using Krosmoz.Servers.GameServer.Database;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;

await Host.CreateDefaultBuilder(args)
    .ConfigureLogging(static logging => logging.UseSerilog())
    .ConfigureServices(static (context, services) =>
    {
        services.AddDbContext<GameDbContext>(context.Configuration.GetConnectionString("Game"));
    })
    .RunConsoleAsync();
