// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Extensions;
using Krosmoz.Protocol.Enums;
using Krosmoz.Protocol.Messages.Game.Character.Deletion;
using Krosmoz.Servers.GameServer.Database.Repositories.Characters;
using Krosmoz.Servers.GameServer.Network.Transport;
using Krosmoz.Servers.GameServer.Services.Characters.Selection;
using Krosmoz.Servers.GameServer.Services.Ipc;
using Microsoft.Extensions.Configuration;

namespace Krosmoz.Servers.GameServer.Services.Characters.Deletion;

/// <summary>
/// Provides services for deleting characters.
/// </summary>
public sealed class CharacterDeletionService : ICharacterDeletionService
{
    private readonly ICharacterRepository _characterRepository;
    private readonly ICharacterSelectionService _characterSelectionService;
    private readonly long _maxExperienceToDeleteCharacterWithoutSecretQuestion;

    /// <summary>
    /// Initializes a new instance of the <see cref="CharacterDeletionService"/> class.
    /// </summary>
    /// <param name="characterRepository">The repository for accessing character data.</param>
    /// <param name="characterSelectionService">The service for managing character selection.</param>
    /// <param name="configuration">The configuration settings for the application.</param>
    public CharacterDeletionService(ICharacterRepository characterRepository, ICharacterSelectionService characterSelectionService, IConfiguration configuration)
    {
        _characterRepository = characterRepository;
        _characterSelectionService = characterSelectionService;
        _maxExperienceToDeleteCharacterWithoutSecretQuestion = configuration.GetValue<long>("MaxExperienceToDeleteCharacterWithoutSecretQuestion");
    }

    /// <summary>
    /// Deletes a character asynchronously.
    /// </summary>
    /// <param name="session">The game session associated with the character to be deleted.</param>
    /// <param name="characterId">The unique identifier of the character to be deleted.</param>
    /// <param name="secretAnswerHash">The hashed secret answer used for verification.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task DeleteCharacterAsync(GameSession session, long characterId, string secretAnswerHash)
    {
        var characterRecord = await _characterRepository.GetCharacterByIdAsync(characterId, session.ConnectionClosed);

        if (characterRecord is null)
        {
            await SendCharacterDeletionErrorAsync(session, CharacterDeletionErrors.DelErrNoReason);
            return;
        }

        var serverCharacterToRemove = session.Account.Characters.FirstOrDefault(c => c.CharacterId == characterId);

        if (serverCharacterToRemove is null)
        {
            await SendCharacterDeletionErrorAsync(session, CharacterDeletionErrors.DelErrNoReason);
            return;
        }

        if (characterRecord.Experience >= _maxExperienceToDeleteCharacterWithoutSecretQuestion && !string.Equals(secretAnswerHash, $"{characterId}~{session.Account.SecretAnswer}".ToMd5()))
        {
            await SendCharacterDeletionErrorAsync(session, CharacterDeletionErrors.DelErrBadSecretAnswer);
            return;
        }

        session.Account.Characters.Remove(serverCharacterToRemove);

        await _characterRepository.RemoveCharacterAsync(characterRecord, session.ConnectionClosed);

        await _characterSelectionService.SendCharactersListAsync(session);
    }

    /// <summary>
    /// Sends a character deletion error message to the client asynchronously.
    /// </summary>
    /// <param name="session">The game session to send the error message to.</param>
    /// <param name="error">The error reason for the character deletion failure.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    private static ValueTask SendCharacterDeletionErrorAsync(GameSession session, CharacterDeletionErrors error)
    {
        return session.SendAsync(new CharacterDeletionErrorMessage { Reason = (sbyte)error });
    }
}
