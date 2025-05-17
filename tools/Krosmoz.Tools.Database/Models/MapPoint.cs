// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Serialization.Constants;

namespace Krosmoz.Tools.Database.Models;

/// <summary>
/// Represents a point on the map, defined by its cell identifier or coordinates.
/// </summary>
public sealed class MapPoint
{
    /// <summary>
    /// A static reference grid for orthogonal map points.
    /// </summary>
    private static readonly MapPoint[] s_orthogonalGridReference = new MapPoint[AtouinConstants.MapCellsCount];

    /// <summary>
    /// Indicates whether the static grid has been initialized.
    /// </summary>
    private static bool s_initialized;

    /// <summary>
    /// Gets the cell identifier of the map point.
    /// </summary>
    public short CellId { get; private set; }

    /// <summary>
    /// Gets the X-coordinate of the map point.
    /// </summary>
    public int X { get; private set; }

    /// <summary>
    /// Gets the Y-coordinate of the map point.
    /// </summary>
    public int Y { get; private set; }

    /// <summary>
    /// Initializes a new instance of the <see cref="MapPoint"/> class using a cell identifier.
    /// </summary>
    /// <param name="cellId">The cell identifier of the map point.</param>
    public MapPoint(short cellId)
    {
        CellId = cellId;

        SetFromCellId();
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="MapPoint"/> class using X and Y coordinates.
    /// </summary>
    /// <param name="x">The X-coordinate of the map point.</param>
    /// <param name="y">The Y-coordinate of the map point.</param>
    private MapPoint(int x, int y)
    {
        X = x;
        Y = y;

        SetFromCoords();
    }

    /// <summary>
    /// Sets the cell identifier based on the X and Y coordinates.
    /// </summary>
    private void SetFromCoords()
    {
        if (!s_initialized)
            InitializeStaticGrid();

        CellId = (short)((X - Y) * AtouinConstants.MapWidth + Y + (X - Y) / 2);
    }

    /// <summary>
    /// Sets the X and Y coordinates based on the cell identifier.
    /// </summary>
    private void SetFromCellId()
    {
        if (!s_initialized)
            InitializeStaticGrid();

        ArgumentOutOfRangeException.ThrowIfNegative(CellId);
        ArgumentOutOfRangeException.ThrowIfGreaterThan(CellId, (short)AtouinConstants.MapCellsCount);

        var point = s_orthogonalGridReference[CellId];
        X = point.X;
        Y = point.Y;
    }

    /// <summary>
    /// Initializes the static grid reference for orthogonal map points.
    /// </summary>
    private static void InitializeStaticGrid()
    {
        s_initialized = true;

        var posX = 0;
        var posY = 0;
        var cellCount = 0;

        for (var x = 0; x < AtouinConstants.MapHeight; x++)
        {
            for (var y = 0; y < AtouinConstants.MapWidth; y++)
                s_orthogonalGridReference[cellCount++] = new MapPoint(posX + y, posY + y);

            posX++;

            for (var y = 0; y < AtouinConstants.MapWidth; y++)
                s_orthogonalGridReference[cellCount++] = new MapPoint(posX + y, posY + y);

            posY--;
        }
    }
}
