// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Core.Events;

/// <summary>
/// Defines a contract for an event subscriber that handles events of a specific type.
/// </summary>
/// <typeparam name="TEvent">The type of event to be handled.</typeparam>
public interface IEventSubscriber<in TEvent>
    where TEvent : class
{
    /// <summary>
    /// Handles the specified event asynchronously.
    /// </summary>
    /// <param name="event">The event to handle. Cannot be null.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task HandleAsync(TEvent @event, CancellationToken cancellationToken);
}
