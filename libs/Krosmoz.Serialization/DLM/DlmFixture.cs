// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Drawing;
using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.DLM;

public sealed class DlmFixture
{
    public DlmMap Map { get; }

    public int FixtureId { get; set; }

    public Point Offset { get; set; }

    public int Hue { get; set; }

    public byte RedMultiplier { get; set; }

    public byte GreenMultiplier { get; set; }

    public byte BlueMultiplier { get; set; }

    public byte Alpha { get; set; }

    public Point Scale { get; set; }

    public short Rotation { get; set; }

    public DlmFixture(DlmMap map)
    {
        Map = map;
    }

    public void Deserialize(BigEndianReader reader)
    {
        FixtureId = reader.ReadInt32();
        Offset = new Point(reader.ReadInt16(), reader.ReadInt16());
        Rotation = reader.ReadInt16();
        Scale = new Point(reader.ReadInt16(), reader.ReadInt16());
        RedMultiplier = reader.ReadUInt8();
        GreenMultiplier = reader.ReadUInt8();
        BlueMultiplier = reader.ReadUInt8();
        Hue = RedMultiplier | GreenMultiplier | BlueMultiplier;
        Alpha = reader.ReadUInt8();
    }
}
