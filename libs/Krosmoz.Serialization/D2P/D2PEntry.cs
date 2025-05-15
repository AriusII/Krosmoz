// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Cache;
using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.D2P;

public sealed class D2PEntry : ObjectModel
{
    private readonly byte[] _newData;

    public D2PFile Container { get; }

    public string FullFileName
    {
        get;
        set
        {
            SetPropertyChanged(ref field, value);
            OnPropertyChanged(nameof(FileName));
        }
    }

    public string FileName
    {
        get => Path.GetFileName(FullFileName);
        set => FullFileName = Path.Combine(Path.GetDirectoryName(FullFileName)!, value);
    }

    public D2PDirectory Directory
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int Index
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int Size
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public D2PEntryState State
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public D2PEntry(D2PFile container)
    {
        Container = container;
        Index = -1;
        _newData = [];
        FullFileName = string.Empty;
        Directory = null!;
    }

    public D2PEntry(D2PFile container, string fileName)
    {
        Container = container;
        FullFileName = fileName;
        Index = -1;
        _newData = [];
        Directory = null!;
    }

    public D2PEntry(D2PFile container, string fileName, byte[] data)
    {
        Container = container;
        FullFileName = fileName;
        _newData = data;
        State = D2PEntryState.Added;
        Size = data.Length;
        Index = -1;
        Directory = null!;
    }

    public void ReadEntryDefinition(BigEndianReader reader)
    {
        FullFileName = reader.ReadUtfPrefixedLength16();
        Index = reader.ReadInt32();
        Size = reader.ReadInt32();
    }

    public byte[] ReadEntry(BigEndianReader reader)
    {
        return State switch
        {
            D2PEntryState.None => reader.ReadSpan(Size).ToArray(),
            D2PEntryState.Dirty or D2PEntryState.Added => _newData,
            D2PEntryState.Removed => throw new Exception("Cannot read a removed entry."),
            _ => reader.ReadSpan(Size).ToArray()
        };
    }

    public string[] GetDirectoryNames()
    {
        return Path.GetDirectoryName(FullFileName)!.Split(['/', '\\'], StringSplitOptions.RemoveEmptyEntries);
    }
}
