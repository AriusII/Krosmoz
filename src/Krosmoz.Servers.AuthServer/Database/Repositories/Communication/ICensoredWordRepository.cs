// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Datacenter.Communication;
using Krosmoz.Serialization.I18N;

namespace Krosmoz.Servers.AuthServer.Database.Repositories.Communication;

/// <summary>
/// Defines the contract for a repository that manages censored words in the database.
/// </summary>
public interface ICensoredWordRepository
{
    /// <summary>
    /// Retrieves a collection of censored words for the specified language.
    /// </summary>
    /// <param name="language">The language for which to retrieve censored words.</param>
    /// <returns>An enumerable collection of censored words.</returns>
    IEnumerable<CensoredWord> GetCensoredWords(I18NLanguages language);
}
