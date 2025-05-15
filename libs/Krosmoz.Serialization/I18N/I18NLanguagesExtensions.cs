// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Serialization.I18N;

/// <summary>
/// Provides extension methods for converting between short language names and <see cref="I18NLanguages"/> enumeration values.
/// </summary>
public static class I18NLanguagesExtensions
{
    /// <summary>
    /// Converts a short language name to its corresponding <see cref="I18NLanguages"/> enumeration value.
    /// </summary>
    /// <param name="shortName">The short name of the language (e.g., "fr", "en", "es").</param>
    /// <returns>The corresponding <see cref="I18NLanguages"/> value.</returns>
    /// <exception cref="ArgumentOutOfRangeException">Thrown when the short name is not recognized.</exception>
    public static I18NLanguages ShortNameToLanguage(this string shortName)
    {
        return shortName switch
        {
            "fr" => I18NLanguages.French,
            "en" => I18NLanguages.English,
            "es" => I18NLanguages.Spanish,
            _ => throw new ArgumentOutOfRangeException(nameof(shortName))
        };
    }

    /// <summary>
    /// Converts an <see cref="I18NLanguages"/> enumeration value to its corresponding short language name.
    /// </summary>
    /// <param name="language">The <see cref="I18NLanguages"/> value to convert.</param>
    /// <returns>The short name of the language (e.g., "fr", "en", "es").</returns>
    /// <exception cref="ArgumentOutOfRangeException">Thrown when the language is not recognized.</exception>
    public static string LanguageToShortName(this I18NLanguages language)
    {
        return language switch
        {
            I18NLanguages.French => "fr",
            I18NLanguages.English => "en",
            I18NLanguages.Spanish => "es",
            _ => throw new ArgumentOutOfRangeException(nameof(language))
        };
    }
}
