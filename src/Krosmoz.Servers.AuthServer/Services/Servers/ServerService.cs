// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums;

namespace Krosmoz.Servers.AuthServer.Services.Servers;

/// <summary>
/// Service for managing server-related operations.
/// </summary>
public sealed class ServerService : IServerService
{
    /// <summary>
    /// Updates the status of a server.
    /// </summary>
    /// <param name="serverId">The ID of the server to update.</param>
    /// <param name="status">The new status to set for the server.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result is a boolean indicating
    /// whether the update was successful (<c>true</c>) or not (<c>false</c>).
    /// </returns>
    public Task<bool> UpdateServerStatusAsync(int serverId, ServerStatuses status)
    {
        return Task.FromResult(false);
    }
}
