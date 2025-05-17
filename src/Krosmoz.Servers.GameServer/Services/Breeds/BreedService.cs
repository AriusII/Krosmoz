// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums;
using Microsoft.Extensions.Configuration;

namespace Krosmoz.Servers.GameServer.Services.Breeds;

/// <summary>
/// Provides services for retrieving information about visible and playable breeds.
/// </summary>
public sealed class BreedService : IBreedService
{
    /// <summary>
    /// The configuration instance used to retrieve breed settings.
    /// </summary>
    private readonly IConfiguration _configuration;

    /// <summary>
    /// Initializes a new instance of the <see cref="BreedService"/> class.
    /// </summary>
    /// <param name="configuration">The configuration instance to retrieve breed settings.</param>
    public BreedService(IConfiguration configuration)
    {
        _configuration = configuration;
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
        return (short)_configuration
            .GetValue<PlayableBreeds[]>("VisibleBreeds")!
            .Aggregate(0, static (current, breed) => current | 1 << (int)breed - 1);
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
        return (short)_configuration
            .GetValue<PlayableBreeds[]>("PlayableBreeds")!
            .Aggregate(0, static (current, breed) => current | 1 << (int)breed - 1);
    }
}
