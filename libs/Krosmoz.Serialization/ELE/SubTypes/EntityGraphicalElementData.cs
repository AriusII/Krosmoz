// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.ELE.SubTypes;

public sealed class EntityGraphicalElementData : GraphicalElementData
{
    public string EntityLook { get; set; }

    public bool HorizontalSymmetry { get; set; }

    public bool PlayAnimation { get; set; }

    public bool PlayAnimStatic { get; set; }

    public int MinDelay { get; set; }

    public int MaxDelay { get; set; }

    public EntityGraphicalElementData(int id, GraphicalElementTypes type) : base(id, type)
    {
        EntityLook = string.Empty;
    }

    public override void Deserialize(BigEndianReader reader, sbyte version)
    {
        EntityLook = reader.ReadUtfPrefixedLength32();
        HorizontalSymmetry = reader.ReadBoolean();

        if (version >= 7)
            PlayAnimation = reader.ReadBoolean();

        if (version >= 6)
            PlayAnimStatic = reader.ReadBoolean();

        if (version >= 5)
        {
            MinDelay = reader.ReadInt32();
            MaxDelay = reader.ReadInt32();
        }
    }
}
