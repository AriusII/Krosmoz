// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Collections.Frozen;
using Krosmoz.Core.Services;
using Krosmoz.Protocol.Datacenter.Communication;
using Krosmoz.Serialization.I18N;
using Krosmoz.Serialization.Repository;

namespace Krosmoz.Servers.AuthServer.Database.Repositories.Communication;

/// <summary>
/// Represents a repository for managing censored words in the database.
/// </summary>
public sealed class CensoredWordRepository : ICensoredWordRepository, IInitializableService
{
    private readonly IDatacenterRepository _datacenterRepository;

    private FrozenSet<CensoredWord> _censoredWords;

    /// <summary>
    /// Initializes the repository by loading censored words from the datacenter repository
    /// and storing them in a frozen set for efficient access.
    /// </summary>
    public void Initialize()
    {
        _censoredWords = _datacenterRepository.GetObjects<CensoredWord>().ToFrozenSet();
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="CensoredWordRepository"/> class.
    /// </summary>
    /// <param name="datacenterRepository">The repository for accessing datacenter objects.</param>
    public CensoredWordRepository(IDatacenterRepository datacenterRepository)
    {
        _datacenterRepository = datacenterRepository;
        _censoredWords = [];
    }

    /// <summary>
    /// Retrieves a collection of censored words for the specified language.
    /// </summary>
    /// <param name="language">The language for which to retrieve censored words.</param>
    /// <returns>An enumerable collection of censored words for the specified language.</returns>
    /// <exception cref="ArgumentOutOfRangeException">Thrown when the specified language is not supported.</exception>
    public IEnumerable<CensoredWord> GetCensoredWords(I18NLanguages language)
    {
        var shortName = language switch
        {
            I18NLanguages.English => "en",
            I18NLanguages.French => "fr",
            I18NLanguages.Spanish => "es",
            _ => throw new ArgumentOutOfRangeException(nameof(language))
        };

        return _censoredWords.Where(x => x.Language.Equals(shortName));
    }
}
