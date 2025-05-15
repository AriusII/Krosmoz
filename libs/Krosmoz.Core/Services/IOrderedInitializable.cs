// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Core.Services;

/// <summary>
/// Defines a contract for a service that requires initialization with a specific priority.
/// </summary>
public interface IOrderedInitializable : IInitializable
{
    /// <summary>
    /// Gets the priority of the initialization process.
    /// Higher priority values are initialized earlier.
    /// </summary>
    int Priority { get; }
}
