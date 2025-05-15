// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Core.Events;

/// <summary>
/// Defines a contract for an event publisher that publishes events of a specific type.
/// </summary>
public interface IEventPublisher
{
    /// <summary>
    /// Publishes the specified event asynchronously.
    /// </summary>
    /// <typeparam name="TEvent">The type of event to be published.</typeparam>
    /// <param name="event">The event to publish.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task PublishAsync<TEvent>(TEvent @event, CancellationToken cancellationToken)
        where TEvent : class;
}
