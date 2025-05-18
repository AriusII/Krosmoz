// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums.Custom;
using Microsoft.Extensions.Configuration;

namespace Krosmoz.Servers.GameServer.Services.OptionalFeatures;

/// <summary>
/// Provides functionality to manage optional features.
/// </summary>
public sealed class OptionalFeatureService : IOptionalFeatureService
{
    private readonly OptionalFeatureIds[] _features;

    /// <summary>
    /// Initializes a new instance of the <see cref="OptionalFeatureService"/> class.
    /// </summary>
    /// <param name="configuration">The configuration instance used to retrieve enabled optional features.</param>
    public OptionalFeatureService(IConfiguration configuration)
    {
        _features = configuration.GetRequiredSection("OptionalFeatures").Get<OptionalFeatureIds[]>()!;
    }

    /// <summary>
    /// Retrieves a collection of enabled optional features.
    /// </summary>
    /// <returns>
    /// An <see cref="IEnumerable{T}"/> containing the IDs of the enabled optional features.
    /// </returns>
    public IEnumerable<OptionalFeatureIds> GetEnabledFeatures()
    {
        return _features;
    }

    /// <summary>
    /// Determines whether a specific optional feature is enabled.
    /// </summary>
    /// <param name="featureId">The ID of the optional feature to check.</param>
    /// <returns>
    /// <c>true</c> if the feature is enabled; otherwise, <c>false</c>.
    /// </returns>
    public bool IsFeatureEnabled(OptionalFeatureIds featureId)
    {
        return _features.Contains(featureId);
    }
}
