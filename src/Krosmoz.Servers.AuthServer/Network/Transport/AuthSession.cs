// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Net.Sockets;
using Krosmoz.Core.Network.Dispatcher;
using Krosmoz.Core.Network.Factory;
using Krosmoz.Core.Network.Framing;
using Krosmoz.Core.Network.Transport;
using Krosmoz.Servers.AuthServer.Database.Models.Accounts;
using Microsoft.Extensions.Logging;

namespace Krosmoz.Servers.AuthServer.Network.Transport;

/// <summary>
/// Represents an authentication session that handles communication with a client.
/// </summary>
public sealed class AuthSession : TcpSession
{
    /// <summary>
    /// Gets or sets the account associated with the session.
    /// </summary>
    public AccountRecord Account { get; set; }

    /// <summary>
    /// Gets or sets the game server ID associated with the session.
    /// </summary>
    public int AutoSelectServerId { get; set; }

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
        Account = null!;
    }

    /// <summary>
    /// Returns a string representation of the authentication session.
    /// </summary>
    /// <returns>
    /// A string containing the account's nickname if available, otherwise the account's username.
    /// If no account is associated, the base string representation is returned.
    /// </returns>
    public override string ToString()
    {
        return Account is null
            ? base.ToString()
            : Account.Nickname ?? Account.Username;
    }
}
