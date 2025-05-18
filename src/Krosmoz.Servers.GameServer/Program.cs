
using Krosmoz.Core.Extensions;
using Krosmoz.Core.Network.Dispatcher;
using Krosmoz.Core.Network.Factory;
using Krosmoz.Core.Network.Framing;
using Krosmoz.Core.Network.Transport;
using Krosmoz.Core.Scheduling;
using Krosmoz.Core.Services;
using Krosmoz.Protocol.Datacenter;
using Krosmoz.Protocol.Messages;
using Krosmoz.Serialization.D2O.Abstractions;
using Krosmoz.Serialization.Repository;
using Krosmoz.Servers.GameServer.Database;
using Krosmoz.Servers.GameServer.Database.Repositories.Characters;
using Krosmoz.Servers.GameServer.Factories.Characters;
using Krosmoz.Servers.GameServer.Network.Transport;
using Krosmoz.Servers.GameServer.Services.Authentication;
using Krosmoz.Servers.GameServer.Services.Breeds;
using Krosmoz.Servers.GameServer.Services.Characters.Creation;
using Krosmoz.Servers.GameServer.Services.Characters.Creation.NameGeneration;
using Krosmoz.Servers.GameServer.Services.Characters.Deletion;
using Krosmoz.Servers.GameServer.Services.Characters.Selection;
using Krosmoz.Servers.GameServer.Services.Game;
using Krosmoz.Servers.GameServer.Services.Ipc;
using Krosmoz.Servers.GameServer.Services.OptionalFeatures;
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
            .AddSingleton<IBreedService, BreedService>()
            .AddSingleton<IOptionalFeatureService, OptionalFeatureService>()
            .AddSingleton<IGameService, GameService>()
            .AddSingleton<IIpcService, IpcService>()
            .AddSingleton<IAuthenticationService, AuthenticationService>()
            .AddSingleton<ICharacterFactory, CharacterFactory>()
            .AddSingleton<ICharacterNameGenerationService, CharacterNameGenerationService>()
            .AddSingleton<ICharacterCreationService, CharacterCreationService>()
            .AddSingleton<ICharacterRepository, CharacterRepository>()
            .AddSingleton<ICharacterSelectionService, CharacterSelectionService>()
            .AddSingleton<ICharacterDeletionService, CharacterDeletionService>()
            .AddHostedServiceAsSingleton<GameServer>()
            .AddMessageHandlers()
            .AddInitializableServices();
    })
    .RunConsoleAsync();
