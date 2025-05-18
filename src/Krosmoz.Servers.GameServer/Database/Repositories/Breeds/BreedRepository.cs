// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Collections.Concurrent;
using System.Diagnostics.CodeAnalysis;
using Krosmoz.Core.Extensions;
using Krosmoz.Core.Services;
using Krosmoz.Protocol.Datacenter.Breeds;
using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Serialization.Repository;

namespace Krosmoz.Servers.GameServer.Database.Repositories.Breeds;

/// <summary>
/// Repository for managing breed-related data in the game.
/// Provides methods to retrieve and initialize breed data.
/// </summary>
public sealed class BreedRepository : IBreedRepository, IInitializableService
{
    private readonly IDatacenterRepository _datacenterRepository;

    private ConcurrentDictionary<BreedIds, Breed> _breeds;
    private ConcurrentDictionary<int, Head> _heads;

    /// <summary>
    /// Initializes a new instance of the <see cref="BreedRepository"/> class.
    /// </summary>
    /// <param name="datacenterRepository">The repository for accessing datacenter objects.</param>
    public BreedRepository(IDatacenterRepository datacenterRepository)
    {
        _datacenterRepository = datacenterRepository;
        _breeds = [];
        _heads = [];
    }

    /// <summary>
    /// Initializes the repository by loading breed data from the datacenter repository.
    /// </summary>
    public void Initialize()
    {
        _breeds = _datacenterRepository.GetObjects<Breed>().ToConcurrentDictionary(static x => (BreedIds)x.Id);
        _heads = _datacenterRepository.GetObjects<Head>().ToConcurrentDictionary(static x => x.Id);
    }

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
    public bool TryGetBreed(BreedIds breedId, [NotNullWhen(true)] out Breed? breed)
    {
        return _breeds.TryGetValue(breedId, out breed);
    }

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
    public bool TryGetHead(int cosmeticId, [NotNullWhen(true)] out Head? head)
    {
        return _heads.TryGetValue(cosmeticId, out head);
    }
}
