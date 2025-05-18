// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.GameServer.Models.Accounts;

namespace Krosmoz.Servers.GameServer.Services.Ipc;

/// <summary>
/// Defines the contract for an IPC (Inter-Process Communication) service
/// that facilitates communication between the game server and other components.
/// </summary>
public interface IIpcService
{
    /// <summary>
    /// Retrieves account information asynchronously based on the provided ticket.
    /// </summary>
    /// <param name="ticket">The authentication ticket used to identify the account.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result contains the
    /// <see cref="Account"/> if the account is found, or null if it is not.
    /// </returns>
    Task<Account?> GetAccountAsync(string ticket, CancellationToken cancellationToken);

    /// <summary>
    /// Creates a new character asynchronously.
    /// </summary>
    /// <param name="character">The character information to be created.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result is a boolean indicating
    /// whether the character was successfully created.
    /// </returns>
    Task<bool> CreateCharacterAsync(AccountCharacter character, CancellationToken cancellationToken);
}
