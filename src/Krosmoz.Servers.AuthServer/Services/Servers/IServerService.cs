// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums;
using Krosmoz.Servers.AuthServer.Network.Transport;

namespace Krosmoz.Servers.AuthServer.Services.Servers;

/// <summary>
/// Service interface for managing server-related operations.
/// </summary>
public interface IServerService
{
    /// <summary>
    /// Updates the status of a server asynchronously.
    /// </summary>
    /// <param name="serverId">The unique identifier of the server to update.</param>
    /// <param name="status">The new status to set for the server.</param>
    /// <param name="cancellationToken">A token to signal the operation should be canceled.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result contains a boolean value
    /// indicating whether the server status was successfully updated.
    /// </returns>
    Task<bool> UpdateServerStatusAsync(int serverId, ServerStatuses status, CancellationToken cancellationToken);

    /// <summary>
    /// Handles the operations to be performed when a user is successfully authenticated.
    /// </summary>
    /// <param name="session">The authentication session of the user.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task OnSuccessfullyAuthenticatedAsync(AuthSession session);

    /// <summary>
    /// Selects a game server for the authenticated user.
    /// </summary>
    /// <param name="session">The authentication session of the user.</param>
    /// <param name="serverId">The unique identifier of the server to select.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task SelectGameServerAsync(AuthSession session, int serverId);
}
