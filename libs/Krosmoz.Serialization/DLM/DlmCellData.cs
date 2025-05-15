// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Cache;
using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.DLM;

public sealed class DlmCellData : ObjectModel
{
    private short? _floor;
    private sbyte _rawFloor;
    private sbyte _rawArrow;
    private short? _arrow;

    public DlmMap Map { get; }

    public short Id { get; }

    public sbyte Speed
    {
        get => field;
        set => SetPropertyChanged(ref field, value);
    }

    public byte MapChangeData
    {
        get => field;
        set => SetPropertyChanged(ref field, value);
    }

    public byte MoveZone
    {
        get => field;
        set => SetPropertyChanged(ref field, value);
    }

    public byte LosMov
    {
        get => field;
        set => SetPropertyChanged(ref field, value);
    }

    public short Arrow
    {
        get => _arrow ??= (short)(15 & _rawArrow);
        set => SetPropertyChanged(ref field, value);
    }

    public bool Mov =>
        (LosMov & 1) is 1;

    public bool Los =>
        (LosMov & 2) >> 1 is 1;

    public bool NonWalkableDuringFight =>
        (LosMov & 4) >> 2 is 1;

    public bool Red =>
        (LosMov & 8) >> 3 is 1;

    public bool Blue =>
        (LosMov & 16) >> 4 is 1;

    public bool FarmCell =>
        (LosMov & 32) >> 5 is 1;

    public bool Visible =>
        (LosMov & 64) >> 6 is 1;

    public bool NonWalkableDuringRp =>
        (LosMov & 128) >> 7 is 1;

    public short Floor =>
        _floor ??= (short)(_rawFloor * 10);

    public bool HasLinkedZoneRp =>
        Mov && !FarmCell;

    public bool HasLinkedZoneFight =>
        Mov && !NonWalkableDuringFight && !FarmCell;

    public bool UseTopArrow =>
        (Arrow & 1) is not 0;

    public bool UseBottomArrow =>
        (Arrow & 2) is not 0;

    public bool UseRightArrow =>
        (Arrow & 4) is not 0;

    public bool UseLeftArrow =>
        (Arrow & 8) is not 0;

    public DlmCellData(DlmMap map, short id)
    {
        Map = map;
        Id = id;
    }

    public void Deserialize(BigEndianReader reader)
    {
        _rawFloor = reader.ReadInt8();

        if (Floor is -1280)
            return;

        LosMov = reader.ReadUInt8();
        Speed = reader.ReadInt8();
        MapChangeData = reader.ReadUInt8();

        if (Map.Version > 5)
            MoveZone = reader.ReadUInt8();

        if (Map.Version > 7)
        {
            _rawArrow = reader.ReadInt8();

            if (UseTopArrow)
                Map.TopArrowCells.Add(Id);

            if (UseBottomArrow)
                Map.BottomArrowCells.Add(Id);

            if (UseLeftArrow)
                Map.LeftArrowCells.Add(Id);

            if (UseRightArrow)
                Map.RightArrowCells.Add(Id);
        }
    }
}
