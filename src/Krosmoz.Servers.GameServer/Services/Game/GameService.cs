// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Datacenter.Servers;
using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Protocol.Messages.Authorized;
using Krosmoz.Protocol.Messages.Game.Approach;
using Krosmoz.Protocol.Messages.Secure;
using Krosmoz.Protocol.Types.Game.Approach;
using Krosmoz.Serialization.Constants;
using Krosmoz.Serialization.Repository;
using Krosmoz.Servers.GameServer.Network.Transport;
using Krosmoz.Servers.GameServer.Services.Breeds;
using Krosmoz.Servers.GameServer.Services.OptionalFeatures;
using Microsoft.Extensions.Configuration;

namespace Krosmoz.Servers.GameServer.Services.Game;

/// <summary>
/// Provides functionality to manage and send server-related information.
/// </summary>
public sealed class GameService : IGameService
{
    private readonly IOptionalFeatureService _optionalFeatureService;
    private readonly IBreedService _breedService;
    private readonly Server _server;

    /// <summary>
    /// Gets the unique identifier of the server.
    /// </summary>
    public int ServerId =>
        _server.Id;

    /// <summary>
    /// Gets the type of the server, indicating its game mode or purpose.
    /// </summary>
    public ServerGameTypeIds ServerType =>
        (ServerGameTypeIds)_server.GameTypeId;

    /// <summary>
    /// Initializes a new instance of the <see cref="GameService"/> class.
    /// </summary>
    /// <param name="optionalFeatureService">The service for managing optional features.</param>
    /// <param name="breedService">The service for managing breed-related information.</param>
    /// <param name="datacenterRepository">The repository for accessing datacenter objects.</param>
    /// <param name="configuration">The configuration instance for retrieving server settings.</param>
    public GameService(IOptionalFeatureService optionalFeatureService, IBreedService breedService, IDatacenterRepository datacenterRepository, IConfiguration configuration)
    {
        _optionalFeatureService = optionalFeatureService;
        _breedService = breedService;
        _server = datacenterRepository.GetObjects<Server>().First(x => x.Id == configuration.GetValue<int>("ServerId"));
    }

    /// <summary>
    /// Sends various server-related information asynchronously to the specified game session.
    /// </summary>
    /// <param name="session">The game session to which the information will be sent.</param>
    public async Task SendServerInfomationsAsync(GameSession session)
    {
        await SendServerSettingsAsync(session);
        await SendServerOptionalFeaturesAsync(session);
        await SendServerSessionConstantsAsync(session);
        await SendAccountCapabilitiesAsync(session);
        await SendTrustStatusAsync(session);
        await SendConsoleCommandListAsync(session);
    }

    /// <summary>
    /// Sends server settings information asynchronously to the specified game session.
    /// </summary>
    /// <param name="session">The game session to which the settings will be sent.</param>
    private async Task SendServerSettingsAsync(GameSession session)
    {
        await session.SendAsync(new ServerSettingsMessage
        {
            Community = (sbyte)_server.CommunityId,
            Lang = _server.Language,
            GameType = (sbyte)_server.GameTypeId
        });
    }

    /// <summary>
    /// Sends the list of enabled optional features asynchronously to the specified game session.
    /// </summary>
    /// <param name="session">The game session to which the features will be sent.</param>
    private async Task SendServerOptionalFeaturesAsync(GameSession session)
    {
        await session.SendAsync(new ServerOptionalFeaturesMessage { Features = _optionalFeatureService.GetEnabledFeatures().Select(static x => (short)x) });
    }

    /// <summary>
    /// Sends server session constants asynchronously to the specified game session.
    /// </summary>
    /// <param name="session">The game session to which the constants will be sent.</param>
    private static async Task SendServerSessionConstantsAsync(GameSession session)
    {
        await session.SendAsync(new ServerSessionConstantsMessage
        {
            Variables =
            [
                new ServerSessionConstantInteger { Id = ServerSessionConstants.TimeBeforeDisconnection, Value = (int)TimeSpan.FromMinutes(5).TotalMilliseconds }
            ]
        });
    }

    /// <summary>
    /// Sends account capabilities information asynchronously to the specified game session.
    /// </summary>
    /// <param name="session">The game session to which the account capabilities will be sent.</param>
    private async Task SendAccountCapabilitiesAsync(GameSession session)
    {
        await session.SendAsync(new AccountCapabilitiesMessage
        {
            AccountId = session.Account.Id,
            Status = (sbyte)session.Account.Hierarchy,
            TutorialAvailable = true,
            BreedsVisible = _breedService.GetVisibleBreedsFlags(),
            BreedsAvailable = _breedService.GetPlayableBreedsFlags()
        });
    }

    /// <summary>
    /// Sends trust status information asynchronously to the specified game session.
    /// </summary>
    /// <param name="session">The game session to which the trust status will be sent.</param>
    private static async Task SendTrustStatusAsync(GameSession session)
    {
        await session.SendAsync(new TrustStatusMessage { Trusted = true });
    }

    /// <summary>
    /// Sends the list of console commands asynchronously to the specified game session.
    /// </summary>
    /// <param name="session">The game session to which the console commands will be sent.</param>
    private static async Task SendConsoleCommandListAsync(GameSession session)
    {
        if (!session.Account.HasRights)
            return;

        // TODO: Add console commands
        await session.SendAsync(new ConsoleCommandsListMessage
        {
            Aliases = [],
            Arguments = [],
            Descriptions = []
        });
    }
}
