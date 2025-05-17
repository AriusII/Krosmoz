using Krosmoz.Core.Extensions;
using Krosmoz.Protocol.Datacenter;
using Krosmoz.Serialization.D2O.Abstractions;
using Krosmoz.Serialization.Repository;
using Krosmoz.Servers.AuthServer.Database;
using Krosmoz.Servers.GameServer.Database;
using Krosmoz.Tools.Database.Base;
using Krosmoz.Tools.Database.Hosting;
using Krosmoz.Tools.Database.Servers;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

await Host.CreateDefaultBuilder(args)
    .ConfigureLogging(static logging => logging.UseSerilog())
    .ConfigureServices(static (context, services) =>
    {
        services
            .AddDbContext<AuthDbContext>(context.Configuration.GetConnectionString("Auth"))
            .AddDbContext<GameDbContext>(context.Configuration.GetConnectionString("Game"))
            .AddSingleton<IDatacenterObjectFactory, DatacenterObjectFactory>()
            .AddSingleton<IDatacenterRepository, DatacenterRepository>()
            .AddSingleton<BaseSynchronizer, ServerSynchronizer>()
            .AddHostedService<SynchronizerHostedService>();
    })
    .RunConsoleAsync();
