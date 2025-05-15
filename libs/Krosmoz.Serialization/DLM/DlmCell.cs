// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.IO.Binary;
using Krosmoz.Serialization.DLM.Elements;

namespace Krosmoz.Serialization.DLM;

public sealed class DlmCell
{
    public DlmLayer Layer { get; }

    public short CellId { get; set; }

    public DlmBasicElement[] Elements { get; set; }

    public DlmCell(DlmLayer layer)
    {
        Layer = layer;
        Elements = [];
    }

    public void Deserialize(BigEndianReader reader)
    {
        CellId = reader.ReadInt16();
        Elements = new DlmBasicElement[reader.ReadInt16()];
        for (var i = 0; i < Elements.Length; i++)
        {
            var element = DlmBasicElement.GetElementFromType(reader.ReadInt8(), this);
            element.Deserialize(reader);
            Elements[i] = element;
        }
    }
}
