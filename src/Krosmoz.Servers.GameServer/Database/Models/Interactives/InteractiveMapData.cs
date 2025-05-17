// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Runtime.InteropServices;

namespace Krosmoz.Servers.GameServer.Database.Models.Interactives;

[StructLayout(LayoutKind.Explicit)]
public struct InteractiveMapData
{
    [FieldOffset(0)]
    public int MapId;

    [FieldOffset(4)]
    public bool OnMap;

    [FieldOffset(5)]
    public short CellId;

    [FieldOffset(0)]
    public long Data;
}
