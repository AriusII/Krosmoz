// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Collections.Frozen;
using Krosmoz.Protocol.Enums;
using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Servers.GameServer.Database.Models.Characters;
using Microsoft.Extensions.Configuration;

namespace Krosmoz.Servers.GameServer.Services.Breeds;

/// <summary>
/// Provides services for retrieving information about visible and playable breeds.
/// </summary>
public sealed class BreedService : IBreedService
{
    private readonly PlayableBreeds[] _visibleBreeds;
    private readonly PlayableBreeds[] _playableBreeds;
    private readonly FrozenDictionary<BreedIds, CharacterPosition> _spawnPositions;

    /// <summary>
    /// Initializes a new instance of the <see cref="BreedService"/> class.
    /// </summary>
    /// <param name="configuration">The configuration instance to retrieve breed settings.</param>
    public BreedService(IConfiguration configuration)
    {
        _visibleBreeds = configuration.GetValue<PlayableBreeds[]>("VisibleBreeds")!;
        _playableBreeds = configuration.GetValue<PlayableBreeds[]>("PlayableBreeds")!;
        _spawnPositions = configuration.GetValue<Dictionary<BreedIds, CharacterPosition>>("SpawnBreedPositions")!.ToFrozenDictionary();
    }

    /// <summary>
    /// Retrieves the flags representing the visible breeds.
    /// </summary>
    /// <returns>
    /// A 16-bit signed integer containing the flags for visible breeds.
    /// Each bit represents a specific breed.
    /// </returns>
    public short GetVisibleBreedsFlags()
    {
        return (short)_visibleBreeds.Aggregate(0, static (current, breed) => current | 1 << (int)breed - 1);
    }

    /// <summary>
    /// Retrieves the flags representing the playable breeds.
    /// </summary>
    /// <returns>
    /// A 16-bit signed integer containing the flags for playable breeds.
    /// Each bit represents a specific breed.
    /// </returns>
    public short GetPlayableBreedsFlags()
    {
        return (short)_playableBreeds.Aggregate(0, static (current, breed) => current | 1 << (int)breed - 1);
    }

    /// <summary>
    /// Retrieves the spawn position for a character of the specified breed.
    /// </summary>
    /// <param name="breed">The breed identifier for which to retrieve the spawn position.</param>
    /// <returns>A <see cref="CharacterPosition"/> object representing the spawn position for the specified breed.</returns>
    public CharacterPosition GetSpawnPosition(BreedIds breed)
    {
        return _spawnPositions[breed];
    }
}
