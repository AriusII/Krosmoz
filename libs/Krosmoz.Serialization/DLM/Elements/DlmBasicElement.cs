// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Cache;
using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.DLM.Elements;

public abstract class DlmBasicElement : ObjectModel
{
    public DlmCell Cell { get; }

    public DlmElementTypes Type { get; }

    protected DlmBasicElement(DlmCell cell, DlmElementTypes type)
    {
        Cell = cell;
        Type = type;
    }

    public virtual void Deserialize(BigEndianReader reader)
    {
        throw new NotImplementedException();
    }

    public static DlmBasicElement GetElementFromType(sbyte type, DlmCell cell)
    {
        var elementType = (DlmElementTypes)type;

        return elementType switch
        {
            DlmElementTypes.Graphical => new DlmGraphicalElement(cell, elementType),
            DlmElementTypes.Sound => new DlmSoundElement(cell, elementType),
            _ => throw new ArgumentOutOfRangeException(nameof(type))
        };
    }
}
