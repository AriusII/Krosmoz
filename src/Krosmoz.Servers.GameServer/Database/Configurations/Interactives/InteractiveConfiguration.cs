// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.GameServer.Database.Models.Interactives;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Krosmoz.Servers.GameServer.Database.Configurations.Interactives;

/// <summary>
/// Configures the database schema for the <see cref="InteractiveRecord"/> entity.
/// </summary>
public sealed class InteractiveConfiguration : IEntityTypeConfiguration<InteractiveRecord>
{
    /// <summary>
    /// Configures the properties and relationships of the <see cref="InteractiveRecord"/> entity.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public void Configure(EntityTypeBuilder<InteractiveRecord> builder)
    {
        builder.HasKey(static x => x.Id);

        builder
            .Property(static x => x.Id)
            .ValueGeneratedNever();

        builder
            .Property(static x => x.GfxId)
            .IsRequired();

        builder
            .Property(static x => x.Animated)
            .IsRequired();

        builder
            .Property(static x => x.MapId)
            .IsRequired();

        builder
            .Property(static x => x.ElementId)
            .IsRequired();

        builder
            .Property(static x => x.MapsData)
            .HasConversion(
                static x => SerializeMapsData(x),
                static x => DeserializeMapsData(x),
                new ArrayStructuralComparer<InteractiveMapData>())
            .IsRequired();

        builder.ToTable("interactives");
    }

    /// <summary>
    /// Serializes an array of <see cref="InteractiveMapData"/> into an array of long values.
    /// </summary>
    /// <param name="mapsData">The array of <see cref="InteractiveMapData"/> to serialize.</param>
    /// <returns>An array of long values representing the serialized map data.</returns>
    private static long[] SerializeMapsData(InteractiveMapData[] mapsData)
    {
        var newMapsData = new long[mapsData.Length];

        for (var i = 0; i < mapsData.Length; i++)
            newMapsData[i] = mapsData[i].Data;

        return newMapsData;
    }

    /// <summary>
    /// Deserializes an array of long values into an array of <see cref="InteractiveMapData"/>.
    /// </summary>
    /// <param name="mapsData">The array of long values to deserialize.</param>
    /// <returns>An array of <see cref="InteractiveMapData"/> representing the deserialized map data.</returns>
    private static InteractiveMapData[] DeserializeMapsData(long[] mapsData)
    {
        var newMapsData = new InteractiveMapData[mapsData.Length];

        for (var i = 0; i < mapsData.Length; i++)
            newMapsData[i] = new InteractiveMapData { Data = mapsData[i] };

        return newMapsData;
    }
}
