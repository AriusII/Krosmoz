// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Collections.Concurrent;
using Krosmoz.Core.Extensions;
using Krosmoz.Core.Services;
using Krosmoz.Servers.GameServer.Database.Models.Experiences;
using Microsoft.EntityFrameworkCore;

namespace Krosmoz.Servers.GameServer.Database.Repositories.Experiences;

/// <summary>
/// Repository for managing experience-related data.
/// Provides methods to retrieve and calculate experience requirements for various entities.
/// </summary>
public sealed class ExperienceRepository : IExperienceRepository, IAsyncInitializableService
{
    private readonly IDbContextFactory<GameDbContext> _dbContextFactory;

    private ConcurrentDictionary<byte, ExperienceRecord> _experiences;
    private KeyValuePair<byte, ExperienceRecord> _highestCharacterLevel;
    private KeyValuePair<byte, ExperienceRecord> _highestGuildLevel;
    private KeyValuePair<byte, ExperienceRecord> _highestMountLevel;
    private KeyValuePair<byte, ExperienceRecord> _highestJobLevel;
    private KeyValuePair<byte, ExperienceRecord> _highestAlignmentGrade;

    /// <summary>
    /// Gets the highest character level available in the game.
    /// </summary>
    public byte HighestCharacterLevel =>
        _highestCharacterLevel.Key;

    /// <summary>
    /// Gets the highest guild level available in the game.
    /// </summary>
    public byte HighestGuildLevel =>
        _highestGuildLevel.Key;

    /// <summary>
    /// Gets the highest mount level available in the game.
    /// </summary>
    public byte HighestMountLevel =>
        _highestMountLevel.Key;

    /// <summary>
    /// Gets the highest job level available in the game.
    /// </summary>
    public byte HighestJobLevel =>
        _highestJobLevel.Key;

    /// <summary>
    /// Gets the highest alignment grade available in the game.
    /// </summary>
    public byte HighestAlignmentGrade =>
        _highestAlignmentGrade.Key;

    /// <summary>
    /// Initializes a new instance of the <see cref="ExperienceRepository"/> class.
    /// </summary>
    /// <param name="dbContextFactory">Factory for creating database contexts.</param>
    public ExperienceRepository(IDbContextFactory<GameDbContext> dbContextFactory)
    {
        _dbContextFactory = dbContextFactory;
        _experiences = [];
    }

    /// <summary>
    /// Asynchronously initializes the repository by loading experience data from the database.
    /// </summary>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    public async Task InitializeAsync(CancellationToken cancellationToken)
    {
        await using var dbContext = await _dbContextFactory.CreateDbContextAsync(cancellationToken);

        _experiences = await dbContext.Experiences
            .AsNoTracking()
            .ToConcurrentDictionaryAsync(static x => x.Level, cancellationToken);

        _highestCharacterLevel = _experiences.Last();
        _highestGuildLevel = _experiences.Last();
        _highestMountLevel = _experiences.Last(static x => x.Value.MountXp.HasValue);
        _highestJobLevel = _experiences.Last(static x => x.Value.JobXp.HasValue);
        _highestAlignmentGrade = _experiences.Last(static x => x.Value.AlignmentHonor.HasValue);
    }

    /// <summary>
    /// Retrieves the experience required for a character to reach a specific level.
    /// </summary>
    /// <param name="level">The character level.</param>
    /// <returns>The experience required for the specified level.</returns>
    public long GetCharacterExperienceByLevel(byte level)
    {
        if (!_experiences.TryGetValue(level, out var experience))
            throw new KeyNotFoundException("Level {level} not found.");

        return experience.CharacterXp;
    }

    /// <summary>
    /// Retrieves the experience required for a character to reach the next level.
    /// </summary>
    /// <param name="level">The current character level.</param>
    /// <returns>The experience required for the next level.</returns>
    public long GetCharacterNextExperienceByLevel(byte level)
    {
        if (!_experiences.TryGetValue(level, out var experience))
            throw new KeyNotFoundException("Level {level} not found.");

        if (!_experiences.ContainsKey((byte)(level + 1)))
            level--;

        return _experiences[(byte)(level + 1)].CharacterXp - experience.CharacterXp;
    }

    /// <summary>
    /// Determines the character level based on the given experience points.
    /// </summary>
    /// <param name="experience">The experience points.</param>
    /// <returns>The character level corresponding to the experience points.</returns>
    public byte GetCharacterLevelByExperience(long experience)
    {
        try
        {
            if (experience >= _highestCharacterLevel.Value.CharacterXp)
                return _highestCharacterLevel.Key;

            return (byte)(_experiences.First(x => x.Value.CharacterXp > experience).Key - 1);
        }
        catch (Exception e)
        {
            throw new InvalidOperationException("Error while getting character level by experience", e);
        }
    }

    /// <summary>
    /// Retrieves the experience required for a guild to reach a specific level.
    /// </summary>
    /// <param name="level">The guild level.</param>
    /// <returns>The experience required for the specified level.</returns>
    public long GetGuildExperienceByLevel(byte level)
    {
        if (!_experiences.TryGetValue(level, out var experience))
            throw new KeyNotFoundException("Level {level} not found.");

        return experience.GuildXp;
    }

    /// <summary>
    /// Retrieves the experience required for a guild to reach the next level.
    /// </summary>
    /// <param name="level">The current guild level.</param>
    /// <returns>The experience required for the next level.</returns>
    public long GetGuildNextExperienceByLevel(byte level)
    {
        if (!_experiences.TryGetValue(level, out var experience))
            throw new KeyNotFoundException("Level {level} not found.");

        if (!_experiences.ContainsKey((byte)(level + 1)))
            level--;

        return _experiences[(byte)(level + 1)].GuildXp - experience.GuildXp;
    }

    /// <summary>
    /// Determines the guild level based on the given experience points.
    /// </summary>
    /// <param name="experience">The experience points.</param>
    /// <returns>The guild level corresponding to the experience points.</returns>
    public byte GetGuildLevelByExperience(long experience)
    {
        try
        {
            if (experience >= _highestGuildLevel.Value.GuildXp)
                return _highestGuildLevel.Key;

            return (byte)(_experiences.First(x => x.Value.GuildXp > experience).Key - 1);
        }
        catch (Exception e)
        {
            throw new InvalidOperationException("Error while getting guild level by experience", e);
        }
    }

    /// <summary>
    /// Retrieves the experience required for a mount to reach a specific level.
    /// </summary>
    /// <param name="level">The mount level.</param>
    /// <returns>The experience required for the specified level.</returns>
    public long GetMountExperienceByLevel(byte level)
    {
        if (!_experiences.TryGetValue(level, out var experience))
            throw new KeyNotFoundException("Level {level} not found.");

        return experience.MountXp ?? throw new KeyNotFoundException("Mount experience not found.");
    }

    /// <summary>
    /// Retrieves the experience required for a mount to reach the next level.
    /// </summary>
    /// <param name="level">The current mount level.</param>
    /// <returns>The experience required for the next level.</returns>
    public long GetMountNextExperienceByLevel(byte level)
    {
        if (!_experiences.TryGetValue(level, out var experience))
            throw new KeyNotFoundException("Level {level} not found.");

        if (!_experiences.ContainsKey((byte)(level + 1)))
            return _highestMountLevel.Value.MountXp ?? throw new KeyNotFoundException("Mount experience not found.");

        return (_experiences[(byte)(level + 1)].MountXp ?? throw new KeyNotFoundException("Mount experience not found.")) - experience.MountXp ?? throw new KeyNotFoundException("Mount experience not found.");
    }

    /// <summary>
    /// Determines the mount level based on the given experience points.
    /// </summary>
    /// <param name="experience">The experience points.</param>
    /// <returns>The mount level corresponding to the experience points.</returns>
    public byte GetMountLevelByExperience(long experience)
    {
        try
        {
            if (experience >= _highestMountLevel.Value.MountXp)
                return _highestMountLevel.Key;

            return (byte)(_experiences.First(x => x.Value.MountXp > experience).Key - 1);
        }
        catch (Exception e)
        {
            throw new InvalidOperationException("Error while getting mount level by experience", e);
        }
    }

    /// <summary>
    /// Retrieves the experience required for a job to reach a specific level.
    /// </summary>
    /// <param name="level">The job level.</param>
    /// <returns>The experience required for the specified level.</returns>
    public long GetJobExperienceByLevel(byte level)
    {
        if (!_experiences.TryGetValue(level, out var experience))
            throw new KeyNotFoundException("Level {level} not found.");

        return experience.JobXp ?? throw new KeyNotFoundException("Job experience not found.");
    }

    /// <summary>
    /// Retrieves the experience required for a job to reach the next level.
    /// </summary>
    /// <param name="level">The current job level.</param>
    /// <returns>The experience required for the next level.</returns>
    public long GetJobNextExperienceByLevel(byte level)
    {
        if (!_experiences.TryGetValue(level, out var experience))
            throw new KeyNotFoundException("Level {level} not found.");

        if (!_experiences.ContainsKey((byte)(level + 1)))
            return _highestJobLevel.Value.JobXp ?? throw new KeyNotFoundException("Job experience not found.");

        return (_experiences[(byte)(level + 1)].JobXp ?? throw new KeyNotFoundException("Job experience not found.")) - experience.JobXp ?? throw new KeyNotFoundException("Job experience not found.");
    }

    /// <summary>
    /// Determines the job level based on the given experience points.
    /// </summary>
    /// <param name="experience">The experience points.</param>
    /// <returns>The job level corresponding to the experience points.</returns>
    public byte GetJobLevelByExperience(long experience)
    {
        try
        {
            if (experience >= _highestJobLevel.Value.JobXp)
                return _highestJobLevel.Key;

            return (byte)(_experiences.First(x => x.Value.JobXp > experience).Key - 1);
        }
        catch (Exception e)
        {
            throw new InvalidOperationException("Error while getting job level by experience", e);
        }
    }

    /// <summary>
    /// Retrieves the experience required for an alignment to reach a specific grade.
    /// </summary>
    /// <param name="grade">The alignment grade.</param>
    /// <returns>The experience required for the specified grade.</returns>
    public long GetAlignmentExperienceByGrade(byte grade)
    {
        if (!_experiences.TryGetValue(grade, out var experience))
            throw new KeyNotFoundException("Grade {grade} not found.");

        return experience.AlignmentHonor ?? throw new KeyNotFoundException("Alignment experience not found.");
    }

    /// <summary>
    /// Retrieves the experience required for an alignment to reach the next grade.
    /// </summary>
    /// <param name="grade">The current alignment grade.</param>
    /// <returns>The experience required for the next grade.</returns>
    public long GetAlignmentNextExperienceByGrade(byte grade)
    {
        if (!_experiences.TryGetValue(grade, out var experience))
            throw new KeyNotFoundException("Grade {grade} not found.");

        if (!_experiences.ContainsKey((byte)(grade + 1)))
            return _highestAlignmentGrade.Value.AlignmentHonor ?? throw new KeyNotFoundException("Alignment experience not found.");

        return (_experiences[(byte)(grade + 1)].AlignmentHonor ?? throw new KeyNotFoundException("Alignment experience not found.")) - experience.AlignmentHonor ?? throw new KeyNotFoundException("Alignment experience not found.");
    }

    /// <summary>
    /// Determines the alignment grade based on the given experience points.
    /// </summary>
    /// <param name="experience">The experience points.</param>
    /// <returns>The alignment grade corresponding to the experience points.</returns>
    public byte GetAlignmentGradeByExperience(long experience)
    {
        try
        {
            if (experience >= _highestAlignmentGrade.Value.AlignmentHonor)
                return _highestAlignmentGrade.Key;

            return (byte)(_experiences.First(x => x.Value.AlignmentHonor > experience).Key - 1);
        }
        catch (Exception e)
        {
            throw new InvalidOperationException("Error while getting alignment grade by experience", e);
        }
    }
}
