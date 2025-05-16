// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Network.Dispatcher.Attributes;
using Krosmoz.Protocol.Messages.Connection;
using Krosmoz.Servers.AuthServer.Network.Transport;
using Krosmoz.Servers.AuthServer.Services.Authentication;

namespace Krosmoz.Servers.AuthServer.Handlers.Authentication;

/// <summary>
/// Handles authentication-related operations.
/// </summary>
public sealed class AuthenticationHandler
{
    private readonly IAuthenticationService _authenticationService;

    /// <summary>
    /// Initializes a new instance of the <see cref="AuthenticationHandler"/> class.
    /// </summary>
    /// <param name="authenticationService">The service used to handle authentication logic.</param>
    public AuthenticationHandler(IAuthenticationService authenticationService)
    {
        _authenticationService = authenticationService;
    }

    /// <summary>
    /// Handles the identification message asynchronously.
    /// </summary>
    /// <param name="session">The authentication session of the user.</param>
    /// <param name="message">The identification message containing user credentials.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    [MessageHandler]
    public Task HandleIdentificationAsync(AuthSession session, IdentificationMessage message)
    {
        return _authenticationService.AuthenticateAsync(session, message);
    }
}
