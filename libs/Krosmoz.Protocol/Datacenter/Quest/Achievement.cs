// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Quest;

public sealed class Achievement : IDatacenterObject
{
	public static string ModuleName =>
		"Achievements";

	public required int Id { get; set; }

	public required int NameId { get; set; }

	public required string Name { get; set; }

	public required int CategoryId { get; set; }

	public required int DescriptionId { get; set; }

	public required string Description { get; set; }

	public required int IconId { get; set; }

	public required int Points { get; set; }

	public required int Level { get; set; }

	public required int Order { get; set; }

	public required double KamasRatio { get; set; }

	public required double ExperienceRatio { get; set; }

	public required bool KamasScaleWithPlayerLevel { get; set; }

	public required List<int> ObjectiveIds { get; set; }

	public required List<int> RewardIds { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		NameId = d2OClass.ReadFieldAsI18N(reader);
		Name = d2OClass.ReadFieldAsI18NString(NameId);
		CategoryId = d2OClass.ReadFieldAsInt(reader);
		DescriptionId = d2OClass.ReadFieldAsI18N(reader);
		Description = d2OClass.ReadFieldAsI18NString(DescriptionId);
		IconId = d2OClass.ReadFieldAsInt(reader);
		Points = d2OClass.ReadFieldAsInt(reader);
		Level = d2OClass.ReadFieldAsInt(reader);
		Order = d2OClass.ReadFieldAsInt(reader);
		KamasRatio = d2OClass.ReadFieldAsNumber(reader);
		ExperienceRatio = d2OClass.ReadFieldAsNumber(reader);
		KamasScaleWithPlayerLevel = d2OClass.ReadFieldAsBoolean(reader);
		ObjectiveIds = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsInt(r));
		RewardIds = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsInt(r));
	}
}
