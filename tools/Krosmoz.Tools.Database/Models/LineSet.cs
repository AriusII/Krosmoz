// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Tools.Database.Models;

/// <summary>
/// Represents a line segment defined by two points on a map.
/// </summary>
public sealed class LineSet
{
    /// <summary>
    /// Gets the starting point of the line segment.
    /// </summary>
    public MapPoint? A { get; }

    /// <summary>
    /// Gets the ending point of the line segment.
    /// </summary>
    public MapPoint? B { get; }

    /// <summary>
    /// Initializes a new instance of the <see cref="LineSet"/> class with the specified points.
    /// </summary>
    /// <param name="a">The starting point of the line segment.</param>
    /// <param name="b">The ending point of the line segment.</param>
    public LineSet(MapPoint a, MapPoint b)
    {
        A = a;
        B = b;
    }

    /// <summary>
    /// Calculates the square of the distance from a given point to the line segment.
    /// </summary>
    /// <param name="point">The point for which to calculate the distance.</param>
    /// <returns>
    /// The square of the perpendicular distance from the point to the line segment,
    /// or <c>0</c> if either endpoint of the line segment is <c>null</c>.
    /// </returns>
    public double SquareDistanceToLine(MapPoint point)
    {
        if (A is null || B is null)
            return 0;

        double dx = B.X - A.X;
        double dy = B.Y - A.Y;

        var projection = dy * point.X - dx * point.Y + B.X * A.Y - B.Y * A.X;

        return projection * projection / (dy * dy + dx * dx);
    }
}
