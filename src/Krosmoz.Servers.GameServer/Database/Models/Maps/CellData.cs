// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Runtime.InteropServices;

namespace Krosmoz.Servers.GameServer.Database.Models.Maps;

[StructLayout(LayoutKind.Explicit)]
public sealed class CellData
{
    [FieldOffset(0)]
    public short Id;

    [FieldOffset(2)]
    public byte MapChangeData;

    [FieldOffset(3)]
    public byte MoveZone;

    [FieldOffset(4)]
    public sbyte Speed;

    [FieldOffset(5)]
    public byte Floor;

    [FieldOffset(6)]
    public byte LosMov;

    [FieldOffset(0)]
    public long Data;
}
