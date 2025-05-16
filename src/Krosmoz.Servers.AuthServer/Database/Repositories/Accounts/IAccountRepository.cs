// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.AuthServer.Database.Models.Accounts;

namespace Krosmoz.Servers.AuthServer.Database.Repositories.Accounts;

/// <summary>
/// Interface for accessing account data from the database.
/// </summary>
public interface IAccountRepository
{
    /// <summary>
    /// Retrieves an account record by its username.
    /// </summary>
    /// <param name="username">The username of the account to retrieve.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result contains the account record if found, or null if not found.
    /// </returns>
    Task<AccountRecord?> GetAccountByUsernameAsync(string username, CancellationToken cancellationToken);

    /// <summary>
    /// Retrieves an account record by its ticket.
    /// </summary>
    /// <param name="ticket">The ticket associated with the account to retrieve.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result contains the account record if found, or null if not found.
    /// </returns>
    Task<AccountRecord?> GetAccountByTicketAsync(string ticket, CancellationToken cancellationToken);

    /// <summary>
    /// Updates the account record in the database asynchronously.
    /// </summary>
    /// <param name="account">The account record to update.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task UpdateAccountAsync(AccountRecord account, CancellationToken cancellationToken);
}
