using Krosmoz.Core.Extensions;
using Krosmoz.Core.Network.Dispatcher;
using Krosmoz.Core.Network.Factory;
using Krosmoz.Core.Network.Framing;
using Krosmoz.Core.Network.Transport;
using Krosmoz.Protocol.Datacenter;
using Krosmoz.Protocol.Messages;
using Krosmoz.Serialization.D2O.Abstractions;
using Krosmoz.Serialization.Repository;
using Krosmoz.Servers.AuthServer.Network.Transport;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

await Host.CreateDefaultBuilder(args)
    .ConfigureLogging(static logging => logging.UseSerilog())
    .ConfigureServices(static (context, services) =>
    {
        services
            .Configure<TcpServerOptions>(context.Configuration.GetSection("Server"))
            .AddTransient<DofusMessageDecoder>()
            .AddTransient<DofusMessageEncoder>()
            .AddSingleton<IMessageFactory, MessageFactory>()
            .AddSingleton<IDatacenterObjectFactory, DatacenterObjectFactory>()
            .AddSingleton<IDatacenterRepository, DatacenterRepository>()
            .AddMessageHandlers()
            .AddHostedServiceAsSingleton<AuthServer>();
    })
    .RunConsoleAsync();
