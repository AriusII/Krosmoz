// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Network.Dispatcher.Attributes;
using Krosmoz.Protocol.Messages.Connection;
using Krosmoz.Servers.AuthServer.Network.Transport;
using Krosmoz.Servers.AuthServer.Services.Servers;

namespace Krosmoz.Servers.AuthServer.Handlers.Servers;

/// <summary>
/// Handles server selection-related requests.
/// Provides methods to process server selection requests from clients.
/// </summary>
public sealed class ServerHandler
{
    private readonly IServerService _serverService;

    /// <summary>
    /// Initializes a new instance of the <see cref="ServerHandler"/> class.
    /// </summary>
    /// <param name="serverService">Service for handling server-related logic.</param>
    public ServerHandler(IServerService serverService)
    {
        _serverService = serverService;
    }

    /// <summary>
    /// Handles the server selection request from the client.
    /// </summary>
    /// <param name="session">The authentication session of the client making the request.</param>
    /// <param name="message">The server selection request message containing the server ID.</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    [MessageHandler]
    public Task HandleServerSelectionAsync(AuthSession session, ServerSelectionMessage message)
    {
        return _serverService.SelectGameServerAsync(session, message.ServerId);
    }
}
