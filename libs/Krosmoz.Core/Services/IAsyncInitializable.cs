// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Core.Services;

/// <summary>
/// Defines a contract for a service that requires asynchronous initialization.
/// </summary>
public interface IAsyncInitializable
{
    /// <summary>
    /// Performs the asynchronous initialization logic for the service.
    /// </summary>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous initialization operation.</returns>
    Task InitializeAsync(CancellationToken cancellationToken);
}
