// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Network.Dispatcher.Attributes;
using Krosmoz.Protocol.Messages.Connection.Register;
using Krosmoz.Servers.AuthServer.Network.Transport;
using Krosmoz.Servers.AuthServer.Services.Nickname;

namespace Krosmoz.Servers.AuthServer.Handlers.Nickname;

/// <summary>
/// Handles nickname-related operations.
/// </summary>
public sealed class NicknameHandler
{
    private readonly INicknameService _nicknameService;

    /// <summary>
    /// Initializes a new instance of the <see cref="NicknameHandler"/> class.
    /// </summary>
    /// <param name="nicknameService">The service used to handle nickname-related logic.</param>
    public NicknameHandler(INicknameService nicknameService)
    {
        _nicknameService = nicknameService;
    }

    /// <summary>
    /// Handles the nickname choice request asynchronously.
    /// </summary>
    /// <param name="session">The authentication session of the user.</param>
    /// <param name="message">The message containing the chosen nickname.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    [MessageHandler]
    public Task HandleNicknameChoiceRequestAsync(AuthSession session, NicknameChoiceRequestMessage message)
    {
        return _nicknameService.ChoiceNicknameAsync(session, message.Nickname);
    }
}
