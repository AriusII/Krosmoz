// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using MemoryPack;

namespace Krosmoz.Servers.GameServer.Database.Models.Maps;

[MemoryPackable]
public sealed partial class CellData
{
    public short Id { get; set; }

    public byte MapChangeData { get; set; }

    public byte MoveZone { get; set; }

    public sbyte Speed { get; set; }

    public byte Floor { get; set; }

    public byte LosMov { get; set; }
}
