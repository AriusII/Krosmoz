// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Collections.Concurrent;
using Krosmoz.Core.Scheduling;
using Krosmoz.Core.Scheduling.Jobs;
using Krosmoz.Core.Services;
using Krosmoz.Protocol.Messages.Queues;
using Krosmoz.Servers.AuthServer.Network.Transport;

namespace Krosmoz.Servers.AuthServer.Services.Queue;

/// <summary>
/// Represents a service that manages a queue of authentication sessions.
/// Implements <see cref="AsyncInitializableService"/> and <see cref="IQueueService"/>.
/// </summary>
public sealed class QueueService : AsyncInitializableService, IQueueService
{
    private readonly ConcurrentDictionary<AuthSession, DateTime> _connectionQueue;
    private readonly IScheduler _scheduler;

    /// <summary>
    /// Initializes a new instance of the <see cref="QueueService"/> class.
    /// </summary>
    /// <param name="scheduler">The scheduler used to manage periodic tasks.</param>
    public QueueService(IScheduler scheduler)
    {
        _scheduler = scheduler;
        _connectionQueue = new ConcurrentDictionary<AuthSession, DateTime>();
    }

    /// <summary>
    /// Adds an authentication session to the queue.
    /// </summary>
    /// <param name="session">The authentication session to enqueue.</param>
    public void Enqueue(AuthSession session)
    {
        _connectionQueue.TryAdd(session, DateTime.UtcNow);
    }

    /// <summary>
    /// Removes an authentication session from the queue.
    /// </summary>
    /// <param name="session">The authentication session to dequeue.</param>
    public void Dequeue(AuthSession session)
    {
        _connectionQueue.TryRemove(session, out _);
    }

    /// <summary>
    /// Sends the current queue status to a specific authentication session.
    /// </summary>
    /// <param name="session">The authentication session to send the status to.</param>
    /// <param name="position">The position of the session in the queue.</param>
    /// <param name="total">The total number of sessions in the queue.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public ValueTask SendQueueStatusAsync(AuthSession session, ushort position, ushort total)
    {
        return session.SendAsync(new LoginQueueStatusMessage
        {
            Position = position,
            Total = total
        });
    }

    /// <summary>
    /// Asynchronously initializes the queue service by scheduling the queue processing job.
    /// </summary>
    /// <param name="cancellationToken">A token to signal the initialization should be canceled.</param>
    /// <returns>A task that represents the asynchronous initialization operation.</returns>
    protected override async Task InitializeAsync(CancellationToken cancellationToken)
    {
        var processQueueJob = Job.CreateBuilder(ProcessQueueAsync)
            .WithName("QueueService::ProcessQueue()")
            .RunAsPeriodically(TimeSpan.FromSeconds(1))
            .Build();

        await _scheduler.EnqueueAsync(processQueueJob);
        await _scheduler.StartAsync();
    }

    /// <summary>
    /// Processes the queue periodically, updating session statuses and removing disconnected sessions.
    /// </summary>
    /// <param name="cancellationToken">A token to signal the operation should be canceled.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    private async Task ProcessQueueAsync(CancellationToken cancellationToken)
    {
        var queue = _connectionQueue.ToArray();

        for (var index = 0; index < queue.Length; index++)
        {
            var (session, enterQueueTime) = queue[index];

            if (!session.IsConnected)
            {
                Dequeue(session);
                continue;
            }

            if (DateTime.UtcNow - enterQueueTime >= TimeSpan.FromSeconds(30))
            {
                Dequeue(session);
                await session.DisconnectAsync();
                continue;
            }

            await SendQueueStatusAsync(session, (ushort)(index + 1), (ushort)queue.Length);
        }
    }
}
