// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Servers.GameServer.Network.Transport;

namespace Krosmoz.Servers.GameServer.Services.Characters.Creation;

/// <summary>
/// Defines the contract for a service that handles character creation functionality.
/// </summary>
public interface ICharacterCreationService
{
    /// <summary>
    /// Sends a randomly generated character name to the specified game session asynchronously.
    /// </summary>
    /// <param name="session">The game session to which the random character name will be sent.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task SendRandomCharacterNameAsync(GameSession session);

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
    Task CreateCharacterAsync(GameSession session, string name, BreedIds breedId, bool sex, IList<int> colors, int cosmeticId);
}
