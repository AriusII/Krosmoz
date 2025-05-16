// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Diagnostics.CodeAnalysis;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace Krosmoz.Core.Extensions;

/// <summary>
/// Provides extension methods for configuring services in an <see cref="IServiceCollection"/>.
/// </summary>
public static class ServiceCollectionExtensions
{
    /// <summary>
    /// Adds a hosted service as a singleton to the service collection.
    /// </summary>
    /// <typeparam name="T">The type of the hosted service to add.</typeparam>
    /// <param name="services">The service collection to add the hosted service to.</param>
    /// <returns>The updated service collection.</returns>
    public static IServiceCollection AddHostedServiceAsSingleton<[DynamicallyAccessedMembers(DynamicallyAccessedMemberTypes.PublicConstructors)] T>(this IServiceCollection services)
        where T : class, IHostedService
    {
        return services
            .AddSingleton<T>()
            .AddHostedService(static x => x.GetRequiredService<T>());
    }

    /// <summary>
    /// Adds a hosted service with a specific implementation as a singleton to the service collection.
    /// </summary>
    /// <typeparam name="TService">The interface type of the hosted service.</typeparam>
    /// <typeparam name="TImplementation">The implementation type of the hosted service.</typeparam>
    /// <param name="services">The service collection to add the hosted service to.</param>
    /// <returns>The updated service collection.</returns>
    public static IServiceCollection AddHostedServiceAsSingleton<TService, [DynamicallyAccessedMembers(DynamicallyAccessedMemberTypes.PublicConstructors)] TImplementation>(this IServiceCollection services)
        where TService : class, IHostedService
        where TImplementation : class, TService
    {
        return services
            .AddSingleton<TService, TImplementation>()
            .AddHostedService(static x => x.GetRequiredService<TService>());
    }
}
