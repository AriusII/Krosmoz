// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Microsoft.Extensions.Hosting;

namespace Krosmoz.Core.Services;

/// <summary>
/// Represents an abstract base class for services that require ordered asynchronous initialization and execution.
/// Implements the <see cref="IHostedService"/> interface and provides a mechanism for cleanup through <see cref="IDisposable"/>.
/// </summary>
public abstract class OrderedAsyncInitializableService : IHostedService, IDisposable
{
    private CancellationTokenSource? _cts;
    private Task? _executeTask;

    /// <summary>
    /// Gets the order in which the service should be initialized.
    /// </summary>
    public abstract int Order { get; }

    /// <summary>
    /// Starts the service asynchronously.
    /// </summary>
    /// <param name="cancellationToken">A token to signal the start operation should be canceled.</param>
    /// <returns>A task that represents the asynchronous start operation.</returns>
    public virtual Task StartAsync(CancellationToken cancellationToken)
    {
        _cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);

        _executeTask = InitializeAsync(_cts.Token);

        return _executeTask.IsCompleted
            ? _executeTask
            : Task.CompletedTask;
    }

    /// <summary>
    /// Stops the service asynchronously.
    /// </summary>
    /// <param name="cancellationToken">A token to signal the stop operation should be canceled.</param>
    /// <returns>A task that represents the asynchronous stop operation.</returns>
    public virtual async Task StopAsync(CancellationToken cancellationToken)
    {
        if (_executeTask is null)
            return;

        try
        {
            await _cts!.CancelAsync().ConfigureAwait(false);
        }
        finally
        {
            await _executeTask.WaitAsync(_cts!.Token).ConfigureAwait(false);
        }
    }

    /// <summary>
    /// Disposes the resources used by the service.
    /// </summary>
    public virtual void Dispose()
    {
        _cts?.Dispose();
        GC.SuppressFinalize(this);
    }

    /// <summary>
    /// Asynchronously initializes the service. This method must be implemented by derived classes.
    /// </summary>
    /// <param name="cancellationToken">A token to signal the initialization should be canceled.</param>
    /// <returns>A task that represents the asynchronous initialization of the service.</returns>
    protected abstract Task InitializeAsync(CancellationToken cancellationToken);
}
