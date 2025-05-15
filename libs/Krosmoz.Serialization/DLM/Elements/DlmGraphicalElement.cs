// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Drawing;
using Krosmoz.Core.IO.Binary;
using Krosmoz.Serialization.Constants;

namespace Krosmoz.Serialization.DLM.Elements;

public sealed class DlmGraphicalElement : DlmBasicElement
{
    public uint ElementId
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public ColorMultiplicator Hue
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public ColorMultiplicator Shadow
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public ColorMultiplicator FinalTeint
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public Point Offset
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public Point PixelOffset
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int Altitude
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public uint Identifier
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public DlmGraphicalElement(DlmCell cell, DlmElementTypes type) : base(cell, type)
    {
        Hue = new ColorMultiplicator(0, 0, 0);
        Shadow = new ColorMultiplicator(0, 0, 0);
        FinalTeint = new ColorMultiplicator(0, 0, 0);
    }

    public override void Deserialize(BigEndianReader reader)
    {
        ElementId = reader.ReadUInt32();
        Hue = new ColorMultiplicator(reader.ReadInt8(), reader.ReadInt8(), reader.ReadInt8());
        Shadow = new ColorMultiplicator(reader.ReadInt8(), reader.ReadInt8(), reader.ReadInt8());

        if (Cell.Layer.Map.Version <= 4)
        {
            Offset = new Point(reader.ReadInt8(), reader.ReadInt8());
            PixelOffset = new Point((int)(Offset.X * AtouinConstants.CellHalfWidth), (int)(Offset.Y * AtouinConstants.CellHalfHeight));
        }
        else
        {
            PixelOffset = new Point(reader.ReadInt16(), reader.ReadInt16());
            Offset = new Point((int)(PixelOffset.X / AtouinConstants.CellHalfWidth), (int)(PixelOffset.Y / AtouinConstants.CellHalfHeight));
        }

        Altitude = reader.ReadInt8();
        Identifier = reader.ReadUInt32();

        var r = ColorMultiplicator.Clamp((Hue.Red + Shadow.Red + 128) * 2, 0, 512);
        var g = ColorMultiplicator.Clamp((Hue.Green + Shadow.Green + 128) * 2, 0, 512);
        var b = ColorMultiplicator.Clamp((Hue.Blue + Shadow.Blue + 128) * 2, 0, 512);

        FinalTeint = new ColorMultiplicator(r, g, b, true);
    }
}
