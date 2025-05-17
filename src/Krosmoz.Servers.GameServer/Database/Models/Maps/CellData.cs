// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Servers.GameServer.Database.Models.Maps;

public struct CellData
{
    public short Id;

    public byte MapChangeData;

    public byte MoveZone;

    public sbyte Speed;

    public byte Floor;

    public byte LosMov;
}
