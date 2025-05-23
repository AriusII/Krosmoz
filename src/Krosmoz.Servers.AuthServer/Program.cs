using Krosmoz.Core.Extensions;
using Krosmoz.Core.Network.Dispatcher;
using Krosmoz.Core.Network.Factory;
using Krosmoz.Core.Network.Framing;
using Krosmoz.Core.Network.Transport;
using Krosmoz.Core.Scheduling;
using Krosmoz.Core.Services;
using Krosmoz.Infrastructure.ServiceDefaults;
using Krosmoz.Protocol.Datacenter;
using Krosmoz.Protocol.Messages;
using Krosmoz.Serialization.D2O.Abstractions;
using Krosmoz.Serialization.Repository;
using Krosmoz.Servers.AuthServer.Database;
using Krosmoz.Servers.AuthServer.Database.Repositories.Accounts;
using Krosmoz.Servers.AuthServer.Network.Transport;
using Krosmoz.Servers.AuthServer.Services.Authentication;
using Krosmoz.Servers.AuthServer.Services.Nickname;
using Krosmoz.Servers.AuthServer.Services.Servers;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);

builder.Logging.UseSerilog();

builder.AddServiceDefaults()
    .AddNpgsqlDataSource("Auth");

builder.Services
    .Configure<TcpServerOptions>(builder.Configuration.GetSection("Server"))
    .AddDbContext<AuthDbContext>(builder.Configuration.GetConnectionString("Auth"))
    .AddTransient<DofusMessageDecoder>()
    .AddTransient<DofusMessageEncoder>()
    .AddTransient<IScheduler, Scheduler>()
    .AddSingleton<IMessageFactory, MessageFactory>()
    .AddSingleton<IDatacenterObjectFactory, DatacenterObjectFactory>()
    .AddSingleton<IDatacenterRepository, DatacenterRepository>()
    .AddSingleton<IAccountRepository, AccountRepository>()
    .AddSingleton<IServerService, ServerService>()
    .AddSingleton<INicknameService, NicknameService>()
    .AddSingleton<IAuthenticationService, AuthenticationService>()
    .AddInitializableServices()
    .AddHostedServiceAsSingleton<AuthServer>()
    .AddMessageHandlers()
    .AddControllers();

var app = builder.Build();

app.UseAuthorization();
app.MapControllers();

app.Run();
