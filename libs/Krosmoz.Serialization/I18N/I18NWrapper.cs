// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Collections.Concurrent;
using Krosmoz.Serialization.Constants;
using Krosmoz.Serialization.D2I;

namespace Krosmoz.Serialization.I18N;

/// <summary>
/// Provides functionality to manage and access internationalization (I18N) data.
/// </summary>
public sealed class I18NWrapper
{
    private readonly ConcurrentDictionary<I18NLanguages, D2IFile> _d2IFiles;

    /// <summary>
    /// Initializes a new instance of the <see cref="I18NWrapper"/> class.
    /// </summary>
    public I18NWrapper()
    {
        _d2IFiles = [];
    }

    /// <summary>
    /// Loads all D2I files from the specified directory and maps them to their respective languages.
    /// </summary>
    public void Load()
    {
        Parallel.ForEach(Directory.EnumerateFiles(PathConstants.Directories.I18NPath, "*.d2i"), filePath =>
        {
            var d2IFile = new D2IFile(filePath);
            d2IFile.Load();
            _d2IFiles.TryAdd(Path.GetFileNameWithoutExtension(filePath)[^2..].ShortNameToLanguage(), d2IFile);
        });
    }

    /// <summary>
    /// Retrieves the D2I file associated with the specified language.
    /// </summary>
    /// <param name="language">The language for which to retrieve the D2I file.</param>
    /// <returns>The <see cref="D2IFile"/> associated with the specified language.</returns>
    public D2IFile GetD2I(I18NLanguages language)
    {
        return _d2IFiles[language];
    }

    /// <summary>
    /// Retrieves the text associated with the specified ID in the given language.
    /// </summary>
    /// <param name="language">The language in which to retrieve the text.</param>
    /// <param name="id">The ID of the text to retrieve.</param>
    /// <returns>The text associated with the specified ID.</returns>
    public string GetText(I18NLanguages language, int id)
    {
        return _d2IFiles[language].GetText(id);
    }

    /// <summary>
    /// Retrieves the text associated with the specified string ID in the given language.
    /// </summary>
    /// <param name="language">The language in which to retrieve the text.</param>
    /// <param name="id">The string ID of the text to retrieve.</param>
    /// <returns>The text associated with the specified string ID.</returns>
    public string GetText(I18NLanguages language, string id)
    {
        return _d2IFiles[language].GetText(id);
    }

    /// <summary>
    /// Retrieves the order index associated with the specified key in the given language.
    /// </summary>
    /// <param name="languages">The language in which to retrieve the order index.</param>
    /// <param name="key">The key for which to retrieve the order index.</param>
    /// <returns>The order index associated with the specified key.</returns>
    public int GetOrderIndex(I18NLanguages languages, int key)
    {
        return _d2IFiles[languages].GetOrderIndex(key);
    }
}
