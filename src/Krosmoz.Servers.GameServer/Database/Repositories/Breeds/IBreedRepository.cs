// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Diagnostics.CodeAnalysis;
using Krosmoz.Protocol.Datacenter.Breeds;
using Krosmoz.Protocol.Enums.Custom;

namespace Krosmoz.Servers.GameServer.Database.Repositories.Breeds;

/// <summary>
/// Defines the contract for a repository that provides access to breed-related data.
/// </summary>
public interface IBreedRepository
{
    /// <summary>
    /// Attempts to retrieve breed data for the specified breed ID.
    /// </summary>
    /// <param name="breedId">The ID of the breed to retrieve.</param>
    /// <param name="breed">
    /// When this method returns, contains the breed data if the breed ID exists; otherwise, null.
    /// This parameter is passed uninitialized.
    /// </param>
    /// <returns>
    /// True if the breed data was successfully retrieved; otherwise, false.
    /// </returns>
    bool TryGetBreed(BreedIds breedId, [NotNullWhen(true)] out Breed? breed);

    /// <summary>
    /// Attempts to retrieve head data for the specified cosmetic ID.
    /// </summary>
    /// <param name="cosmeticId">The ID of the cosmetic to retrieve the head data for.</param>
    /// <param name="head">
    /// When this method returns, contains the head data if the cosmetic ID exists; otherwise, null.
    /// This parameter is passed uninitialized.
    /// </param>
    /// <returns>
    /// True if the head data was successfully retrieved; otherwise, false.
    /// </returns>
    bool TryGetHead(int cosmeticId, [NotNullWhen(true)] out Head? head);
}
