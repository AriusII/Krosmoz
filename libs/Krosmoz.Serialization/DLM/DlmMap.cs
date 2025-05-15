// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Drawing;
using System.Text;
using Krosmoz.Core.Cache;
using Krosmoz.Core.IO.Binary;
using Krosmoz.Serialization.Constants;
using Krosmoz.Serialization.DLM.Elements;
using Krosmoz.Serialization.ELE;
using Krosmoz.Serialization.ELE.SubTypes;

namespace Krosmoz.Serialization.DLM;

public sealed class DlmMap : ObjectModel
{
    public sbyte Version
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public uint Id
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public bool Encrypted
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public sbyte EncryptionVersion
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public uint RelativeId
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public DlmMapTypes Type
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int SubAreaId
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int TopNeighbourId
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int BottomNeighbourId
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int LeftNeighbourId
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int RightNeighbourId
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int ShadowBonusOnEntities
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public Color Background
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public double ZoomScale
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public Point ZoomOffset
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public bool UseLowPassFilter
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public bool UseReverb
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int PresetId
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public DlmFixture[] BackgroundFixtures
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public DlmFixture[] ForegroundFixtures
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int Signature
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int GroundCrc
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public DlmLayer[] Layers
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public DlmCellData[] Cells
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public bool UsingNewMovementSystem
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public List<short> TopArrowCells { get; }

    public List<short> BottomArrowCells { get; }

    public List<short> LeftArrowCells { get; }

    public List<short> RightArrowCells { get; }

    public DlmMap()
    {
        BackgroundFixtures = [];
        ForegroundFixtures = [];
        Layers = [];
        Cells = [];
        TopArrowCells = [];
        BottomArrowCells = [];
        LeftArrowCells = [];
        RightArrowCells = [];
        ZoomScale = 1;
    }

    public void Deserialize(BigEndianReader reader)
    {
        Version = reader.ReadInt8();
        Id = reader.ReadUInt32();

        if (Version >= 7)
        {
            Encrypted = reader.ReadBoolean();
            EncryptionVersion = reader.ReadInt8();

            if (Encrypted)
            {
                var buffer = reader.ReadSpan(reader.ReadInt32()).ToArray();
                var bytes = Encoding.Default.GetBytes(AtouinConstants.MapEncryptionKey);

                for (var i = 0; i < buffer.Length; ++i)
                    buffer[i] ^= bytes[i % AtouinConstants.MapEncryptionKey.Length];

                reader = new BigEndianReader(buffer);
            }
        }

        RelativeId = reader.ReadUInt32();
        Type = (DlmMapTypes)reader.ReadInt8();
        SubAreaId = reader.ReadInt32();
        TopNeighbourId = reader.ReadInt32();
        BottomNeighbourId = reader.ReadInt32();
        LeftNeighbourId = reader.ReadInt32();
        RightNeighbourId = reader.ReadInt32();
        ShadowBonusOnEntities = reader.ReadInt32();

        if (Version >= 3)
            Background = Color.FromArgb((reader.ReadInt8() & byte.MaxValue) << 16 | (reader.ReadInt8() & byte.MaxValue) << 8 | reader.ReadInt8() & byte.MaxValue);

        if (Version >= 4)
        {
            ZoomScale = reader.ReadUInt16() / 100d;
            ZoomOffset = new Point(reader.ReadInt16(), reader.ReadInt16());
        }

        UseLowPassFilter = reader.ReadBoolean();
        UseReverb = reader.ReadBoolean();

        if (UseReverb)
            PresetId = reader.ReadInt32();
        else
            PresetId = -1;

        BackgroundFixtures = new DlmFixture[reader.ReadInt8()];

        for (var i = 0; i < BackgroundFixtures.Length; ++i)
        {
            var backgroundFixture = new DlmFixture(this);
            backgroundFixture.Deserialize(reader);
            BackgroundFixtures[i] = backgroundFixture;
        }

        ForegroundFixtures = new DlmFixture[reader.ReadInt8()];

        for (var i = 0; i < ForegroundFixtures.Length; ++i)
        {
            var foregroundFixture = new DlmFixture(this);
            foregroundFixture.Deserialize(reader);
            ForegroundFixtures[i] = foregroundFixture;
        }

        Signature = reader.ReadInt32();
        GroundCrc = reader.ReadInt32();
        Layers = new DlmLayer[reader.ReadInt8()];

        for (var i = 0; i < Layers.Length; ++i)
        {
            var layer = new DlmLayer(this);
            layer.Deserialize(reader);
            Layers[i] = layer;
        }

        Cells = new DlmCellData[AtouinConstants.MapCellsCount];

        byte? oldMvtSystem = null;

        for (short i = 0; i < Cells.Length; ++i)
        {
            var cellData = new DlmCellData(this, i);
            cellData.Deserialize(reader);
            Cells[i] = cellData;

            oldMvtSystem ??= cellData.MoveZone;

            if (cellData.MoveZone != oldMvtSystem.GetValueOrDefault())
                UsingNewMovementSystem = true;
        }
    }

    public IEnumerable<NormalGraphicalElementData> GetGraphicalElements(GraphicalElementFile file, bool excludeFirstLayer = false)
    {
        var elements = new List<NormalGraphicalElementData>();

        foreach (var (layerIndex, layer) in Layers.Index())
        {
            if (excludeFirstLayer && layerIndex is 0)
                continue;

            foreach (var cell in layer.Cells)
            {
                foreach (var element in cell.Elements.OfType<DlmGraphicalElement>())
                {
                    if (file.GetGraphicalElementData((int)element.ElementId) is NormalGraphicalElementData normal)
                        elements.Add(normal);
                }
            }
        }

        return elements;
    }
}
