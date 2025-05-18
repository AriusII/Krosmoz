// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.AuthServer.Database.Models.Accounts;
using Microsoft.EntityFrameworkCore;

namespace Krosmoz.Servers.AuthServer.Database.Repositories.Accounts;

/// <summary>
/// Repository for accessing account data from the database.
/// </summary>
public sealed class AccountRepository : IAccountRepository
{
    private readonly IDbContextFactory<AuthDbContext> _dbContextFactory;

    /// <summary>
    /// Initializes a new instance of the <see cref="AccountRepository"/> class.
    /// </summary>
    /// <param name="dbContextFactory">The factory for creating database context instances.</param>
    public AccountRepository(IDbContextFactory<AuthDbContext> dbContextFactory)
    {
        _dbContextFactory = dbContextFactory;
    }

    /// <summary>
    /// Retrieves an account record by its ID asynchronously.
    /// </summary>
    /// <param name="id">The unique identifier of the account to retrieve.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result contains the account record if found, or null if not found.
    /// </returns>
    public async Task<AccountRecord?> GetAccountByIdAsync(int id, CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        return await dbContext.Accounts
            .Include(static x => x.Characters)
            .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    }

    /// <summary>
    /// Retrieves an account record by its username.
    /// </summary>
    /// <param name="username">The username of the account to retrieve.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result contains the account record if found, or null if not found.
    /// </returns>
    public async Task<AccountRecord?> GetAccountByUsernameAsync(string username, CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        return await dbContext.Accounts
            .Include(static x => x.Characters)
            .FirstOrDefaultAsync(x => x.Username == username, cancellationToken);
    }

    /// <summary>
    /// Retrieves an account record by its nickname asynchronously.
    /// </summary>
    /// <param name="nickname">The nickname of the account to retrieve.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result contains the
    /// <see cref="AccountRecord"/> associated with the specified nickname, or null if no such account exists.
    /// </returns>
    public async Task<AccountRecord?> GetAccountByNicknameAsync(string nickname, CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        return await dbContext.Accounts
            .Include(static x => x.Characters)
            .FirstOrDefaultAsync(x => x.Nickname == nickname, cancellationToken);
    }

    /// <summary>
    /// Retrieves an account record by its ticket.
    /// </summary>
    /// <param name="ticket">The ticket associated with the account to retrieve.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result contains the account record if found, or null if not found.
    /// </returns>
    public async Task<AccountRecord?> GetAccountByTicketAsync(string ticket, CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        return await dbContext.Accounts
            .Include(static x => x.Characters)
            .FirstOrDefaultAsync(x => x.Ticket == ticket, cancellationToken);
    }

    /// <summary>
    /// Checks asynchronously if an account with the specified nickname already exists in the database.
    /// </summary>
    /// <param name="nickname">The nickname to check for existence.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result contains a boolean value
    /// indicating whether an account with the same nickname exists.
    /// </returns>
    public async Task<bool> AccountWithSameNicknameExistsAsync(string nickname, CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        return await dbContext.Accounts.AnyAsync(x => x.Nickname != null && x.Nickname.ToLower().Equals(nickname.ToLower()), cancellationToken);
    }

    /// <summary>
    /// Updates the account record in the database asynchronously.
    /// </summary>
    /// <param name="account">The account record to update.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task UpdateAccountAsync(AccountRecord account, CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        dbContext.Accounts.Update(account);
        await dbContext.SaveChangesAsync(cancellationToken);
    }
}
