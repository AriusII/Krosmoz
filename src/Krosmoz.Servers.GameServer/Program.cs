
using Krosmoz.Core.Extensions;
using Krosmoz.Core.Network.Factory;
using Krosmoz.Core.Network.Framing;
using Krosmoz.Core.Network.Transport;
using Krosmoz.Core.Scheduling;
using Krosmoz.Protocol.Datacenter;
using Krosmoz.Protocol.Messages;
using Krosmoz.Serialization.D2O.Abstractions;
using Krosmoz.Serialization.Repository;
using Krosmoz.Servers.GameServer.Database;
using Krosmoz.Servers.GameServer.Network.Transport;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

await Host.CreateDefaultBuilder(args)
    .ConfigureLogging(static logging => logging.UseSerilog())
    .ConfigureServices(static (context, services) =>
    {
        services
            .Configure<TcpServerOptions>(context.Configuration.GetSection("Server"))
            .AddDbContext<GameDbContext>(context.Configuration.GetConnectionString("Game"))
            .AddTransient<DofusMessageDecoder>()
            .AddTransient<DofusMessageEncoder>()
            .AddTransient<IScheduler, Scheduler>()
            .AddSingleton<IMessageFactory, MessageFactory>()
            .AddSingleton<IDatacenterObjectFactory, DatacenterObjectFactory>()
            .AddSingleton<IDatacenterRepository, DatacenterRepository>()
            .AddHostedServiceAsSingleton<GameServer>();
    })
    .RunConsoleAsync();
