// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Quest;

public sealed class Quest : IDatacenterObject
{
	public static string ModuleName =>
		"Quests";

	public required int Id { get; set; }

	public required int NameId { get; set; }

	public required string Name { get; set; }

	public required int CategoryId { get; set; }

	public required bool IsRepeatable { get; set; }

	public required int RepeatType { get; set; }

	public required int RepeatLimit { get; set; }

	public required bool IsDungeonQuest { get; set; }

	public required int LevelMin { get; set; }

	public required int LevelMax { get; set; }

	public required List<uint> StepIds { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		NameId = d2OClass.ReadFieldAsI18N(reader);
		Name = d2OClass.ReadFieldAsI18NString(NameId);
		CategoryId = d2OClass.ReadFieldAsInt(reader);
		IsRepeatable = d2OClass.ReadFieldAsBoolean(reader);
		RepeatType = d2OClass.ReadFieldAsInt(reader);
		RepeatLimit = d2OClass.ReadFieldAsInt(reader);
		IsDungeonQuest = d2OClass.ReadFieldAsBoolean(reader);
		LevelMin = d2OClass.ReadFieldAsInt(reader);
		LevelMax = d2OClass.ReadFieldAsInt(reader);
		StepIds = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
	}
}
