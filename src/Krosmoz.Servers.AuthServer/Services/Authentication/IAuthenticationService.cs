// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Messages.Connection;
using Krosmoz.Servers.AuthServer.Database.Models.Accounts;
using Krosmoz.Servers.AuthServer.Network.Transport;

namespace Krosmoz.Servers.AuthServer.Services.Authentication;

/// <summary>
/// Defines the contract for a connection service that handles connection-related operations.
/// </summary>
public interface IAuthenticationService
{
    /// <summary>
    /// Authenticates a session asynchronously using the provided identification message.
    /// </summary>
    /// <param name="session">The session to authenticate.</param>
    /// <param name="message">The identification message containing authentication details.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task AuthenticateAsync(AuthSession session, IdentificationMessage message);

    /// <summary>
    /// Handles post-authentication operations for a successfully authenticated session.
    /// </summary>
    /// <param name="session">The authenticated session.</param>
    /// <param name="account">The account associated with the session.</param>
    /// <param name="serverId">The ID of the server to auto-select for the session.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task OnSuccessfullyAuthenticatedAsync(AuthSession session, AccountRecord account, int serverId);
}
