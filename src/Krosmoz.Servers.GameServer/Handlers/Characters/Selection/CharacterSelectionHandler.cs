// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Network.Dispatcher.Attributes;
using Krosmoz.Protocol.Messages.Game.Character.Choice;
using Krosmoz.Servers.GameServer.Network.Transport;
using Krosmoz.Servers.GameServer.Services.Characters.Selection;

namespace Krosmoz.Servers.GameServer.Handlers.Characters.Selection;

/// <summary>
/// Handles character selection-related requests.
/// Provides methods to process character selection and list retrieval requests.
/// </summary>
public sealed class CharacterSelectionHandler
{
    private readonly ICharacterSelectionService _characterSelectionService;

    /// <summary>
    /// Initializes a new instance of the <see cref="CharacterSelectionHandler"/> class.
    /// </summary>
    /// <param name="characterSelectionService">Service for handling character selection logic.</param>
    public CharacterSelectionHandler(ICharacterSelectionService characterSelectionService)
    {
        _characterSelectionService = characterSelectionService;
    }

    /// <summary>
    /// Handles the first character selection request from the client.
    /// </summary>
    /// <param name="session">The game session of the client making the request.</param>
    /// <param name="message">The message containing the ID of the character to select.</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    [MessageHandler]
    public Task HandleCharacterFirstSelectionAsync(GameSession session, CharacterFirstSelectionMessage message)
    {
        return _characterSelectionService.SelectCharacterAsync(session, message.Id);
    }

    /// <summary>
    /// Handles the character selection request from the client.
    /// </summary>
    /// <param name="session">The game session of the client making the request.</param>
    /// <param name="message">The message containing the ID of the character to select.</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    [MessageHandler]
    public Task HandleCharacterSelectionAsync(GameSession session, CharacterSelectionMessage message)
    {
        return _characterSelectionService.SelectCharacterAsync(session, message.Id);
    }

    /// <summary>
    /// Handles the request to retrieve the list of characters for the client.
    /// </summary>
    /// <param name="session">The game session of the client making the request.</param>
    /// <param name="message">The message requesting the list of characters.</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    [MessageHandler]
    public Task HandleCharactersListRequestAsync(GameSession session, CharactersListRequestMessage message)
    {
        return _characterSelectionService.SendCharactersListAsync(session);
    }
}
