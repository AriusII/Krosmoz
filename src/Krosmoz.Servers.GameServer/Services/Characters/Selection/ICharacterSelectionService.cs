// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.GameServer.Network.Transport;

namespace Krosmoz.Servers.GameServer.Services.Characters.Selection;

/// <summary>
/// Defines the contract for a service that handles character selection functionality.
/// </summary>
public interface ICharacterSelectionService
{
    /// <summary>
    /// Sends the list of available characters to the specified game session asynchronously.
    /// </summary>
    /// <param name="session">The game session to which the character list will be sent.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task SendCharactersListAsync(GameSession session);

    /// <summary>
    /// Selects a character for the specified game session asynchronously.
    /// </summary>
    /// <param name="session">The game session for which the character is being selected.</param>
    /// <param name="characterId">The ID of the character to select.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task SelectCharacterAsync(GameSession session, long characterId);
}
