// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Core.Network.Dispatcher.Attributes;

/// <summary>
/// Specifies that the attributed method is a message handler for network messages.
/// </summary>
/// <remarks>
/// This attribute is used to mark methods that handle specific network messages
/// in the dispatcher system.
/// </remarks>
[AttributeUsage(AttributeTargets.Method)]
public sealed class MessageHandlerAttribute : Attribute;
