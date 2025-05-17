// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.GameServer.Database.Models.Maps;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace Krosmoz.Servers.GameServer.Database.Configurations.Maps;

/// <summary>
/// Provides a custom value comparer for arrays of <see cref="CellData"/>.
/// </summary>
public sealed class CellDataArrayValueComparer : ValueComparer<CellData[]>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="CellDataArrayValueComparer"/> class.
    /// </summary>
    public CellDataArrayValueComparer()
        : base(
            static (x, y) => GetEqualsExpression(x, y),
            static x => GetHashCodeExpression(x),
            static x => GetSnapshotExpression(x))
    {
    }

    /// <summary>
    /// Determines whether two arrays of <see cref="CellData"/> are equal.
    /// </summary>
    /// <param name="x">The first array to compare.</param>
    /// <param name="y">The second array to compare.</param>
    /// <returns><c>true</c> if the arrays are equal; otherwise, <c>false</c>.</returns>
    private static bool GetEqualsExpression(CellData[]? x, CellData[]? y)
    {
        if (ReferenceEquals(x, y))
            return true;

        if (x is null || y is null)
            return false;

        if (x.Length != y.Length)
            return false;

        return !x.Where((t, i) => !t.Equals(y[i])).Any();
    }

    /// <summary>
    /// Computes the hash code for an array of <see cref="CellData"/>.
    /// </summary>
    /// <param name="x">The array for which to compute the hash code.</param>
    /// <returns>The computed hash code.</returns>
    private static int GetHashCodeExpression(CellData[] x)
    {
        return x.Aggregate(0, static (current, cellData) => HashCode.Combine(current, cellData.GetHashCode()));
    }

    /// <summary>
    /// Creates a snapshot of an array of <see cref="CellData"/>.
    /// </summary>
    /// <param name="x">The array to snapshot.</param>
    /// <returns>A new array containing the same elements as the input array.</returns>
    private static CellData[] GetSnapshotExpression(CellData[] x)
    {
        return x.ToArray();
    }
}
