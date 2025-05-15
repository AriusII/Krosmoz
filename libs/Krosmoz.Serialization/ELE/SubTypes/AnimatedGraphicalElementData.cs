// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.ELE.SubTypes;

public sealed class AnimatedGraphicalElementData : NormalGraphicalElementData
{
    public int MinDelay { get; set; }

    public int MaxDelay { get; set; }

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
