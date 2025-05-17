// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Net.Sockets;
using Krosmoz.Core.Network.Dispatcher;
using Krosmoz.Core.Network.Factory;
using Krosmoz.Core.Network.Framing;
using Krosmoz.Core.Network.Transport;
using Microsoft.Extensions.Logging;

namespace Krosmoz.Servers.GameServer.Network.Transport;

/// <summary>
/// Represents a game session that manages communication and message handling
/// for a connected client in the game server.
/// </summary>
public sealed class GameSession : TcpSession
{
    /// <summary>
    /// Initializes a new instance of the <see cref="GameSession"/> class.
    /// </summary>
    /// <param name="socket">The socket used for the session's communication.</param>
    /// <param name="messageDecoder">The decoder used to decode incoming messages.</param>
    /// <param name="messageEncoder">The encoder used to encode outgoing messages.</param>
    /// <param name="messageDispatcher">The dispatcher responsible for handling messages.</param>
    /// <param name="messageFactory">The factory used to create message instances.</param>
    /// <param name="logger">The logger used for logging session-related events.</param>
    public GameSession(
        Socket socket,
        DofusMessageDecoder messageDecoder,
        DofusMessageEncoder messageEncoder,
        IMessageDispatcher messageDispatcher,
        IMessageFactory messageFactory,
        ILogger<TcpSession> logger)
        : base(socket, messageDecoder, messageEncoder, messageDispatcher, messageFactory, logger)
    {
    }
}
