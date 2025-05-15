// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.D2P;

/// <summary>
/// Represents a property in a D2P file.
/// </summary>
public sealed class D2PProperty
{
    /// <summary>
    /// Gets or sets the key of the property.
    /// </summary>
    public string Key { get; set; }

    /// <summary>
    /// Gets or sets the value of the property.
    /// </summary>
    public string Value { get; set; }

    /// <summary>
    /// Initializes a new instance of the <see cref="D2PProperty"/> class.
    /// </summary>
    public D2PProperty()
    {
        Key = string.Empty;
        Value = string.Empty;
    }

    /// <summary>
    /// Deserializes the property from the specified binary reader.
    /// </summary>
    /// <param name="reader">The binary reader to read the property data from.</param>
    public void Deserialize(BigEndianReader reader)
    {
        Key = reader.ReadUtfPrefixedLength16();
        Value = reader.ReadUtfPrefixedLength16();
    }
}
