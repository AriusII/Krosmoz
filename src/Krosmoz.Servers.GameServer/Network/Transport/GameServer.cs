// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Network.Transport;
using Krosmoz.Protocol.Messages.Game.Approach;
using Krosmoz.Protocol.Messages.Handshake;
using Krosmoz.Serialization.Constants;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace Krosmoz.Servers.GameServer.Network.Transport;

/// <summary>
/// Represents the GameServer class, which is responsible for managing the network transport
/// and communication for the game server using TCP connections.
/// </summary>
public sealed class GameServer : TcpServer<GameSession>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="GameServer"/> class.
    /// </summary>
    /// <param name="services">The service provider for resolving dependencies.</param>
    /// <param name="logger">The logger used for logging server-related events.</param>
    /// <param name="options">The options for configuring the TCP server.</param>
    public GameServer(IServiceProvider services, ILogger<TcpServer<GameSession>> logger, IOptions<TcpServerOptions> options)
        : base(services, logger, options)
    {
    }

    /// <summary>
    /// Handles the event when a new session is connected to the server.
    /// Sends the required protocol version and a hello message to the client.
    /// </summary>
    /// <param name="session">The session that has connected.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    protected override async Task OnSessionConnectedAsync(GameSession session)
    {
        await session.SendAsync(new ProtocolRequired { RequiredVersion = MetadataConstants.ProtocolRequiredBuild, CurrentVersion = MetadataConstants.ProtocolBuild });
        await session.SendAsync<HelloGameMessage>();
    }
}
