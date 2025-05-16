using Krosmoz.Core.Extensions;
using Krosmoz.Protocol.Datacenter;
using Krosmoz.Serialization.D2O.Abstractions;
using Krosmoz.Serialization.Repository;
using Krosmoz.Servers.AuthServer.Database;
using Krosmoz.Tools.Database.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

await Host.CreateDefaultBuilder(args)
    .ConfigureLogging(static logging => logging.UseSerilog())
    .ConfigureServices(static (context, services) =>
    {
        services
            .AddDbContext<AuthDbContext>(context.Configuration.GetConnectionString("Auth"))
            .AddSingleton<IDatacenterObjectFactory, DatacenterObjectFactory>()
            .AddSingleton<IDatacenterRepository, DatacenterRepository>()
            .AddHostedService<SynchronizerHostedService>();
    })
    .RunConsoleAsync();
