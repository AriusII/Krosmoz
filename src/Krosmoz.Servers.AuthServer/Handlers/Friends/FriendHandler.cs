// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Network.Dispatcher.Attributes;
using Krosmoz.Protocol.Messages.Connection.Search;
using Krosmoz.Servers.AuthServer.Database.Repositories.Accounts;
using Krosmoz.Servers.AuthServer.Network.Transport;

namespace Krosmoz.Servers.AuthServer.Handlers.Friends;

/// <summary>
/// Represents a handler for managing friend-related operations.
/// </summary>
public sealed class FriendHandler
{
    private readonly IAccountRepository _accountRepository;

    /// <summary>
    /// Initializes a new instance of the <see cref="FriendHandler"/> class.
    /// </summary>
    /// <param name="accountRepository">The repository used to manage account records.</param>
    public FriendHandler(IAccountRepository accountRepository)
    {
        _accountRepository = accountRepository;
    }

    /// <summary>
    /// Handles the acquaintance search request asynchronously.
    /// </summary>
    /// <param name="session">The authentication session of the user.</param>
    /// <param name="message">The message containing the nickname to search for.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    [MessageHandler]
    public async Task HandleAcquaintanceSearchAsync(AuthSession session, AcquaintanceSearchMessage message)
    {
        var account = await _accountRepository.GetAccountByNicknameAsync(message.Nickname, session.ConnectionClosed);

        if (account is null)
        {
            await session.SendAsync(new AcquaintanceSearchErrorMessage { Reason = 2 });
            return;
        }

        var serverIds = account.Characters.Select(static x => (short)x.ServerId).Distinct();

        await session.SendAsync(new AcquaintanceServerListMessage { Servers = serverIds });
    }
}
