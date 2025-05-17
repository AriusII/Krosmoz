// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Collections.Concurrent;
using System.Diagnostics.CodeAnalysis;
using Krosmoz.Core.Extensions;
using Krosmoz.Core.Services;
using Krosmoz.Protocol.Enums;
using Krosmoz.Servers.AuthServer.Database.Models.Servers;
using Microsoft.EntityFrameworkCore;

namespace Krosmoz.Servers.AuthServer.Database.Repositories.Servers;

/// <summary>
/// Represents a repository for managing server records in the database.
/// </summary>
public sealed class ServerRepository : IServerRepository, IAsyncInitializableService
{
    private readonly IDbContextFactory<AuthDbContext> _dbContextFactory;
    private ConcurrentDictionary<int, ServerRecord> _servers;

    /// <summary>
    /// Initializes a new instance of the <see cref="ServerRepository"/> class.
    /// </summary>
    /// <param name="dbContextFactory">The factory used to create database contexts.</param>
    public ServerRepository(IDbContextFactory<AuthDbContext> dbContextFactory)
    {
        _dbContextFactory = dbContextFactory;
        _servers = [];
    }

    /// <summary>
    /// Asynchronously initializes the repository by loading server records into memory.
    /// </summary>
    /// <param name="cancellationToken">A token to signal the initialization should be canceled.</param>
    /// <returns>A task that represents the asynchronous initialization operation.</returns>
    public async Task InitializeAsync(CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        _servers = await dbContext.Servers.ToConcurrentDictionaryAsync(static x => x.Id, cancellationToken);
    }

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
    public bool TryGetServerById(int serverId, [NotNullWhen(true)] out ServerRecord? server)
    {
        return _servers.TryGetValue(serverId, out server);
    }

    /// <summary>
    /// Retrieves all visible servers for a specified game hierarchy.
    /// </summary>
    /// <param name="hierarchy">The game hierarchy to filter the visible servers.</param>
    /// <returns>An enumerable collection of visible server records.</returns>
    public IEnumerable<ServerRecord> GetVisibleServers(GameHierarchies hierarchy)
    {
        return _servers.Values.Where(x => x.IpAddress is not null && x.VisibleHierarchy <= hierarchy);
    }

    /// <summary>
    /// Updates the specified server record in the database asynchronously.
    /// </summary>
    /// <param name="server">The server record to update.</param>
    /// <param name="cancellationToken">A token to signal the operation should be canceled.</param>
    /// <returns>A task that represents the asynchronous update operation.</returns>
    public async Task UpdateServerAsync(ServerRecord server, CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        dbContext.Update(server);
        await dbContext.SaveChangesAsync(cancellationToken);
    }
}
