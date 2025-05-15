// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Drawing;
using Krosmoz.Core.Cache;
using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.DLM;

public sealed class DlmFixture : ObjectModel
{
    public DlmMap Map { get; }

    public int FixtureId
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public Point Offset
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int Hue
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public byte RedMultiplier
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public byte GreenMultiplier
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public byte BlueMultiplier
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public byte Alpha
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public Point Scale
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public short Rotation
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

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
