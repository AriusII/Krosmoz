// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Servers.GameServer.Database.Repositories.Experiences;

/// <summary>
/// Defines the contract for a repository that provides access to experience-related data.
/// </summary>
public interface IExperienceRepository
{
    /// <summary>
    /// Gets the highest character level available in the game.
    /// </summary>
    byte HighestCharacterLevel { get; }

    /// <summary>
    /// Gets the highest guild level available in the game.
    /// </summary>
    byte HighestGuildLevel { get; }

    /// <summary>
    /// Gets the highest mount level available in the game.
    /// </summary>
    byte HighestMountLevel { get; }

    /// <summary>
    /// Gets the highest job level available in the game.
    /// </summary>
    byte HighestJobLevel { get; }

    /// <summary>
    /// Gets the highest alignment grade available in the game.
    /// </summary>
    byte HighestAlignmentGrade { get; }

    /// <summary>
    /// Retrieves the experience required for a character to reach a specific level.
    /// </summary>
    /// <param name="level">The character level.</param>
    /// <returns>The experience required for the specified level.</returns>
    long GetCharacterExperienceByLevel(byte level);

    /// <summary>
    /// Retrieves the experience required for a character to reach the next level.
    /// </summary>
    /// <param name="level">The current character level.</param>
    /// <returns>The experience required for the next level.</returns>
    long GetCharacterNextExperienceByLevel(byte level);

    /// <summary>
    /// Determines the character level based on the given experience points.
    /// </summary>
    /// <param name="experience">The experience points.</param>
    /// <returns>The character level corresponding to the experience points.</returns>
    byte GetCharacterLevelByExperience(long experience);

    /// <summary>
    /// Retrieves the experience required for a guild to reach a specific level.
    /// </summary>
    /// <param name="level">The guild level.</param>
    /// <returns>The experience required for the specified level.</returns>
    long GetGuildExperienceByLevel(byte level);

    /// <summary>
    /// Retrieves the experience required for a guild to reach the next level.
    /// </summary>
    /// <param name="level">The current guild level.</param>
    /// <returns>The experience required for the next level.</returns>
    long GetGuildNextExperienceByLevel(byte level);

    /// <summary>
    /// Determines the guild level based on the given experience points.
    /// </summary>
    /// <param name="experience">The experience points.</param>
    /// <returns>The guild level corresponding to the experience points.</returns>
    byte GetGuildLevelByExperience(long experience);

    /// <summary>
    /// Retrieves the experience required for a mount to reach a specific level.
    /// </summary>
    /// <param name="level">The mount level.</param>
    /// <returns>The experience required for the specified level.</returns>
    long GetMountExperienceByLevel(byte level);

    /// <summary>
    /// Retrieves the experience required for a mount to reach the next level.
    /// </summary>
    /// <param name="level">The current mount level.</param>
    /// <returns>The experience required for the next level.</returns>
    long GetMountNextExperienceByLevel(byte level);

    /// <summary>
    /// Determines the mount level based on the given experience points.
    /// </summary>
    /// <param name="experience">The experience points.</param>
    /// <returns>The mount level corresponding to the experience points.</returns>
    byte GetMountLevelByExperience(long experience);

    /// <summary>
    /// Retrieves the experience required for a job to reach a specific level.
    /// </summary>
    /// <param name="level">The job level.</param>
    /// <returns>The experience required for the specified level.</returns>
    long GetJobExperienceByLevel(byte level);

    /// <summary>
    /// Retrieves the experience required for a job to reach the next level.
    /// </summary>
    /// <param name="level">The current job level.</param>
    /// <returns>The experience required for the next level.</returns>
    long GetJobNextExperienceByLevel(byte level);

    /// <summary>
    /// Determines the job level based on the given experience points.
    /// </summary>
    /// <param name="experience">The experience points.</param>
    /// <returns>The job level corresponding to the experience points.</returns>
    byte GetJobLevelByExperience(long experience);

    /// <summary>
    /// Retrieves the experience required for an alignment to reach a specific grade.
    /// </summary>
    /// <param name="grade">The alignment grade.</param>
    /// <returns>The experience required for the specified grade.</returns>
    long GetAlignmentExperienceByGrade(byte grade);

    /// <summary>
    /// Retrieves the experience required for an alignment to reach the next grade.
    /// </summary>
    /// <param name="grade">The current alignment grade.</param>
    /// <returns>The experience required for the next grade.</returns>
    long GetAlignmentNextExperienceByGrade(byte grade);

    /// <summary>
    /// Determines the alignment grade based on the given experience points.
    /// </summary>
    /// <param name="experience">The experience points.</param>
    /// <returns>The alignment grade corresponding to the experience points.</returns>
    byte GetAlignmentGradeByExperience(long experience);
}
