// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Microsoft.Extensions.DependencyInjection;

namespace Krosmoz.Core.Events;

/// <summary>
/// Represents an event publisher that publishes events to the appropriate subscribers.
/// </summary>
public sealed class EventPublisher : IEventPublisher
{
    private readonly IServiceProvider _services;

    /// <summary>
    /// Initializes a new instance of the <see cref="EventPublisher"/> class.
    /// </summary>
    /// <param name="services">The service provider used to resolve event subscribers.</param>
    public EventPublisher(IServiceProvider services)
    {
        _services = services;
    }

    /// <summary>
    /// Publishes the specified event asynchronously to the appropriate subscriber.
    /// </summary>
    /// <typeparam name="TEvent">The type of event to be published.</typeparam>
    /// <param name="event">The event to publish.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public Task PublishAsync<TEvent>(TEvent @event, CancellationToken cancellationToken)
        where TEvent : class
    {
        return _services.GetRequiredService<IEventSubscriber<TEvent>>().HandleAsync(@event, cancellationToken);
    }
}
