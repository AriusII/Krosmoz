// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.GameServer.Network.Transport;

namespace Krosmoz.Servers.GameServer.Services.Characters.Deletion;

/// <summary>
/// Defines the interface for a service that handles character deletion operations.
/// </summary>
public interface ICharacterDeletionService
{
    /// <summary>
    /// Deletes a character asynchronously.
    /// </summary>
    /// <param name="session">The game session associated with the character to be deleted.</param>
    /// <param name="characterId">The unique identifier of the character to be deleted.</param>
    /// <param name="secretAnswerHash">The hashed secret answer used for verification.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task DeleteCharacterAsync(GameSession session, long characterId, string secretAnswerHash);
}
