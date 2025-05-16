// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Net.Sockets;
using Krosmoz.Core.Network.Dispatcher;
using Krosmoz.Core.Network.Factory;
using Krosmoz.Core.Network.Framing;
using Krosmoz.Core.Network.Transport;
using Microsoft.Extensions.Logging;

namespace Krosmoz.Servers.AuthServer.Network.Transport;

/// <summary>
/// Represents an authentication session that handles communication with a client.
/// </summary>
public sealed class AuthSession : TcpSession
{
    /// <summary>
    /// Initializes a new instance of the <see cref="AuthSession"/> class.
    /// </summary>
    /// <param name="socket">The socket used for the session's network communication.</param>
    /// <param name="messageDecoder">The decoder for processing incoming messages.</param>
    /// <param name="messageEncoder">The encoder for preparing outgoing messages.</param>
    /// <param name="messageDispatcher">The dispatcher for routing messages to their handlers.</param>
    /// <param name="messageFactory">The factory for creating message instances.</param>
    /// <param name="logger">The logger for logging session-related information.</param>
    public AuthSession(
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
