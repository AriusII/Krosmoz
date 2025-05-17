// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Serialization.Repository;
using Krosmoz.Servers.AuthServer.Database;
using Krosmoz.Servers.GameServer.Database;
using Krosmoz.Tools.Database.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Krosmoz.Tools.Database.Hosting;

/// <summary>
/// Represents a hosted service responsible for synchronizing data using a collection of synchronizers.
/// </summary>
public sealed class SynchronizerHostedService : BackgroundService
{
    private readonly IDbContextFactory<AuthDbContext> _authDbContextFactory;
    private readonly IDbContextFactory<GameDbContext> _gameDbContextFactory;
    private readonly IDatacenterRepository _datacenterRepository;
    private readonly ILoggerFactory _loggerFactory;
    private readonly IHostApplicationLifetime _lifetime;
    private readonly IEnumerable<BaseSynchronizer> _synchronizers;

    /// <summary>
    /// Initializes a new instance of the <see cref="SynchronizerHostedService"/> class.
    /// </summary>
    /// <param name="authDbContextFactory">The factory for creating instances of <see cref="AuthDbContext"/>.</param>
    /// <param name="gameDbContextFactory">The factory for creating instances of <see cref="GameDbContext"/>.</param>
    /// <param name="datacenterRepository">The repository for accessing datacenter data.</param>
    /// <param name="loggerFactory">The factory for creating logger instances.</param>
    /// <param name="lifetime">The application lifetime manager.</param>
    /// <param name="synchronizers">The collection of synchronizers to execute.</param>
    public SynchronizerHostedService(
        IDbContextFactory<AuthDbContext> authDbContextFactory,
        IDbContextFactory<GameDbContext> gameDbContextFactory,
        IDatacenterRepository datacenterRepository,
        ILoggerFactory loggerFactory,
        IHostApplicationLifetime lifetime,
        IEnumerable<BaseSynchronizer> synchronizers)
    {
        _authDbContextFactory = authDbContextFactory;
        _gameDbContextFactory = gameDbContextFactory;
        _datacenterRepository = datacenterRepository;
        _loggerFactory = loggerFactory;
        _synchronizers = synchronizers;
        _lifetime = lifetime;
    }

    /// <summary>
    /// Executes the synchronization process for each synchronizer.
    /// </summary>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    protected override async Task ExecuteAsync(CancellationToken cancellationToken)
    {
        foreach (var synchronizer in _synchronizers)
        {
            var synchronizerName = synchronizer.GetType().Name;

            synchronizer.AuthDbContext = await _authDbContextFactory.CreateDbContextAsync(cancellationToken);
            synchronizer.GameDbContext = await _gameDbContextFactory.CreateDbContextAsync(cancellationToken);

            synchronizer.DatacenterRepository = _datacenterRepository;

            var logger = _loggerFactory.CreateLogger(synchronizerName);

            try
            {
                logger.LogInformation("Synchronizing {SynchronizerName}", synchronizerName);

                await synchronizer.SynchronizeAsync(cancellationToken);

                logger.LogInformation("{SynchronizerName} synchronized successfully", synchronizerName);
            }
            catch (Exception e)
            {
                logger.LogError(e, "Error during synchronization of {SynchronizerName}", synchronizerName);
            }
            finally
            {
                await synchronizer.AuthDbContext.DisposeAsync();
                await synchronizer.GameDbContext.DisposeAsync();
            }
        }

        _lifetime.StopApplication();
    }
}
