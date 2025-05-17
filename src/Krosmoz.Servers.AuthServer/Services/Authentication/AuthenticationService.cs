// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Diagnostics;
using Krosmoz.Core.Extensions;
using Krosmoz.Protocol.Enums;
using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Protocol.Messages.Connection;
using Krosmoz.Protocol.Messages.Connection.Register;
using Krosmoz.Protocol.Types.Version;
using Krosmoz.Serialization.I18N;
using Krosmoz.Servers.AuthServer.Database.Models.Accounts;
using Krosmoz.Servers.AuthServer.Database.Repositories.Accounts;
using Krosmoz.Servers.AuthServer.Network.Transport;
using Krosmoz.Servers.AuthServer.Services.Queue;
using Krosmoz.Servers.AuthServer.Services.Servers;

namespace Krosmoz.Servers.AuthServer.Services.Authentication;

/// <summary>
/// Provides services for managing connection-related operations in the authentication server.
/// </summary>
public sealed class AuthenticationService : IAuthenticationService
{
    private static readonly VersionExtended s_requiredVersion = new()
    {
        Major = 2,
        Minor = 14,
        Release = 0,
        Revision = 35100,
        Patch = 0,
        BuildType = 5,
        Install = 1,
        Technology = 1
    };

    private readonly IAccountRepository _accountRepository;
    private readonly IServerService _serverService;
    private readonly IQueueService _queueService;

    /// <summary>
    /// Initializes a new instance of the <see cref="AuthenticationService"/> class.
    /// </summary>
    /// <param name="accountRepository">The repository for managing account-related operations.</param>
    /// <param name="serverService">The service for managing server-related operations.</param>
    /// <param name="queueService">The service for managing queue-related operations.</param>
    public AuthenticationService(IAccountRepository accountRepository, IServerService serverService, IQueueService queueService)
    {
        _accountRepository = accountRepository;
        _serverService = serverService;
        _queueService = queueService;
    }

    /// <summary>
    /// Authenticates a session asynchronously using the provided identification message.
    /// </summary>
    /// <param name="session">The session to authenticate.</param>
    /// <param name="message">The identification message containing authentication details.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task AuthenticateAsync(AuthSession session, IdentificationMessage message)
    {
        if (!message.Version.Equals(s_requiredVersion))
        {
            await SendIdentificationFailedForBadVersionAsync(session);
            await session.DisconnectAsync();
            return;
        }

        if (string.IsNullOrEmpty(message.Username) || string.IsNullOrEmpty(message.Password))
        {
            await SendIdentificationFailedAsync(session, IdentificationFailureReasons.WrongCredentials);
            await session.DisconnectAsync();
            return;
        }

        await session.SendAsync<CredentialsAcknowledgementMessage>();

        var account = await _accountRepository.GetAccountByUsernameAsync(message.Username, session.ConnectionClosed);

        if (account is null || !account.Password.Equals(message.Password.ToMd5()))
        {
            await SendIdentificationFailedAsync(session, IdentificationFailureReasons.WrongCredentials);
            await session.DisconnectAsync();
            return;
        }

        // TODO: Check if the account is banned or ip or mac address is banned

        account.MacAddress = message.Hwnd;
        account.IpAddress = session.EndPoint!.Address;
        account.Ticket = Guid.NewGuid().ToString().ToMd5();

        await OnSuccessfullyAuthenticatedAsync(session, account, message.ServerId);
    }

    /// <summary>
    /// Handles post-authentication operations for a successfully authenticated session.
    /// </summary>
    /// <param name="session">The authenticated session.</param>
    /// <param name="account">The account associated with the session.</param>
    /// <param name="serverId">The ID of the server to auto-select for the session.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task OnSuccessfullyAuthenticatedAsync(AuthSession session, AccountRecord account, int serverId)
    {
        _queueService.Dequeue(session);

        await _queueService.SendQueueStatusAsync(session, 0, 0);

        session.Account = account;
        session.AutoSelectServerId = serverId;

        if (string.IsNullOrEmpty(session.Account.Nickname))
        {
            await session.SendAsync<NicknameRegistrationMessage>();
            return;
        }

        await _accountRepository.UpdateAccountAsync(account, session.ConnectionClosed);

        Debug.Assert(!string.IsNullOrEmpty(session.Account.Nickname));

        var communityId = session.Account.Language switch
        {
            I18NLanguages.English => ServerCommunityIds.Anglophone,
            I18NLanguages.French => ServerCommunityIds.Francophone,
            I18NLanguages.Spanish => ServerCommunityIds.Hispanophone,
            _ => ServerCommunityIds.Francophone
        };

        var accountCreation = DateTime.UtcNow.GetUnixTimestampMilliseconds() - session.Account.CreatedAt.GetUnixTimestampMilliseconds();

        var subscriptionEndDate = session.Account.HasRights
            ? DateTime.UtcNow.AddYears(100).GetUnixTimestampMilliseconds()
            : session.Account.SubscriptionExpireAt.GetValueOrDefault(DateTime.UtcNow).GetUnixTimestampMilliseconds();

        await session.SendAsync(new IdentificationSuccessMessage
        {
            AccountId = session.Account.Id,
            Login = session.Account.Username,
            Nickname = session.Account.Nickname,
            CommunityId = (sbyte)communityId,
            SecretQuestion = session.Account.SecretQuestion,
            WasAlreadyConnected = false,
            AccountCreation = accountCreation,
            SubscriptionEndDate = subscriptionEndDate,
            HasRights = session.Account.HasRights,
        });

        await _serverService.OnSuccessfullyAuthenticatedAsync(session);
    }

    /// <summary>
    /// Sends an identification failure message asynchronously to the specified session.
    /// </summary>
    /// <param name="session">The session to which the failure message will be sent.</param>
    /// <param name="reason">The reason for the identification failure.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    private static ValueTask SendIdentificationFailedAsync(AuthSession session, IdentificationFailureReasons reason)
    {
        return session.SendAsync(new IdentificationFailedMessage { Reason = (sbyte)reason });
    }

    /// <summary>
    /// Sends an identification failure message for a bad version asynchronously to the specified session.
    /// </summary>
    /// <param name="session">The session to which the failure message will be sent.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    private static ValueTask SendIdentificationFailedForBadVersionAsync(AuthSession session)
    {
        return session.SendAsync(new IdentificationFailedForBadVersionMessage
        {
            Reason = (sbyte)IdentificationFailureReasons.BadVersion,
            RequiredVersion = s_requiredVersion
        });
    }
}
