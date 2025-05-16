// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.SourceGeneration.MessageHandler.Models;

/// <summary>
/// Represents metadata about a message handler method.
/// </summary>
/// <param name="ContainingTypeName">The fully qualified name of the type that contains the handler method.</param>
/// <param name="MethodName">The name of the handler method.</param>
/// <param name="SessionTypeName">The fully qualified name of the type representing the session parameter of the handler method.</param>
/// <param name="MessageTypeName">The fully qualified name of the type representing the message parameter of the handler method.</param>
public sealed record Handler(string ContainingTypeName, string MethodName, string SessionTypeName, string MessageTypeName);
