// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Servers.GameServer.Database.Models.Characters;

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

    /// <summary>
    /// Retrieves the spawn position for a character of the specified breed.
    /// </summary>
    /// <param name="breed">The breed identifier for which to retrieve the spawn position.</param>
    /// <returns>A <see cref="CharacterPosition"/> object representing the spawn position for the specified breed.</returns>
    CharacterPosition GetSpawnPosition(BreedIds breed);
}
