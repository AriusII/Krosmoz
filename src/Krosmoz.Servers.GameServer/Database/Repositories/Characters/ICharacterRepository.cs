// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.GameServer.Database.Models.Characters;

namespace Krosmoz.Servers.GameServer.Database.Repositories.Characters;

/// <summary>
/// Represents a repository interface for managing character records in the database.
/// </summary>
public interface ICharacterRepository
{
    /// <summary>
    /// Adds a new character record to the database asynchronously.
    /// </summary>
    /// <param name="character">The character record to add.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task AddCharacterAsync(CharacterRecord character, CancellationToken cancellationToken);

    /// <summary>
    /// Retrieves a character record by its ID asynchronously.
    /// </summary>
    /// <param name="characterId">The ID of the character to retrieve.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation, containing the character record if found;
    /// otherwise, <c>null</c>.
    /// </returns>
    Task<CharacterRecord?> GetCharacterByIdAsync(long characterId, CancellationToken cancellationToken);

    /// <summary>
    /// Checks if a character with the same name already exists in the database asynchronously.
    /// </summary>
    /// <param name="name">The name of the character to check for existence.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result is a boolean indicating
    /// whether a character with the same name exists.
    /// </returns>
    Task<bool> CharacterWithSameNameExistsAsync(string name, CancellationToken cancellationToken);

    /// <summary>
    /// Removes a character record from the database asynchronously.
    /// </summary>
    /// <param name="character">The character record to remove.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task RemoveCharacterAsync(CharacterRecord character, CancellationToken cancellationToken);
}
