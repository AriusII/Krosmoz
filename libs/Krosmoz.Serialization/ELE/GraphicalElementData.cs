// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Cache;
using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.ELE;

public abstract class GraphicalElementData : ObjectModel
{
    public int Id
    {
        get => field;
        set => SetPropertyChanged(ref field, value);
    }

    public GraphicalElementTypes Type
    {
        get => field;
        set => SetPropertyChanged(ref field, value);
    }

    public GraphicalElementData(int id, GraphicalElementTypes type)
    {
        Id = id;
        Type = type;
    }

    public virtual void Deserialize(BigEndianReader reader, sbyte version)
    {
        throw new NotImplementedException();
    }
}
