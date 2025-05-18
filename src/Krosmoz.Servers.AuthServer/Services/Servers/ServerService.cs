// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Collections.Concurrent;
using System.Diagnostics;
using Krosmoz.Core.Extensions;
using Krosmoz.Protocol.Enums;
using Krosmoz.Protocol.Messages.Connection;
using Krosmoz.Protocol.Types.Connection;
using Krosmoz.Servers.AuthServer.Database.Models.Accounts;
using Krosmoz.Servers.AuthServer.Database.Models.Servers;
using Krosmoz.Servers.AuthServer.Database.Repositories.Servers;
using Krosmoz.Servers.AuthServer.Network.Transport;

namespace Krosmoz.Servers.AuthServer.Services.Servers;

/// <summary>
/// Service for managing server-related operations.
/// </summary>
public sealed class ServerService : IServerService
{
    private const int MaxCharacterPerServer = 8;

    private readonly IServerRepository _serverRepository;
    private readonly ConcurrentDictionary<string, AuthSession> _sessionsWaiting;

    /// <summary>
    /// Initializes a new instance of the <see cref="ServerService"/> class.
    /// </summary>
    /// <param name="serverRepository">The repository used to manage server records.</param>
    public ServerService(IServerRepository serverRepository)
    {
        _serverRepository = serverRepository;
        _sessionsWaiting = [];
    }

    /// <summary>
    /// Updates the status of a server asynchronously.
    /// </summary>
    /// <param name="serverId">The unique identifier of the server to update.</param>
    /// <param name="status">The new status to set for the server.</param>
    /// <param name="cancellationToken">A token to signal the operation should be canceled.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result contains a boolean value
    /// indicating whether the server status was successfully updated.
    /// </returns>
    public async Task<bool> UpdateServerStatusAsync(int serverId, ServerStatuses status, CancellationToken cancellationToken)
    {
        if (!_serverRepository.TryGetServerById(serverId, out var server))
            return false;

        server.Status = status;

        await _serverRepository.UpdateServerAsync(server, cancellationToken);

        await Parallel.ForEachAsync(_sessionsWaiting.Values, cancellationToken, async (session, token) =>
        {
            if (!session.IsConnected)
            {
                _sessionsWaiting.Remove(session.SessionId, out _);
                return;
            }

            await session.SendAsync(new ServerStatusUpdateMessage { Server = GetGameServerInformations(server, session.Account) });
        });

        return true;
    }

    /// <summary>
    /// Handles the event when a user is successfully authenticated.
    /// </summary>
    /// <param name="session">The authentication session of the user.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task OnSuccessfullyAuthenticatedAsync(AuthSession session)
    {
        await Task.WhenAll(_sessionsWaiting.Values.Where(x => x.Account.Id == session.Account.Id).Select(static x => x.DisconnectAsync()));

        _sessionsWaiting.TryAdd(session.SessionId, session);

        session.ConnectionClosed.Register(() => _sessionsWaiting.Remove(session.SessionId, out _));

        var servers = _serverRepository.GetVisibleServers(session.Account.Hierarchy);

        await session.SendAsync(new ServersListMessage { Servers = servers.Select(x => GetGameServerInformations(x, session.Account)) });

        if (session.AutoSelectServerId > 0)
            await SelectGameServerAsync(session, session.AutoSelectServerId);
    }

    /// <summary>
    /// Selects a game server for the user asynchronously.
    /// </summary>
    /// <param name="session">The authentication session of the user.</param>
    /// <param name="serverId">The unique identifier of the server to select.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task SelectGameServerAsync(AuthSession session, int serverId)
    {
        if (!_serverRepository.TryGetServerById(serverId, out var server))
            return;

        if (server.Status is not ServerStatuses.Online)
        {
            await SendSelectServerRefusedAsync(session, server, ServerConnectionErrors.ServerConnectionErrorDueToStatus);
            return;
        }

        if (server.JoinableHierarchy > session.Account.Hierarchy)
        {
            await SendSelectServerRefusedAsync(session, server, ServerConnectionErrors.ServerConnectionErrorAccountRestricted);
            return;
        }

        Debug.Assert(server.IpAddress is not null);
        Debug.Assert(server.Port is not null);
        Debug.Assert(!string.IsNullOrEmpty(session.Account.Ticket));

        var charactersCount = session.Account.Characters.Count(x => x.ServerId == server.Id && !x.DeletedAt.HasValue);

        await session.SendAsync(new SelectedServerDataMessage
        {
            ServerId = (short)serverId,
            Address = server.IpAddress.ToString(),
            Port = (ushort)server.Port.Value,
            Ticket = session.Account.Ticket,
            CanCreateNewCharacter = charactersCount < MaxCharacterPerServer
        });

        await session.DisconnectAsync();
    }

    /// <summary>
    /// Sends a message to the user indicating that the server selection was refused.
    /// </summary>
    /// <param name="session">The authentication session of the user.</param>
    /// <param name="server">The server record associated with the refusal.</param>
    /// <param name="error">The error code indicating the reason for refusal.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    private static ValueTask SendSelectServerRefusedAsync(AuthSession session, ServerRecord server, ServerConnectionErrors error)
    {
        return session.SendAsync(new SelectedServerRefusedMessage
        {
            ServerId = (short)server.Id,
            ServerStatus = (sbyte)server.Status,
            Error = (sbyte)error
        });
    }

    /// <summary>
    /// Retrieves game server information for the specified server and account.
    /// </summary>
    /// <param name="server">The server record to retrieve information for.</param>
    /// <param name="account">The account record associated with the user.</param>
    /// <returns>A <see cref="GameServerInformations"/> object containing the server details.</returns>
    private static GameServerInformations GetGameServerInformations(ServerRecord server, AccountRecord account)
    {
        var charactersCount = account.Characters.Count(x => x.ServerId == server.Id && !x.DeletedAt.HasValue);

        Debug.Assert(server.OpenedAt is not null);

        return new GameServerInformations
        {
            Id = (ushort)server.Id,
            CharactersCount = (sbyte)charactersCount,
            Completion = 0,
            Date = server.OpenedAt.Value.GetUnixTimestampMilliseconds(),
            IsSelectable = server.Status is ServerStatuses.Online,
            Status = (sbyte)server.Status
        };
    }
}
