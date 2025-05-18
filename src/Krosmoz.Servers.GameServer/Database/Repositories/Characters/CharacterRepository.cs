// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.GameServer.Database.Models.Characters;
using Microsoft.EntityFrameworkCore;

namespace Krosmoz.Servers.GameServer.Database.Repositories.Characters;

/// <summary>
/// Represents a repository for managing character records in the database.
/// </summary>
public sealed class CharacterRepository : ICharacterRepository
{
    private readonly IDbContextFactory<GameDbContext> _dbContextFactory;

    /// <summary>
    /// Initializes a new instance of the <see cref="CharacterRepository"/> class.
    /// </summary>
    /// <param name="dbContextFactory">The factory used to create instances of <see cref="GameDbContext"/>.</param>
    public CharacterRepository(IDbContextFactory<GameDbContext> dbContextFactory)
    {
        _dbContextFactory = dbContextFactory;
    }

    /// <summary>
    /// Adds a new character record to the database asynchronously.
    /// </summary>
    /// <param name="character">The character record to add.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task AddCharacterAsync(CharacterRecord character, CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        await dbContext.Characters.AddAsync(character, cancellationToken);
        await dbContext.SaveChangesAsync(cancellationToken);
    }

    /// <summary>
    /// Retrieves a character record by its ID asynchronously.
    /// </summary>
    /// <param name="characterId">The ID of the character to retrieve.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation, containing the character record if found;
    /// otherwise, <c>null</c>.
    /// </returns>
    public async Task<CharacterRecord?> GetCharacterByIdAsync(long characterId, CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        return await dbContext.Characters.FirstOrDefaultAsync(x => x.Id == characterId, cancellationToken);
    }

    /// <summary>
    /// Checks if a character with the same name already exists in the database asynchronously.
    /// </summary>
    /// <param name="name">The name of the character to check for existence.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result is a boolean indicating
    /// whether a character with the same name exists.
    /// </returns>
    public async Task<bool> CharacterWithSameNameExistsAsync(string name, CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        return await dbContext.Characters.AnyAsync(x => x.Name.ToLower().Equals(name.ToLower()), cancellationToken);
    }

    /// <summary>
    /// Removes a character record from the database asynchronously.
    /// </summary>
    /// <param name="character">The character record to remove.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task RemoveCharacterAsync(CharacterRecord character, CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        character.DeletedAt = DateTime.UtcNow;

        dbContext.Characters.Update(character);
        await dbContext.SaveChangesAsync(cancellationToken);
    }
}
