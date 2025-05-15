// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.ELE.SubTypes;

public sealed class BlendedGraphicalElementData : NormalGraphicalElementData
{
    public string BlendMode
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public BlendedGraphicalElementData(int id, GraphicalElementTypes type) : base(id, type)
    {
        BlendMode = string.Empty;
    }

    public override void Deserialize(BigEndianReader reader, sbyte version)
    {
        base.Deserialize(reader, version);

        BlendMode = reader.ReadUtfPrefixedLength32();
    }
}
