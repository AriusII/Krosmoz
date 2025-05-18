// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Protocol.Messages.Game.Character.Choice;
using Krosmoz.Protocol.Types.Game.Character.Choice;
using Krosmoz.Servers.GameServer.Database.Repositories.Characters;
using Krosmoz.Servers.GameServer.Models.Accounts;
using Krosmoz.Servers.GameServer.Network.Transport;
using Krosmoz.Servers.GameServer.Services.Game;

namespace Krosmoz.Servers.GameServer.Services.Character.Selection;

/// <summary>
/// Provides functionality for character selection, including sending the list of available characters to a game session.
/// </summary>
public sealed class CharacterSelectionService : ICharacterSelectionService
{
    private readonly ICharacterRepository _characterRepository;
    private readonly IGameService _gameService;

    /// <summary>
    /// Initializes a new instance of the <see cref="CharacterSelectionService"/> class.
    /// </summary>
    /// <param name="characterRepository">The repository for managing character data.</param>
    /// <param name="gameService">The service providing information about the current server.</param>
    public CharacterSelectionService(ICharacterRepository characterRepository, IGameService gameService)
    {
        _characterRepository = characterRepository;
        _gameService = gameService;
    }

    /// <summary>
    /// Sends the list of available characters to the specified game session asynchronously.
    /// </summary>
    /// <param name="session">The game session to which the character list will be sent.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task SendCharactersListAsync(GameSession session)
    {
        if (session.Account.Characters.Count is 0)
        {
            await session.SendAsync(new CharactersListMessage { Characters = [], HasStartupActions = false });
            return;
        }

        // TODO: Reconnect on fight

        var characters = await GetCharacterBaseInformationsAsync(session, session.Account.Characters);

        // TODO: Handle characters to recolor, relook, rename, unusable characters and startup actions
        await session.SendAsync(new CharactersListWithModificationsMessage
        {
            Characters = characters,
            HasStartupActions = false,
            CharactersToRecolor = [],
            CharactersToRelook = [],
            CharactersToRename = [],
            UnusableCharacters = []
        });
    }

    /// <summary>
    /// Retrieves the base information for a list of characters asynchronously.
    /// </summary>
    /// <param name="session">The game session for which the character information is being retrieved.</param>
    /// <param name="accountCharacters">The list of server characters to retrieve information for.</param>
    /// <returns>A task that represents the asynchronous operation, containing a collection of character base information.</returns>
    private async Task<IEnumerable<CharacterBaseInformations>> GetCharacterBaseInformationsAsync(GameSession session, IEnumerable<AccountCharacter> accountCharacters)
    {
        var characters = new List<CharacterBaseInformations>();

        foreach (var character in accountCharacters)
        {
            var characterRecord = await _characterRepository.GetCharacterByIdAsync(character.CharacterId, session.ConnectionClosed);

            if (characterRecord is null)
                continue;

            if (characterRecord.DeletedAt.HasValue)
                continue;

            if (_gameService.ServerType is ServerGameTypeIds.ServeurHeroique)
            {
                characters.Add(new CharacterHardcoreInformations
                {
                    Id = (int)characterRecord.Id,
                    Breed = (sbyte)characterRecord.Breed,
                    Name = characterRecord.Name,
                    Sex = characterRecord.Sex,
                    EntityLook = characterRecord.Look.GetEntityLook(),
                    Level = characterRecord.Level,
                    DeathCount = characterRecord.DeathCount,
                    DeathMaxLevel = characterRecord.DeathMaxLevel,
                    DeathState = (sbyte)characterRecord.DeathState
                });
            }
            else
            {
                characters.Add(new CharacterBaseInformations
                {
                    Id = (int)characterRecord.Id,
                    Breed = (sbyte)characterRecord.Breed,
                    Name = characterRecord.Name,
                    Sex = characterRecord.Sex,
                    EntityLook = characterRecord.Look.GetEntityLook(),
                    Level = characterRecord.Level,
                });
            }
        }

        return characters;
    }

    /// <summary>
    /// Selects a character for the specified game session asynchronously.
    /// </summary>
    /// <param name="session">The game session for which the character is being selected.</param>
    /// <param name="characterId">The ID of the character to select.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task SelectCharacterAsync(GameSession session, long characterId)
    {
        var characterRecord = await _characterRepository.GetCharacterByIdAsync(characterId, session.ConnectionClosed);

        if (characterRecord is null)
        {
            await session.SendAsync<CharacterSelectedErrorMessage>();
            return;
        }

        if (characterRecord.DeletedAt.HasValue)
        {
            await session.SendAsync<CharacterSelectedErrorMessage>();
            return;
        }

        // TODO: Handle reconnect
    }
}
