// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Quest;

public sealed class AchievementReward : IDatacenterObject
{
	public static string ModuleName =>
		"AchievementRewards";

	public required int Id { get; set; }

	public required int AchievementId { get; set; }

	public required int LevelMin { get; set; }

	public required int LevelMax { get; set; }

	public required List<uint> ItemsReward { get; set; }

	public required List<uint> ItemsQuantityReward { get; set; }

	public required List<uint> EmotesReward { get; set; }

	public required List<uint> SpellsReward { get; set; }

	public required List<uint> TitlesReward { get; set; }

	public required List<uint> OrnamentsReward { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		AchievementId = d2OClass.ReadFieldAsInt(reader);
		LevelMin = d2OClass.ReadFieldAsInt(reader);
		LevelMax = d2OClass.ReadFieldAsInt(reader);
		ItemsReward = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		ItemsQuantityReward = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		EmotesReward = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		SpellsReward = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		TitlesReward = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		OrnamentsReward = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
	}
}
