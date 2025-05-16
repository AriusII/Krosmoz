// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.AuthServer.Network.Transport;

namespace Krosmoz.Servers.AuthServer.Services.Queue;

/// <summary>
/// Defines the contract for a queue service that manages authentication sessions.
/// </summary>
public interface IQueueService
{
    /// <summary>
    /// Adds an authentication session to the queue.
    /// </summary>
    /// <param name="session">The authentication session to enqueue.</param>
    void Enqueue(AuthSession session);

    /// <summary>
    /// Removes an authentication session from the queue.
    /// </summary>
    /// <param name="session">The authentication session to dequeue.</param>
    void Dequeue(AuthSession session);

    /// <summary>
    /// Sends the current queue status to a specific authentication session.
    /// </summary>
    /// <param name="session">The authentication session to send the status to.</param>
    /// <param name="position">The position of the session in the queue.</param>
    /// <param name="total">The total number of sessions in the queue.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    ValueTask SendQueueStatusAsync(AuthSession session, ushort position, ushort total);
}
