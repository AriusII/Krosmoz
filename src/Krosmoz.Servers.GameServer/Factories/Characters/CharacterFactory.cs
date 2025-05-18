// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums;
using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Servers.GameServer.Database.Models.Characters;
using Krosmoz.Servers.GameServer.Database.Repositories.Breeds;
using Krosmoz.Servers.GameServer.Models.Accounts;
using Krosmoz.Servers.GameServer.Models.Appearances;
using Krosmoz.Servers.GameServer.Services.Breeds;

namespace Krosmoz.Servers.GameServer.Factories.Characters;

/// <summary>
/// Factory for creating character records in the game.
/// Provides methods to initialize and configure new characters.
/// </summary>
public sealed class CharacterFactory : ICharacterFactory
{
    private readonly IBreedService _breedService;
    private readonly IBreedRepository _breedRepository;

    /// <summary>
    /// Initializes a new instance of the <see cref="CharacterFactory"/> class.
    /// </summary>
    /// <param name="breedService">Service for retrieving breed-related data.</param>
    /// <param name="breedRepository">Repository for accessing breed data.</param>
    public CharacterFactory(IBreedService breedService, IBreedRepository breedRepository)
    {
        _breedService = breedService;
        _breedRepository = breedRepository;
    }

    /// <summary>
    /// Creates a new character record with the specified parameters.
    /// </summary>
    /// <param name="name">The name of the character to create.</param>
    /// <param name="account">The account associated with the character.</param>
    /// <param name="breedId">The breed ID of the character.</param>
    /// <param name="headId">The ID of the character's head appearance.</param>
    /// <param name="sex">The sex of the character.</param>
    /// <param name="actorLook">The visual appearance of the character.</param>
    /// <returns>A new <see cref="CharacterRecord"/> representing the created character.</returns>
    public CharacterRecord CreateCharacterRecord(string name, Account account, BreedIds breedId, int headId, bool sex, ActorLook actorLook)
    {
        var position = _breedService.GetSpawnPosition(breedId);

        var breedSpells = _breedRepository.GetStartSpellIds(breedId);

        return new CharacterRecord
        {
            Name = name,
            AccountId = account.Id,
            Experience = 0,
            Breed = breedId,
            Sex = sex,
            Status = PlayerStatuses.PlayerStatusOffline,
            Look = actorLook,
            Kamas = 0,
            Emotes = [EmoticonIds.Sasseoir],
            Spells = [SpellIds.CoupDePoing, ..breedSpells],
            Level = 1,
            Position = position,
            Head = headId,
            DeathCount = 0,
            DeathMaxLevel = 0,
            DeathState = HardcoreDeathStates.DeathStateAlive,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };
    }
}
