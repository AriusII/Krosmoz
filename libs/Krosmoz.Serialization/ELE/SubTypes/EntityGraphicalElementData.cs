// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.ELE.SubTypes;

public sealed class EntityGraphicalElementData : GraphicalElementData
{
    public string EntityLook
    {
        get => field;
        set => SetPropertyChanged(ref field, value);
    }

    public bool HorizontalSymmetry
    {
        get => field;
        set => SetPropertyChanged(ref field, value);
    }

    public bool PlayAnimation
    {
        get => field;
        set => SetPropertyChanged(ref field, value);
    }

    public bool PlayAnimStatic
    {
        get => field;
        set => SetPropertyChanged(ref field, value);
    }

    public int MinDelay
    {
        get => field;
        set => SetPropertyChanged(ref field, value);
    }

    public int MaxDelay
    {
        get => field;
        set => SetPropertyChanged(ref field, value);
    }

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
