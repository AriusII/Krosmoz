// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.ELE.SubTypes;

public sealed class AnimatedGraphicalElementData : NormalGraphicalElementData
{
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

    public AnimatedGraphicalElementData(int id, GraphicalElementTypes type) : base(id, type)
    {
    }

    public override void Deserialize(BigEndianReader reader, sbyte version)
    {
        base.Deserialize(reader, version);

        if (version is 4)
        {
            MinDelay = reader.ReadInt32();
            MaxDelay = reader.ReadInt32();
        }
    }
}
