// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Servers.GameServer.Database.Models.Maps;

public sealed class MapRecord
{
    public required int Id { get; init; }

    public required int X { get; init; }

    public required int Y { get; init; }

    public required bool Outdoor { get; init; }

    public required int Capabilities { get; init; }

    public required int SubAreaId { get; init; }

    public required int WorldMap { get; init; }

    public required bool HasPriorityOnWorldMap { get; init; }

    public required bool PrismAllowed { get; init; }

    public required bool PvpDisabled { get; init; }

    public required bool PlacementGenDisabled { get; init; }

    public required int MerchantsMax { get; init; }

    public required bool SpawnDisabled { get; init; }

    public required short[] RedCells { get; init; }

    public required short[] BlueCells { get; init; }

    public required CellData[] Cells { get; init; }

    public required int TopNeighborId { get; init; }

    public required int BottomNeighborId { get; init; }

    public required int LeftNeighborId { get; init; }

    public required int RightNeighborId { get; init; }

    public short? TopCellId { get; init; }

    public short? BottomCellId { get; init; }

    public short? LeftCellId { get; init; }

    public short? RightCellId { get; init; }
}
