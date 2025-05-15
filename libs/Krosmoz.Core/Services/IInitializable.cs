// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Core.Services;

/// <summary>
/// Defines a contract for a service that requires initialization.
/// </summary>
public interface IInitializable
{
    /// <summary>
    /// Performs the initialization logic for the service.
    /// </summary>
    void Initialize();
}
