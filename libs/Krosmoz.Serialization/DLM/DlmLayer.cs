// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Cache;
using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.DLM;

public sealed class DlmLayer : ObjectModel
{
    public DlmMap Map { get; }

    public int LayerId
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public DlmCell[] Cells
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public DlmLayer(DlmMap map)
    {
        Map = map;
        Cells = [];
    }

    public void Deserialize(BigEndianReader reader)
    {
        LayerId = reader.ReadInt32();
        Cells = new DlmCell[reader.ReadInt16()];
        for (var i = 0; i < Cells.Length; i++)
        {
            Cells[i] = new DlmCell(this);
            Cells[i].Deserialize(reader);
        }
    }
}
