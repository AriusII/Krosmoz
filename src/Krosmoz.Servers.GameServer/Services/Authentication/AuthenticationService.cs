// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Messages.Game.Approach;
using Krosmoz.Servers.GameServer.Network.Transport;
using Krosmoz.Servers.GameServer.Services.Game;
using Krosmoz.Servers.GameServer.Services.Ipc;

namespace Krosmoz.Servers.GameServer.Services.Authentication;

/// <summary>
/// Provides functionality to handle authentication of game sessions.
/// </summary>
public sealed class AuthenticationService : IAuthenticationService
{
    private readonly IIpcService _ipcService;
    private readonly IGameService _gameService;

    /// <summary>
    /// Initializes a new instance of the <see cref="AuthenticationService"/> class.
    /// </summary>
    /// <param name="ipcService">The IPC service used for inter-process communication.</param>
    /// <param name="gameService">The service for managing and sending server-related information.</param>
    public AuthenticationService(IIpcService ipcService, IGameService gameService)
    {
        _ipcService = ipcService;
        _gameService = gameService;
    }

    /// <summary>
    /// Authenticates a game session asynchronously using the provided ticket.
    /// </summary>
    /// <param name="session">The game session to authenticate.</param>
    /// <param name="ticket">The authentication ticket used for validation.</param>
    public async Task AuthenticateAsync(GameSession session, string ticket)
    {
        try
        {
            var account = await _ipcService.GetAccountAsync(ticket, session.ConnectionClosed);

            if (account is null)
            {
                await session.SendAsync(new AuthenticationTicketRefusedMessage());
                await session.DisconnectAsync();
                return;
            }

            session.Account = account;

            await _gameService.SendServerInfomationsAsync(session);

            await session.SendAsync(new AuthenticationTicketAcceptedMessage());
        }
        catch (Exception)
        {
            await session.SendAsync(new AuthenticationTicketRefusedMessage());
            await session.DisconnectAsync();
        }
    }
}
