// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Cache;
using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.D2P;

public sealed class D2PIndexTable : ObjectModel
{
    public const int TableOffset = -24;
    public const SeekOrigin TableSeekOrigin = SeekOrigin.End;

    public D2PFile Container { get; }

    public uint OffsetBase
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public uint Size
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public uint EntriesDefinitionOffset
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public uint EntriesCount
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public uint PropertiesOffset
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public uint PropertiesCount
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public D2PIndexTable(D2PFile container)
    {
        Container = container;
    }

    public void ReadTable(BigEndianReader reader)
    {
        OffsetBase = reader.ReadUInt32();
        Size = reader.ReadUInt32();
        EntriesDefinitionOffset = reader.ReadUInt32();
        EntriesCount = reader.ReadUInt32();
        PropertiesOffset = reader.ReadUInt32();
        PropertiesCount = reader.ReadUInt32();
    }
}
