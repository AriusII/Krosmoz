// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.GameServer.Database.Models.Characters;
using Krosmoz.Servers.GameServer.Models.Appearances;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Krosmoz.Servers.GameServer.Database.Configurations.Characters;

/// <summary>
/// Configures the database schema for the <see cref="CharacterRecord"/> entity.
/// </summary>
public sealed class CharacterConfiguration : IEntityTypeConfiguration<CharacterRecord>
{
    /// <summary>
    /// Configures the properties and relationships of the <see cref="CharacterRecord"/> entity.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity type.</param>
    public void Configure(EntityTypeBuilder<CharacterRecord> builder)
    {
        builder.HasKey(static x => x.Id);

        builder
            .Property(static x => x.Id)
            .ValueGeneratedOnAdd();

        builder
            .Property(static x => x.Name)
            .IsRequired();

        builder
            .Property(static x => x.AccountId)
            .IsRequired();

        builder
            .Property(static x => x.Experience)
            .IsRequired();

        builder
            .Property(static x => x.Level)
            .IsRequired();

        builder
            .Property(static x => x.Breed)
            .IsRequired();

        builder
            .Property(static x => x.Head)
            .IsRequired();

        builder
            .Property(static x => x.Sex)
            .IsRequired();

        builder
            .Property(static x => x.Position)
            .HasConversion(
                static x => x.Position,
                static x => new CharacterPosition { Position = x },
                ValueComparer.CreateDefault<CharacterPosition>(true))
            .IsRequired();

        builder
            .Property(static x => x.Status)
            .IsRequired();

        builder
            .Property(static x => x.Look)
            .HasConversion(
                static x => x.ToString(),
                static x => ActorLook.Parse(x),
                ValueComparer.CreateDefault<ActorLook>(true))
            .IsRequired();

        builder
            .Property(static x => x.Kamas)
            .IsRequired();

        builder
            .Property(static x => x.Emotes)
            .IsRequired();

        builder
            .Property(static x => x.Spells)
            .IsRequired();

        builder
            .Property(static x => x.CreatedAt)
            .IsRequired();

        builder
            .Property(static x => x.UpdatedAt)
            .IsRequired();

        builder
            .Property(static x => x.DeathCount)
            .IsRequired();

        builder
            .Property(static x => x.DeathMaxLevel)
            .IsRequired();

        builder
            .Property(static x => x.DeathState)
            .IsRequired();

        builder.ToTable("characters");
    }
}
