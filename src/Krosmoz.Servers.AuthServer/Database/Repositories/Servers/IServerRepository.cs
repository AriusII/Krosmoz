// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Diagnostics.CodeAnalysis;
using Krosmoz.Protocol.Enums;
using Krosmoz.Servers.AuthServer.Database.Models.Servers;

namespace Krosmoz.Servers.AuthServer.Database.Repositories.Servers;

/// <summary>
/// Represents a repository for managing server records in the database.
/// </summary>
public interface IServerRepository
{
    /// <summary>
    /// Attempts to retrieve a server record by its unique identifier.
    /// </summary>
    /// <param name="serverId">The unique identifier of the server.</param>
    /// <param name="server">
    /// When this method returns, contains the server record associated with the specified identifier,
    /// if the server is found; otherwise, null.
    /// </param>
    /// <returns>
    /// True if the server record is found; otherwise, false.
    /// </returns>
    bool TryGetServerById(int serverId, [NotNullWhen(true)] out ServerRecord? server);

    /// <summary>
    /// Retrieves all visible servers for a specified game hierarchy.
    /// </summary>
    /// <param name="hierarchy">The game hierarchy to filter the visible servers.</param>
    /// <returns>An enumerable collection of visible server records.</returns>
    IEnumerable<ServerRecord> GetVisibleServers(GameHierarchies hierarchy);

    /// <summary>
    /// Updates the specified server record in the database asynchronously.
    /// </summary>
    /// <param name="server">The server record to update.</param>
    /// <param name="cancellationToken">A token to signal the operation should be canceled.</param>
    /// <returns>A task that represents the asynchronous update operation.</returns>
    Task UpdateServerAsync(ServerRecord server, CancellationToken cancellationToken);
}
