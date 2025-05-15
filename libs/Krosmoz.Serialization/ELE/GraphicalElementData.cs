// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.ELE;

public abstract class GraphicalElementData
{
    public int Id { get; set; }

    public GraphicalElementTypes Type { get; set; }

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
