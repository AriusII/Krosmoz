// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Network.Metadata;
using Krosmoz.Core.Network.Transport;

namespace Krosmoz.Core.Network.Dispatcher;

/// <summary>
/// Defines a contract for dispatching Dofus messages to a specific TCP session.
/// </summary>
public interface IMessageDispatcher
{
    /// <summary>
    /// Dispatches a Dofus message asynchronously to the specified TCP session.
    /// </summary>
    /// <param name="session">The <see cref="TcpSession"/> representing the target session.</param>
    /// <param name="message">The <see cref="DofusMessage"/> to be dispatched.</param>
    /// <returns>A <see cref="Task"/> representing the asynchronous operation.</returns>
    Task DispatchMessageAsync(TcpSession session, DofusMessage message);
}
