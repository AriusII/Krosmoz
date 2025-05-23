using Krosmoz.Core.Extensions;
using Krosmoz.Infrastructure.ServiceDefaults;
using Krosmoz.Protocol.Datacenter;
using Krosmoz.Serialization.D2O.Abstractions;
using Krosmoz.Serialization.Repository;
using Krosmoz.Servers.AuthServer.Database;
using Krosmoz.Servers.GameServer.Database;
using Krosmoz.Tools.Database.Hosting;
using Krosmoz.Tools.Database.Synchronizers.Base;
using Krosmoz.Tools.Database.Synchronizers.Experiences;
using Krosmoz.Tools.Database.Synchronizers.Maps;
using Krosmoz.Tools.Database.Synchronizers.Servers;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = Host.CreateApplicationBuilder(args);

builder.AddServiceDefaults()
    .AddNpgsqlDataSource("Game");

builder.Logging.UseSerilog();

builder.Services
            .AddDbContext<AuthDbContext>(builder.Configuration.GetConnectionString("Auth"))
            .AddDbContext<GameDbContext>(builder.Configuration.GetConnectionString("Game"))
            .AddSingleton<IDatacenterObjectFactory, DatacenterObjectFactory>()
            .AddSingleton<IDatacenterRepository, DatacenterRepository>()
            .AddSingleton<BaseSynchronizer, ServerSynchronizer>()
            .AddSingleton<BaseSynchronizer, MapSynchronizer>()
            .AddSingleton<BaseSynchronizer, ExperienceSynchronizer>()
            .AddHostedService<SynchronizerHostedService>();

builder.Build().Run();
