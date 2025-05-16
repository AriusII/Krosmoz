// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums;
using Krosmoz.Protocol.Messages.Connection.Register;
using Krosmoz.Servers.AuthServer.Database.Repositories.Accounts;
using Krosmoz.Servers.AuthServer.Database.Repositories.Communication;
using Krosmoz.Servers.AuthServer.Network.Transport;
using Krosmoz.Servers.AuthServer.Services.Authentication;

namespace Krosmoz.Servers.AuthServer.Services.Nickname;

/// <summary>
/// Provides services for handling nickname-related operations in the authentication server.
/// </summary>
public sealed class NicknameService : INicknameService
{
    private readonly ICensoredWordRepository _censoredWordRepository;
    private readonly IAccountRepository _accountRepository;
    private readonly IAuthenticationService _authenticationService;

    /// <summary>
    /// Initializes a new instance of the <see cref="NicknameService"/> class.
    /// </summary>
    /// <param name="censoredWordRepository">The repository for managing censored words.</param>
    /// <param name="accountRepository">The repository for managing account data.</param>
    /// <param name="authenticationService">The service for managing client connections.</param>
    public NicknameService(ICensoredWordRepository censoredWordRepository, IAccountRepository accountRepository, IAuthenticationService authenticationService)
    {
        _censoredWordRepository = censoredWordRepository;
        _accountRepository = accountRepository;
        _authenticationService = authenticationService;
    }

    /// <summary>
    /// Processes the nickname choice request for a client session.
    /// </summary>
    /// <param name="session">The client session making the request.</param>
    /// <param name="nickname">The nickname chosen by the client.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task ChoiceNicknameAsync(AuthSession session, string nickname)
    {
        if (string.IsNullOrEmpty(nickname))
        {
            await SendNicknameRefusedAsync(session, NicknameErrors.InvalidNick);
            return;
        }

        var censoredWords = _censoredWordRepository.GetCensoredWords(session.Account.Language);

        if (censoredWords.Any(censoredWord => nickname.Contains(censoredWord.Word, StringComparison.InvariantCultureIgnoreCase)))
        {
            await SendNicknameRefusedAsync(session, NicknameErrors.InvalidNick);
            return;
        }

        if (nickname.Length is < 4 or > 14)
        {
            await SendNicknameRefusedAsync(session, NicknameErrors.InvalidNick);
            return;
        }

        if (session.Account.Username.Equals(nickname, StringComparison.InvariantCultureIgnoreCase))
        {
            await SendNicknameRefusedAsync(session, NicknameErrors.SameAsLogin);
            return;
        }

        if (session.Account.Username.Contains(nickname, StringComparison.InvariantCultureIgnoreCase))
        {
            await SendNicknameRefusedAsync(session, NicknameErrors.TooSimilarToLogin);
            return;
        }

        if (await _accountRepository.AccountWithSameNicknameExistsAsync(nickname, session.ConnectionClosed))
        {
            await SendNicknameRefusedAsync(session, NicknameErrors.AlreadyUsed);
            return;
        }

        session.Account.Nickname = nickname;

        await session.SendAsync(new NicknameAcceptedMessage());

        await _authenticationService.OnSuccessfullyAuthenticatedAsync(session, session.Account, -1);
    }

    /// <summary>
    /// Sends a nickname refusal message to the client session.
    /// </summary>
    /// <param name="session">The client session to send the message to.</param>
    /// <param name="error">The reason for the nickname refusal.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    private static async Task SendNicknameRefusedAsync(AuthSession session, NicknameErrors error)
    {
        await session.SendAsync(new NicknameRefusedMessage { Reason = (sbyte)error });
    }
}
