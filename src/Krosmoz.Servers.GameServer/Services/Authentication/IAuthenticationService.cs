// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.GameServer.Network.Transport;

namespace Krosmoz.Servers.GameServer.Services.Authentication;

/// <summary>
/// Defines the contract for a service that handles authentication of game sessions.
/// </summary>
public interface IAuthenticationService
{
    /// <summary>
    /// Authenticates a game session asynchronously using the provided ticket.
    /// </summary>
    /// <param name="session">The game session to authenticate.</param>
    /// <param name="ticket">The authentication ticket used for validation.</param>
    /// <returns>A task that represents the asynchronous authentication operation.</returns>
    Task AuthenticateAsync(GameSession session, string ticket);
}
