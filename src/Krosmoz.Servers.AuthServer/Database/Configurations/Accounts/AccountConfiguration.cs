// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Extensions;
using Krosmoz.Protocol.Enums;
using Krosmoz.Serialization.I18N;
using Krosmoz.Servers.AuthServer.Database.Models.Accounts;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Krosmoz.Servers.AuthServer.Database.Configurations.Accounts;

/// <summary>
/// Configures the entity type for <see cref="AccountRecord"/> in the database.
/// </summary>
public sealed class AccountConfiguration : IEntityTypeConfiguration<AccountRecord>
{
    /// <summary>
    /// Configures the properties and relationships of the <see cref="AccountRecord"/> entity.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity type.</param>
    public void Configure(EntityTypeBuilder<AccountRecord> builder)
    {
        builder.HasKey(static x => x.Id);

        builder
            .Property(static x => x.Id)
            .ValueGeneratedOnAdd();

        builder
            .Property(static x => x.Username)
            .IsRequired();

        builder
            .Property(static x => x.Password)
            .IsRequired();

        builder
            .Property(static x => x.Language)
            .IsRequired();

        builder
            .Property(static x => x.Hierarchy)
            .IsRequired();

        builder
            .Property(static x => x.SecretQuestion)
            .IsRequired();

        builder
            .Property(static x => x.SecretAnswer)
            .IsRequired();

        builder
            .Property(static x => x.CreatedAt)
            .IsRequired();

        builder
            .Property(static x => x.UpdatedAt)
            .IsRequired();

        builder
            .HasMany(static x => x.Characters)
            .WithOne()
            .HasForeignKey(static x => x.AccountId)
            .OnDelete(DeleteBehavior.Cascade)
            .IsRequired();

        builder
            .HasIndex(static x => x.Username)
            .IsUnique();

        builder
            .HasIndex(static x => x.Nickname)
            .IsUnique();

        builder
            .HasIndex(static x => x.Ticket)
            .IsUnique();

        builder.HasData(new AccountRecord
        {
            Id = 1,
            Username = "admin",
            Password = "admin".ToMd5(),
            Hierarchy = GameHierarchies.Admin,
            Language = I18NLanguages.French,
            SecretQuestion = "What is your favorite color?",
            SecretAnswer = "blue",
            CreatedAt = new DateTime(),
            UpdatedAt = new DateTime(),
            Characters = []
        });

        builder.ToTable("accounts");
    }
}
