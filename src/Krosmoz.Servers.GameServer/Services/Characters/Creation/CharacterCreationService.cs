// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Diagnostics.CodeAnalysis;
using System.Drawing;
using System.Text.RegularExpressions;
using Krosmoz.Protocol.Datacenter.Breeds;
using Krosmoz.Protocol.Enums;
using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Protocol.Messages.Game.Character.Creation;
using Krosmoz.Servers.GameServer.Database.Repositories.Breeds;
using Krosmoz.Servers.GameServer.Database.Repositories.Characters;
using Krosmoz.Servers.GameServer.Factories.Characters;
using Krosmoz.Servers.GameServer.Models.Accounts;
using Krosmoz.Servers.GameServer.Models.Appearances;
using Krosmoz.Servers.GameServer.Network.Transport;
using Krosmoz.Servers.GameServer.Services.Characters.Creation.NameGeneration;
using Krosmoz.Servers.GameServer.Services.Characters.Selection;
using Krosmoz.Servers.GameServer.Services.Game;
using Krosmoz.Servers.GameServer.Services.Ipc;

namespace Krosmoz.Servers.GameServer.Services.Characters.Creation;

/// <summary>
/// Provides functionality for character creation.
/// </summary>
public sealed partial class CharacterCreationService : ICharacterCreationService
{
    private const int MaxCharactersCount = 5;

    private readonly ICharacterNameGenerationService _characterNameGenerationService;
    private readonly IGameService _gameService;
    private readonly IBreedRepository _breedRepository;
    private readonly ICharacterFactory _characterFactory;
    private readonly ICharacterRepository _characterRepository;
    private readonly ICharacterSelectionService _characterSelectionService;
    private readonly IIpcService _ipcService;

    /// <summary>
    /// Initializes a new instance of the <see cref="CharacterCreationService"/> class.
    /// </summary>
    /// <param name="characterNameGenerationService">The service used for generating character names.</param>
    /// <param name="gameService">The service providing information about the current server.</param>
    /// <param name="breedRepository">The repository for retrieving breed data.</param>
    /// <param name="characterFactory">The factory for creating character records.</param>
    /// <param name="characterRepository">The repository for managing character data.</param>
    /// <param name="characterSelectionService">The service for selecting characters.</param>
    /// <param name="ipcService">The inter-process communication service for handling character-related operations.</param>
    public CharacterCreationService(
        ICharacterNameGenerationService characterNameGenerationService,
        IGameService gameService,
        IBreedRepository breedRepository,
        ICharacterFactory characterFactory,
        ICharacterRepository characterRepository,
        ICharacterSelectionService characterSelectionService,
        IIpcService ipcService)
    {
        _characterNameGenerationService = characterNameGenerationService;
        _gameService = gameService;
        _breedRepository = breedRepository;
        _characterFactory = characterFactory;
        _characterRepository = characterRepository;
        _characterSelectionService = characterSelectionService;
        _ipcService = ipcService;
    }

    /// <summary>
    /// Sends a randomly generated character name to the specified game session asynchronously.
    /// </summary>
    /// <param name="session">The game session to which the random character name will be sent.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task SendRandomCharacterNameAsync(GameSession session)
    {
        await session.SendAsync(new CharacterNameSuggestionSuccessMessage { Suggestion = _characterNameGenerationService.GenerateName() });
    }

    /// <summary>
    /// Creates a new character asynchronously with the specified attributes.
    /// </summary>
    /// <param name="session">The game session for which the character is being created.</param>
    /// <param name="name">The name of the character to be created.</param>
    /// <param name="breedId">The breed of the character.</param>
    /// <param name="sex">The sex of the character.</param>
    /// <param name="colors">An array of colors representing the character's appearance.</param>
    /// <param name="cosmeticId">The ID of the cosmetic appearance for the character.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task CreateCharacterAsync(GameSession session, string name, BreedIds breedId, bool sex, IList<int> colors, int cosmeticId)
    {
        if (!CanCreateNewCharacter(session))
        {
            await SendCharacterCreationResultAsync(session, CharacterCreationResults.ErrTooManyCharacters);
            return;
        }

        if (!CanRetrieveBreed(breedId, out var breed))
        {
            await SendCharacterCreationResultAsync(session, CharacterCreationResults.ErrNotAllowed);
            return;
        }

        if (!CanRetrieveHead(cosmeticId, out var head))
        {
            await SendCharacterCreationResultAsync(session, CharacterCreationResults.ErrNotAllowed);
            return;
        }

        if (!CanUseHead(head, breedId, sex))
        {
            await SendCharacterCreationResultAsync(session, CharacterCreationResults.ErrNotAllowed);
            return;
        }

        if (!CanUseName(name))
        {
            await SendCharacterCreationResultAsync(session, CharacterCreationResults.ErrInvalidName);
            return;
        }

        if (await _characterRepository.CharacterWithSameNameExistsAsync(name, session.ConnectionClosed))
        {
            await SendCharacterCreationResultAsync(session, CharacterCreationResults.ErrNameAlreadyExists);
            return;
        }

        var actorLook = GetActorLook(sex, breed, head, colors);

        var characterRecord = _characterFactory.CreateCharacterRecord(name, session.Account, breedId, breed, head.Id, sex, actorLook);

        var newAccountCharacter = new AccountCharacter { AccountId = session.Account.Id, ServerId = _gameService.ServerId, CharacterId = characterRecord.Id };

        if (!await _ipcService.CreateCharacterAsync(newAccountCharacter, session.ConnectionClosed))
        {
            await SendCharacterCreationResultAsync(session, CharacterCreationResults.ErrNotAllowed);
            return;
        }

        session.Account.Characters.Add(newAccountCharacter);

        await _characterRepository.AddCharacterAsync(characterRecord, session.ConnectionClosed);

        await SendCharacterCreationResultAsync(session, CharacterCreationResults.Ok);

        await _characterSelectionService.SelectCharacterAsync(session, characterRecord.Id);
    }

    /// <summary>
    /// Determines whether a new character can be created for the specified session.
    /// </summary>
    /// <param name="session">The game session to check.</param>
    /// <returns>True if a new character can be created; otherwise, false.</returns>
    private bool CanCreateNewCharacter(GameSession session)
    {
        return session.Account.Characters.Count(x => x.ServerId == _gameService.ServerId) < MaxCharactersCount;
    }

    /// <summary>
    /// Attempts to retrieve breed data for the specified breed ID.
    /// </summary>
    /// <param name="breedId">The ID of the breed to retrieve.</param>
    /// <param name="breed">
    /// When this method returns, contains the breed data if the breed ID exists; otherwise, null.
    /// This parameter is passed uninitialized.
    /// </param>
    /// <returns>True if the breed data was successfully retrieved; otherwise, false.</returns>
    private bool CanRetrieveBreed(BreedIds breedId, [NotNullWhen(true)] out Breed? breed)
    {
        return _breedRepository.TryGetBreed(breedId, out breed);
    }

    /// <summary>
    /// Attempts to retrieve head data for the specified cosmetic ID.
    /// </summary>
    /// <param name="cosmeticId">The ID of the cosmetic to retrieve the head data for.</param>
    /// <param name="head">
    /// When this method returns, contains the head data if the cosmetic ID exists; otherwise, null.
    /// This parameter is passed uninitialized.
    /// </param>
    /// <returns>True if the head data was successfully retrieved; otherwise, false.</returns>
    private bool CanRetrieveHead(int cosmeticId, [NotNullWhen(true)] out Head? head)
    {
        return _breedRepository.TryGetHead(cosmeticId, out head);
    }

    /// <summary>
    /// Determines whether the specified head can be used with the given breed and gender.
    /// </summary>
    /// <param name="head">The head to check.</param>
    /// <param name="breedId">The breed ID to check against.</param>
    /// <param name="sex">The sex to check against.</param>
    /// <returns>True if the head can be used; otherwise, false.</returns>
    private static bool CanUseHead(Head head, BreedIds breedId, bool sex)
    {
        return head.Gender == (sex ? 1 : 0) && head.Breed == (int)breedId;
    }

    /// <summary>
    /// Determines whether the specified name is valid for a character.
    /// </summary>
    /// <param name="name">The name to validate.</param>
    /// <returns>True if the name is valid; otherwise, false.</returns>
    private static bool CanUseName(string name)
    {
        return NameRegex().IsMatch(name);
    }

    /// <summary>
    /// Constructs the visual appearance of a character based on the specified attributes.
    /// </summary>
    /// <param name="sex">The sex of the character.</param>
    /// <param name="breed">The breed of the character.</param>
    /// <param name="head">The head appearance of the character.</param>
    /// <param name="colors">An array of colors representing the character's appearance.</param>
    /// <returns>An <see cref="ActorLook"/> object representing the character's appearance.</returns>
    private static ActorLook GetActorLook(bool sex, Breed breed, Head head, IList<int> colors)
    {
        var lookStr = sex ? breed.FemaleLook : breed.MaleLook;
        var defaultColors = sex ? breed.FemaleColors : breed.MaleColors;

        var look = ActorLook.Parse(lookStr);

        for (var i = 0; i < colors.Count; i++)
        {
            if (defaultColors.Count <= i)
                continue;

            var color = colors[i];

            look.AddColor(i + 1, color is -1 ? Color.FromArgb((int)defaultColors[i]) : Color.FromArgb(color));
        }

        foreach (var skin in head.Skins.Split(','))
            look.AddSkin(short.Parse(skin));

        return look;
    }

    /// <summary>
    /// Sends the result of a character creation operation to the specified game session asynchronously.
    /// </summary>
    /// <param name="session">The game session to send the result to.</param>
    /// <param name="result">The result of the character creation operation.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    private static ValueTask SendCharacterCreationResultAsync(GameSession session, CharacterCreationResults result)
    {
        return session.SendAsync(new CharacterCreationResultMessage { Result = (sbyte)result });
    }

    /// <summary>
    /// Gets the regular expression used to validate character names.
    /// </summary>
    /// <returns>A <see cref="Regex"/> object for validating character names.</returns>
    [GeneratedRegex("^[A-Z][a-z]{2,9}(?:-[A-Za-z]{2,9}|[a-zA-Z]{1,16})$", RegexOptions.Multiline)]
    private static partial Regex NameRegex();
}
