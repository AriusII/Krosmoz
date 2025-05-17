// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Diagnostics;
using Krosmoz.Core.Network.Transport;
using Krosmoz.Protocol.Messages.Connection;
using Krosmoz.Protocol.Messages.Handshake;
using Krosmoz.Serialization.Constants;
using Krosmoz.Servers.AuthServer.Services.Queue;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace Krosmoz.Servers.AuthServer.Network.Transport;

/// <summary>
/// Represents the authentication server that manages client connections and communication.
/// </summary>
public sealed class AuthServer : TcpServer<AuthSession>
{
    private readonly IQueueService _queueService;

    /// <summary>
    /// Initializes a new instance of the <see cref="AuthServer"/> class.
    /// </summary>
    /// <param name="services">The service provider for resolving dependencies.</param>
    /// <param name="logger">The logger for logging server-related information.</param>
    /// <param name="options">The options for configuring the TCP server.</param>
    /// <param name="queueService">The queue service for managing session connections.</param>
    public AuthServer(IServiceProvider services, ILogger<TcpServer<AuthSession>> logger, IOptions<TcpServerOptions> options, IQueueService queueService) : base(services, logger, options)
    {
        _queueService = queueService;
    }

    /// <summary>
    /// Called when the server has started.
    /// </summary>
    /// <returns>A task that represents the asynchronous operation.</returns>
    protected override Task OnServerStartedAsync()
    {
        // TODO: LAUNCH THIS PROCESS IN THE LAUNCHER AND NOT HERE
        Process.Start(PathConstants.Files.DofusExecutablePath, "krosmozusername=admin krosmozpassword=admin");
        return base.OnServerStartedAsync();
    }

    /// <summary>
    /// Handles the event when a session is connected to the server.
    /// Sends protocol requirements and a hello connect message to the client.
    /// </summary>
    /// <param name="session">The session that has connected to the server.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    protected override async Task OnSessionConnectedAsync(AuthSession session)
    {
        await session.SendAsync(new ProtocolRequired
        {
            RequiredVersion = MetadataConstants.ProtocolRequiredBuild,
            CurrentVersion = MetadataConstants.ProtocolBuild
        });

        await session.SendAsync(new HelloConnectMessage
        {
            Key = [],
            Salt = string.Empty
        });

        _queueService.Enqueue(session);
    }

    /// <summary>
    /// Handles the event when a session is disconnected from the server.
    /// Removes the session from the queue service and performs base class disconnection logic.
    /// </summary>
    /// <param name="session">The session that has disconnected from the server.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    protected override Task OnSessionDisconnectedAsync(AuthSession session)
    {
        _queueService.Dequeue(session);
        return base.OnSessionDisconnectedAsync(session);
    }
}
