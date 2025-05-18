// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums.Custom;

namespace Krosmoz.Servers.GameServer.Database.Repositories.Breeds;

/// <summary>
/// Defines the contract for a repository that provides access to breed-related data.
/// </summary>
public interface IBreedRepository
{
    /// <summary>
    /// Retrieves the starting spell identifiers for a specific breed.
    /// </summary>
    /// <param name="breedId">The identifier of the breed.</param>
    /// <returns>An enumerable collection of <see cref="SpellIds"/> representing the starting spells for the specified breed.</returns>
    IEnumerable<SpellIds> GetStartSpellIds(BreedIds breedId);
}
