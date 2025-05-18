// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Network.Dispatcher.Attributes;
using Krosmoz.Protocol.Messages.Game.Character.Deletion;
using Krosmoz.Servers.GameServer.Network.Transport;
using Krosmoz.Servers.GameServer.Services.Characters.Deletion;

namespace Krosmoz.Servers.GameServer.Handlers.Characters.Deletion;

/// <summary>
/// Handles character deletion-related requests in the game.
/// Provides methods to process character deletion requests from clients.
/// </summary>
public sealed class CharacterDeletionHandler
{
    private readonly ICharacterDeletionService _characterDeletionService;

    /// <summary>
    /// Initializes a new instance of the <see cref="CharacterDeletionHandler"/> class.
    /// </summary>
    /// <param name="characterDeletionService">Service for handling character deletion logic.</param>
    public CharacterDeletionHandler(ICharacterDeletionService characterDeletionService)
    {
        _characterDeletionService = characterDeletionService;
    }

    /// <summary>
    /// Handles the character deletion request from the client.
    /// </summary>
    /// <param name="session">The game session of the client making the request.</param>
    /// <param name="message">The character deletion request message containing character details.</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    [MessageHandler]
    public Task HandleCharacterDeletionRequestAsync(GameSession session, CharacterDeletionRequestMessage message)
    {
        return _characterDeletionService.DeleteCharacterAsync(session, message.CharacterId, message.SecretAnswerHash);
    }
}
