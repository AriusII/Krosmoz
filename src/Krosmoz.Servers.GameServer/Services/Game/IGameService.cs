// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Servers.GameServer.Network.Transport;

namespace Krosmoz.Servers.GameServer.Services.Game;

/// <summary>
/// Defines the contract for a service that manages and sends server-related information.
/// </summary>
public interface IGameService
{
    /// <summary>
    /// Gets the unique identifier of the server.
    /// </summary>
    int ServerId { get; }

    /// <summary>
    /// Gets the type of the server, indicating its game mode or purpose.
    /// </summary>
    ServerGameTypeIds ServerType { get; }

    /// <summary>
    /// Sends various server-related information asynchronously to the specified game session.
    /// </summary>
    /// <param name="session">The game session to which the information will be sent.</param>
    Task SendServerInfomationsAsync(GameSession session);
}
