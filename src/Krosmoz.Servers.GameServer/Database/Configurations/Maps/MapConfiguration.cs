// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.GameServer.Database.Models.Maps;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Krosmoz.Servers.GameServer.Database.Configurations.Maps;

/// <summary>
/// Configures the database schema for the <see cref="MapRecord"/> entity.
/// </summary>
public sealed class MapConfiguration : IEntityTypeConfiguration<MapRecord>
{
    /// <summary>
    /// Configures the properties and relationships of the <see cref="MapRecord"/> entity.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public void Configure(EntityTypeBuilder<MapRecord> builder)
    {
        builder.HasKey(static x => x.Id);

        builder
            .Property(static x => x.Id)
            .ValueGeneratedNever();

        builder
            .Property(static x => x.X)
            .IsRequired();

        builder
            .Property(static x => x.Y)
            .IsRequired();

        builder
            .Property(static x => x.Outdoor)
            .IsRequired();

        builder
            .Property(static x => x.Capabilities)
            .IsRequired();

        builder
            .Property(static x => x.SubAreaId)
            .IsRequired();

        builder
            .Property(static x => x.WorldMap)
            .IsRequired();

        builder
            .Property(static x => x.HasPriorityOnWorldMap)
            .IsRequired();

        builder
            .Property(static x => x.PrismAllowed)
            .IsRequired();

        builder
            .Property(static x => x.PvpDisabled)
            .IsRequired();

        builder
            .Property(static x => x.PlacementGenDisabled)
            .IsRequired();

        builder
            .Property(static x => x.MerchantsMax)
            .IsRequired();

        builder
            .Property(static x => x.SpawnDisabled)
            .IsRequired();

        builder
            .Property(static x => x.RedCells)
            .IsRequired();

        builder
            .Property(static x => x.BlueCells)
            .IsRequired();

        builder
            .Property(static x => x.Cells)
            .HasConversion(static x => SerializeCells(x), static x => DeserializeCells(x))
            .IsRequired();

        builder
            .Property(static x => x.TopNeighborId)
            .IsRequired();

        builder
            .Property(static x => x.BottomNeighborId)
            .IsRequired();

        builder
            .Property(static x => x.LeftNeighborId)
            .IsRequired();

        builder
            .Property(static x => x.RightNeighborId)
            .IsRequired();

        builder.ToTable("maps");
    }

    /// <summary>
    /// Serializes an array of <see cref="CellData"/> into a comma-separated string.
    /// </summary>
    /// <param name="cells">The array of <see cref="CellData"/> to serialize.</param>
    /// <returns>A comma-separated string representing the serialized cells.</returns>
    private static string SerializeCells(CellData[] cells)
    {
        return string.Join(',', cells.Select(static c => c.Data));
    }

    /// <summary>
    /// Deserializes a comma-separated string into an array of <see cref="CellData"/>.
    /// </summary>
    /// <param name="cells">The comma-separated string to deserialize.</param>
    /// <returns>An array of <see cref="CellData"/> representing the deserialized cells.</returns>
    private static CellData[] DeserializeCells(string cells)
    {
        return cells
            .Split(',', StringSplitOptions.RemoveEmptyEntries)
            .Select(static s => new CellData { Data = long.Parse(s) })
            .ToArray();
    }
}
