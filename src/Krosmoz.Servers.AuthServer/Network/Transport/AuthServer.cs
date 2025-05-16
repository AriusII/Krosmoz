// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Diagnostics;
using Krosmoz.Core.Network.Transport;
using Krosmoz.Protocol.Messages.Connection;
using Krosmoz.Protocol.Messages.Handshake;
using Krosmoz.Serialization.Constants;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace Krosmoz.Servers.AuthServer.Network.Transport;

/// <summary>
/// Represents the authentication server that manages client connections and communication.
/// </summary>
public sealed class AuthServer : TcpServer<AuthSession>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="AuthServer"/> class.
    /// </summary>
    /// <param name="services">The service provider for resolving dependencies.</param>
    /// <param name="logger">The logger for logging server-related information.</param>
    /// <param name="options">The options for configuring the TCP server.</param>
    public AuthServer(IServiceProvider services, ILogger<TcpServer<AuthSession>> logger, IOptions<TcpServerOptions> options) : base(services, logger, options)
    {
    }

    /// <summary>
    /// Called when the server has started.
    /// </summary>
    /// <returns>A task that represents the asynchronous operation.</returns>
    protected override Task OnServerStartedAsync()
    {
        // TODO: LAUNCH THIS PROCESS IN THE LAUNCHER AND NOT HERE
        Process.Start(PathConstants.Files.DofusExecutablePath, "username=admin password=admin");

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
    }
}
