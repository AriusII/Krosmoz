// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.D2I;

/// <summary>
/// Represents a D2I file.
/// </summary>
public sealed class D2IFile
{
    /// <summary>
    /// The format string used for unknown text identifiers.
    /// </summary>
    private const string UnknownTextId = "[UNKNOWN_TEXT_ID_{0}]";

    /// <summary>
    /// The path to the D2I file.
    /// </summary>
    public string FilePath { get; }

    /// <summary>
    /// Gets the dictionary of indexed text entries, where the key is an integer identifier.
    /// </summary>
    public Dictionary<int, D2IText<int>> IndexedTexts { get; }

    /// <summary>
    /// Gets the dictionary of named text entries, where the key is a string identifier.
    /// </summary>
    public Dictionary<string, D2IText<string>> NamedTexts { get; }

    /// <summary>
    /// Gets the dictionary of sorted indexes, where the key is an integer identifier and the value is the order index.
    /// </summary>
    public Dictionary<int, int> SortedIndexes { get; }

    /// <summary>
    /// Initializes a new instance of the <see cref="D2IFile"/> class.
    /// </summary>
    /// <param name="filePath">The path to the D2I file.</param>
    public D2IFile(string filePath)
    {
        FilePath = filePath;
        IndexedTexts = [];
        NamedTexts = [];
        SortedIndexes = [];
    }

    /// <summary>
    /// Loads the D2I file and populates the indexed and named text dictionaries.
    /// </summary>
    public void Load()
    {
        var reader = new BigEndianReader(File.ReadAllBytes(FilePath));

        var indexPosition = reader.ReadInt32();
        reader.Seek(SeekOrigin.Begin, indexPosition);
        var indexLength = reader.ReadInt32();

        for (var i = 0; i < indexLength; i += 9)
        {
            var key = reader.ReadInt32();
            var notDiacritical = reader.ReadBoolean();
            var textPosition = reader.ReadInt32();
            var position = reader.Position;

            reader.Seek(SeekOrigin.Begin, textPosition);
            var text = reader.ReadUtfPrefixedLength16();
            reader.Seek(SeekOrigin.Begin, position);

            if (notDiacritical)
            {
                i += sizeof(int);

                var criticalPosition = reader.ReadInt32();

                position = reader.Position;

                reader.Seek(SeekOrigin.Begin, criticalPosition);
                var notDiacriticalText = reader.ReadUtfPrefixedLength16();
                reader.Seek(SeekOrigin.Begin, position);

                IndexedTexts.Add(key, new D2IText<int>(key, text, notDiacriticalText));
            }
            else
                IndexedTexts.Add(key, new D2IText<int>(key, text));
        }

        indexLength = reader.ReadInt32();

        while (indexLength > 0)
        {
            var position = reader.Position;
            var key = reader.ReadUtfPrefixedLength16();
            var textPosition = reader.ReadInt32();

            indexLength -= reader.Position - position;
            position = reader.Position;

            reader.Seek(SeekOrigin.Begin, textPosition);
            NamedTexts.Add(key, new D2IText<string>(key, reader.ReadUtfPrefixedLength16()));
            reader.Seek(SeekOrigin.Begin, position);
        }

        indexLength = reader.ReadInt32();

        var c = 0;

        while (indexLength > 0)
        {
            SortedIndexes.Add(reader.ReadInt32(), c++);
            indexLength -= sizeof(int);
        }
    }

    /// <summary>
    /// Gets the text associated with the specified integer identifier.
    /// </summary>
    /// <param name="id">The integer identifier.</param>
    /// <returns>The associated text, or a placeholder if not found.</returns>
    public string GetText(int id)
    {
        return IndexedTexts.TryGetValue(id, out var entry)
            ? entry.Text
            : string.Format(UnknownTextId, id);
    }

    /// <summary>
    /// Gets the text associated with the specified string identifier.
    /// </summary>
    /// <param name="id">The string identifier.</param>
    /// <returns>The associated text, or a placeholder if not found.</returns>
    public string GetText(string id)
    {
        return NamedTexts.TryGetValue(id, out var entry)
            ? entry.Text
            : string.Format(UnknownTextId, id);
    }

    /// <summary>
    /// Gets the order index of the specified key.
    /// </summary>
    /// <param name="key">The key to find the order index for.</param>
    /// <returns>The order index, or -1 if not found.</returns>
    public int GetOrderIndex(int key)
    {
        return SortedIndexes.GetValueOrDefault(key, -1);
    }
}
