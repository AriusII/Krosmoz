// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Network.Dispatcher.Attributes;
using Krosmoz.Protocol.Messages.Connection;
using Krosmoz.Servers.AuthServer.Network.Transport;

namespace Krosmoz.Servers.AuthServer.Handlers.Authentication;

public sealed class AuthenticationHandler
{
    [MessageHandler]
    public Task HandleIdentificationAsync(AuthSession session, IdentificationMessage message)
    {
        return Task.CompletedTask;
    }
}
