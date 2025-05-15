// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.ELE;

/// <summary>
/// Represents a Ele file.
/// </summary>
public sealed class GraphicalElementFile
{
    /// <summary>
    /// Gets the version of the graphical element file.
    /// </summary>
    public sbyte Version { get; private set; }

    /// <summary>
    /// Gets the dictionary of graphical elements, where the key is the element ID
    /// and the value is the corresponding graphical element data.
    /// </summary>
    public Dictionary<int, GraphicalElementData> GraphicalElements { get; }

    /// <summary>
    /// Gets the list of gfxId used in the file.
    /// </summary>
    public List<int> GfxIds { get; }

    /// <summary>
    /// Initializes a new instance of the <see cref="GraphicalElementFile"/> class.
    /// </summary>
    public GraphicalElementFile()
    {
        GraphicalElements = [];
        GfxIds = [];
    }

    /// <summary>
    /// Loads the graphical element file from the specified binary reader.
    /// </summary>
    /// <param name="reader">The binary reader to read data from.</param>
    /// <exception cref="Exception">Thrown if the file header is invalid.</exception>
    public void Load(BigEndianReader reader)
    {
        Version = reader.ReadInt8();

        var elementsCount = reader.ReadInt32();

        for (var i = 0; i < elementsCount; i++)
        {
            if (Version >= 9)
                reader.Seek(SeekOrigin.Current, sizeof(ushort));

            var elementId = reader.ReadInt32();

            var elementType = (GraphicalElementTypes)reader.ReadInt8();

            var element = GraphicalElementFactory.Create(elementId, elementType);

            element.Deserialize(reader, Version);

            GraphicalElements.Add(elementId, element);
        }

        if (Version >= 8)
        {
            var gfxCount = reader.ReadInt32();

            for (var i = 0; i < gfxCount; i++)
                GfxIds.Add(reader.ReadInt32());
        }
    }

    /// <summary>
    /// Retrieves the graphical element data for the specified element ID.
    /// </summary>
    /// <param name="elementId">The ID of the graphical element to retrieve.</param>
    /// <returns>The graphical element data, or <c>null</c> if not found.</returns>
    public GraphicalElementData? GetGraphicalElementData(int elementId)
    {
        return GraphicalElements.GetValueOrDefault(elementId);
    }

    /// <summary>
    /// Determines whether the specified graphical ID (GfxId) is a JPG.
    /// </summary>
    /// <param name="gfxId">The graphical ID to check.</param>
    /// <returns><c>true</c> if the graphical ID is a JPG; otherwise, <c>false</c>.</returns>
    public bool IsJpg(int gfxId)
    {
        return GfxIds.Contains(gfxId);
    }
}
