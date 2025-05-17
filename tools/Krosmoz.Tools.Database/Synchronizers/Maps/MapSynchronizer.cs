// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Datacenter.World;
using Krosmoz.Serialization.D2P;
using Krosmoz.Serialization.DLM;
using Krosmoz.Serialization.DLM.Elements;
using Krosmoz.Serialization.ELE;
using Krosmoz.Serialization.ELE.SubTypes;
using Krosmoz.Servers.GameServer.Database.Models.Interactives;
using Krosmoz.Servers.GameServer.Database.Models.Maps;
using Krosmoz.Tools.Database.Models;
using Krosmoz.Tools.Database.Synchronizers.Base;
using Microsoft.EntityFrameworkCore;

namespace Krosmoz.Tools.Database.Synchronizers.Maps;

/// <summary>
/// Synchronizes map data between the database and the datacenter repository.
/// </summary>
public sealed class MapSynchronizer : BaseSynchronizer
{
    /// <summary>
    /// Stores elements grouped by map ID.
    /// </summary>
    private readonly Dictionary<int, IdentifiableElement[]> _elements;

    /// <summary>
    /// Stores the list of map records to be synchronized.
    /// </summary>
    private readonly List<MapRecord> _maps;

    /// <summary>
    /// Stores the list of interactive records to be synchronized.
    /// </summary>
    private readonly List<InteractiveRecord> _interactives;

    /// <summary>
    /// Initializes a new instance of the <see cref="MapSynchronizer"/> class.
    /// </summary>
    public MapSynchronizer()
    {
        _elements = [];
        _maps = [];
        _interactives = [];
    }

    /// <summary>
    /// Synchronizes map and interactive data asynchronously.
    /// </summary>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    public override async Task SynchronizeAsync(CancellationToken cancellationToken)
    {
        await GameDbContext.Maps.ExecuteDeleteAsync(cancellationToken);
        await GameDbContext.Interactives.ExecuteDeleteAsync(cancellationToken);

        var d2PFile = DatacenterRepository.GetMapD2P();
        var eleFile = DatacenterRepository.GetEle();

        foreach (var mapPosition in DatacenterRepository.GetObjects<MapPosition>())
            GenerateMap(d2PFile, mapPosition, eleFile);

        var elements = _elements.Values
            .SelectMany(static x => x)
            .GroupBy(static x => x.Element.Identifier)
            .ToDictionary(static x => x.Key, static x => x.ToArray());

        foreach (var (_, value) in elements)
        {
            var matchedElement = value
                .OrderByDescending(static x => DistanceFromBorder(new MapPoint(x.Element.Cell.CellId)))
                .ThenBy(static x => Math.Abs(x.Element.PixelOffset.X) + Math.Abs(x.Element.PixelOffset.Y))
                .First();

            var baseElement = value.First();

            _interactives.Add(new InteractiveRecord
            {
                Id = (int)baseElement.Element.Identifier,
                GfxId = baseElement.GfxId,
                Animated = baseElement.Animated,
                ElementId = (int)baseElement.Element.ElementId,
                MapId = (int)matchedElement.Map.Id,
                MapsData = value.Select(x => new InteractiveMapData
                {
                    MapId = (int)x.Map.Id,
                    OnMap = matchedElement.Map.Id == x.Map.Id,
                    CellId = x.Element.Cell.CellId
                }).ToArray()
            });
        }

        GameDbContext.Maps.AddRange(_maps);
        GameDbContext.Interactives.AddRange(_interactives);

        await GameDbContext.SaveChangesAsync(cancellationToken);
    }

    /// <summary>
    /// Generates a map record and its associated interactives.
    /// </summary>
    /// <param name="d2PFile">The D2P file containing map data.</param>
    /// <param name="mapPosition">The position of the map in the datacenter.</param>
    /// <param name="eleFile">The ELE file containing graphical element data.</param>
    private void GenerateMap(D2PFile d2PFile, MapPosition mapPosition, GraphicalElementFile eleFile)
    {
        if (!DatacenterRepository.TryGetMap(d2PFile, mapPosition.Id, out var map))
            return;

        var mapRecord = new MapRecord
        {
            Id = mapPosition.Id,
            X = mapPosition.PosX,
            Y = mapPosition.PosY,
            Outdoor = mapPosition.Outdoor,
            Capabilities = mapPosition.Capabilities,
            SubAreaId = mapPosition.SubAreaId,
            WorldMap = mapPosition.WorldMap,
            HasPriorityOnWorldMap = mapPosition.HasPriorityOnWorldmap,
            PrismAllowed = true,
            PvpDisabled = false,
            PlacementGenDisabled = map.Cells.Any(static x => x.Blue),
            MerchantsMax = 5,
            SpawnDisabled = false,
            RedCells = map.Cells.Where(static x => x.Red).Select(static x => x.Id).ToArray(),
            BlueCells = map.Cells.Where(static x => x.Blue).Select(static x => x.Id).ToArray(),
            Cells = map.Cells.Select(static x => new CellData
            {
                Id = x.Id,
                MapChangeData = x.MapChangeData,
                Floor = (byte)x.Floor,
                LosMov = x.LosMov,
                MoveZone = x.MoveZone,
                Speed = x.Speed
            }).ToArray(),
            BottomNeighborId = map.BottomNeighbourId,
            TopNeighborId = map.TopNeighbourId,
            LeftNeighborId = map.LeftNeighbourId,
            RightNeighborId = map.RightNeighbourId
        };

        _maps.Add(mapRecord);

        GenerateInteractives(map, eleFile);
    }

    /// <summary>
    /// Generates interactive elements for a given map.
    /// </summary>
    /// <param name="map">The map containing the elements.</param>
    /// <param name="eleFile">The ELE file containing graphical element data.</param>
    private void GenerateInteractives(DlmMap map, GraphicalElementFile eleFile)
    {
        var elements = map.Layers
            .SelectMany(static layer => layer.Cells)
            .SelectMany(static cell => cell.Elements.OfType<DlmGraphicalElement>().Where(static element => element.Identifier is not 0))
            .Select(element => new IdentifiableElement { Element = element, Map = map })
            .ToArray();

        _elements.Add((int)map.Id, elements);

        foreach (var element in elements)
        {
            var eleElement = eleFile.GraphicalElements.Values.FirstOrDefault(x => x.Id == element.Element.ElementId);

            if (eleElement is null)
                continue;

            element.GfxId = GetGfxId(eleElement);
            element.Animated = eleElement is AnimatedGraphicalElementData or EntityGraphicalElementData;
        }
    }

    /// <summary>
    /// Retrieves the GFX ID for a given graphical element.
    /// </summary>
    /// <param name="element">The graphical element.</param>
    /// <returns>The GFX ID of the element, or -1 if not found.</returns>
    private static int GetGfxId(GraphicalElementData element)
    {
        switch (element)
        {
            case EntityGraphicalElementData entity:
                var cleanedLook = entity.EntityLook.Replace("{", string.Empty).Replace("}", string.Empty);

                if (cleanedLook.Contains(','))
                    cleanedLook = cleanedLook.Split(',')[0];

                return int.TryParse(cleanedLook, out var id) ? id : -1;

            case NormalGraphicalElementData normal:
                return normal.GfxId;

            default:
                return -1;
        }
    }

    /// <summary>
    /// Calculates the distance of a point from the map border.
    /// </summary>
    /// <param name="point">The point to calculate the distance for.</param>
    /// <returns>The minimum distance from the point to the map border.</returns>
    private static double DistanceFromBorder(MapPoint point)
    {
        var borders = new[]
        {
            new LineSet(new MapPoint(27), new MapPoint(559)),
            new LineSet(new MapPoint(546), new MapPoint(559)),
            new LineSet(new MapPoint(0), new MapPoint(13)),
            new LineSet(new MapPoint(0), new MapPoint(532)),
        };

        return borders.Min(x => x.SquareDistanceToLine(point));
    }
}
