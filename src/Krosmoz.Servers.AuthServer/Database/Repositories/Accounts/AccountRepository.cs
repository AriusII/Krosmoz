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

        return await dbContext.Accounts.FirstOrDefaultAsync(x => x.Username == username, cancellationToken);
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

        return await dbContext.Accounts.FirstOrDefaultAsync(x => x.Ticket == ticket, cancellationToken);
    }
}
