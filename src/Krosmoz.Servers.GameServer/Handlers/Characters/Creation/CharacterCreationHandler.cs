// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Network.Dispatcher.Attributes;
using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Protocol.Messages.Game.Character.Creation;
using Krosmoz.Servers.GameServer.Network.Transport;
using Krosmoz.Servers.GameServer.Services.Characters.Creation;

namespace Krosmoz.Servers.GameServer.Handlers.Characters.Creation;

/// <summary>
/// Handles character creation-related requests in the game.
/// Provides methods to process character creation and name suggestion requests.
/// </summary>
public sealed class CharacterCreationHandler
{
    private readonly ICharacterCreationService _characterCreationService;

    /// <summary>
    /// Initializes a new instance of the <see cref="CharacterCreationHandler"/> class.
    /// </summary>
    /// <param name="characterCreationService">Service for handling character creation logic.</param>
    public CharacterCreationHandler(ICharacterCreationService characterCreationService)
    {
        _characterCreationService = characterCreationService;
    }

    /// <summary>
    /// Handles the character creation request from the client.
    /// </summary>
    /// <param name="session">The game session of the client making the request.</param>
    /// <param name="message">The character creation request message containing character details.</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    [MessageHandler]
    public Task HandleCharacterCreationRequestAsync(GameSession session, CharacterCreationRequestMessage message)
    {
        return _characterCreationService.CreateCharacterAsync(session, message.Name, (BreedIds)message.Breed, message.Sex, message.Colors.ToList(), message.CosmeticId);
    }

    /// <summary>
    /// Handles the character name suggestion request from the client.
    /// </summary>
    /// <param name="session">The game session of the client making the request.</param>
    /// <param name="_">The character name suggestion request message (unused).</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    [MessageHandler]
    public Task HandleCharacterNameSuggestionRequestAsync(GameSession session, CharacterNameSuggestionRequestMessage _)
    {
        return _characterCreationService.SendRandomCharacterNameAsync(session);
    }
}
