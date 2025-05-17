// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Servers.GameServer.Services.Breeds;

/// <summary>
/// Defines the contract for a service that provides information about playable breeds.
/// </summary>
public interface IBreedService
{
    /// <summary>
    /// Gets the flags representing the visible breeds.
    /// </summary>
    /// <returns>A short containing the flags for visible breeds.</returns>
    short GetVisibleBreedsFlags();

    /// <summary>
    /// Gets the flags representing the playable breeds.
    /// </summary>
    /// <returns>A short containing the flags for playable breeds.</returns>
    short GetPlayableBreedsFlags();
}
