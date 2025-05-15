// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Core.Services;

/// <summary>
/// Represents a service that requires asynchronous initialization with a specific priority.
/// </summary>
public interface IAsyncOrderedInitializable : IAsyncInitializable
{
    /// <summary>
    /// Gets the priority of the initialization process.
    /// Higher values are initialized earlier.
    /// </summary>
    int Priority { get; }
}
