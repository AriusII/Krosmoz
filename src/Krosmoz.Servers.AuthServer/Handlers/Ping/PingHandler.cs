// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Network.Dispatcher.Attributes;
using Krosmoz.Protocol.Messages.Common.Basic;
using Krosmoz.Servers.AuthServer.Network.Transport;

namespace Krosmoz.Servers.AuthServer.Handlers.Ping;

/// <summary>
/// Handles ping-related operations.
/// </summary>
public sealed class PingHandler
{
    /// <summary>
    /// Handles the basic ping message asynchronously.
    /// </summary>
    /// <param name="session">The authentication session of the user.</param>
    /// <param name="message">The basic ping message containing the ping details.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    [MessageHandler]
    public async Task HandleBasicPingAsync(AuthSession session, BasicPingMessage message)
    {
        await session.SendAsync(new BasicPongMessage { Quiet = message.Quiet });
    }
}
