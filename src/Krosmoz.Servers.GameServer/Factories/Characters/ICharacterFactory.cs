// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Servers.GameServer.Database.Models.Characters;
using Krosmoz.Servers.GameServer.Models.Accounts;
using Krosmoz.Servers.GameServer.Models.Appearances;

namespace Krosmoz.Servers.GameServer.Factories.Characters;

/// <summary>
/// Defines the contract for a factory that creates characters.
/// </summary>
public interface ICharacterFactory
{
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
    CharacterRecord CreateCharacterRecord(string name, Account account, BreedIds breedId, int headId, bool sex, ActorLook actorLook);
}
