// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Drawing;
using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.ELE.SubTypes;

public class NormalGraphicalElementData : GraphicalElementData
{
    public int GfxId { get; set; }

    public sbyte Height { get; set; }

    public bool HorizontalSymmetry { get; set; }

    public Point Origin { get; set; }

    public Point Size { get; set; }

    public NormalGraphicalElementData(int id, GraphicalElementTypes type) : base(id, type)
    {
    }

    public override void Deserialize(BigEndianReader reader, sbyte version)
    {
        GfxId = reader.ReadInt32();
        Height = reader.ReadInt8();
        HorizontalSymmetry = reader.ReadBoolean();
        Origin = new Point(reader.ReadInt16(), reader.ReadInt16());
        Size = new Point(reader.ReadInt16(), reader.ReadInt16());
    }
}
