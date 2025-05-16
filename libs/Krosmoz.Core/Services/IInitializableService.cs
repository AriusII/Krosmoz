// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Core.Services;

/// <summary>
/// Represents a service that requires initialization logic.
/// </summary>
public interface IInitializableService
{
    /// <summary>
    /// Performs the initialization logic for the service.
    /// </summary>
    void Initialize();
}
