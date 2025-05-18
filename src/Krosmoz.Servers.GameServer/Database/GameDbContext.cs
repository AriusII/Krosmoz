// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.GameServer.Database.Models.Characters;
using Krosmoz.Servers.GameServer.Database.Models.Experiences;
using Krosmoz.Servers.GameServer.Database.Models.Interactives;
using Krosmoz.Servers.GameServer.Database.Models.Maps;
using Microsoft.EntityFrameworkCore;

namespace Krosmoz.Servers.GameServer.Database;

/// <summary>
/// Represents the database context for the game server.
/// </summary>
public sealed class GameDbContext : DbContext
{
    /// <summary>
    /// Gets or sets the DbSet representing the collection of <see cref="MapRecord"/> entities.
    /// </summary>
    public required DbSet<MapRecord> Maps { get; set; }

    /// <summary>
    /// Gets or sets the DbSet representing the collection of <see cref="InteractiveRecord"/> entities.
    /// </summary>
    public required DbSet<InteractiveRecord> Interactives { get; set; }

    /// <summary>
    /// Gets or sets the DbSet representing the collection of <see cref="ExperienceRecord"/> entities.
    /// </summary>
    public required DbSet<ExperienceRecord> Experiences { get; set; }

    /// <summary>
    /// Gets or sets the DbSet representing the collection of <see cref="CharacterRecord"/> entities.
    /// </summary>
    public required DbSet<CharacterRecord> Characters { get; set; }

    /// <summary>
    /// Initializes a new instance of the <see cref="GameDbContext"/> class with the specified options.
    /// </summary>
    /// <param name="options">The options to configure the database context.</param>
    public GameDbContext(DbContextOptions<GameDbContext> options) : base(options)
    {
    }

    /// <summary>
    /// Configures the model for the database context using the specified <see cref="ModelBuilder"/>.
    /// </summary>
    /// <param name="builder">The builder used to configure the model.</param>
    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.ApplyConfigurationsFromAssembly(typeof(GameDbContext).Assembly);
    }
}
