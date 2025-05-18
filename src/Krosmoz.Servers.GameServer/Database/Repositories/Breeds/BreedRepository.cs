// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Collections.Concurrent;
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

    // Stores breed data indexed by breed identifiers.
    private ConcurrentDictionary<BreedIds, Breed> _breeds;

    /// <summary>
    /// Initializes a new instance of the <see cref="BreedRepository"/> class.
    /// </summary>
    /// <param name="datacenterRepository">The repository for accessing datacenter objects.</param>
    public BreedRepository(IDatacenterRepository datacenterRepository)
    {
        _datacenterRepository = datacenterRepository;
        _breeds = [];
    }

    /// <summary>
    /// Initializes the repository by loading breed data from the datacenter repository.
    /// </summary>
    public void Initialize()
    {
        _breeds = _datacenterRepository.GetObjects<Breed>().ToConcurrentDictionary(static x => (BreedIds)x.Id);
    }

    /// <summary>
    /// Retrieves the starting spell identifiers for a specific breed.
    /// </summary>
    /// <param name="breedId">The identifier of the breed.</param>
    /// <returns>An enumerable collection of <see cref="SpellIds"/> representing the starting spells for the specified breed.</returns>
    public IEnumerable<SpellIds> GetStartSpellIds(BreedIds breedId)
    {
        return _breeds[breedId].BreedSpellsId.Select(static x => (SpellIds)x);
    }
}
