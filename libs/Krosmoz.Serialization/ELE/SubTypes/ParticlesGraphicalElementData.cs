// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.ELE.SubTypes;

public sealed class ParticlesGraphicalElementData : GraphicalElementData
{
    public short ScriptId
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public ParticlesGraphicalElementData(int id, GraphicalElementTypes type) : base(id, type)
    {
    }

    public override void Deserialize(BigEndianReader reader, sbyte version)
    {
        ScriptId = reader.ReadInt16();
    }
}
