// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Effects;

public sealed class Effect : IDatacenterObject
{
	public static string ModuleName =>
		"Effects";

	public required int Id { get; set; }

	public required int DescriptionId { get; set; }

	public required string Description { get; set; }

	public required int IconId { get; set; }

	public required int Characteristic { get; set; }

	public required int Category { get; set; }

	public required string Operator { get; set; }

	public required bool ShowInTooltip { get; set; }

	public required bool UseDice { get; set; }

	public required bool ForceMinMax { get; set; }

	public required bool Boost { get; set; }

	public required bool Active { get; set; }

	public required bool ShowInSet { get; set; }

	public required int BonusType { get; set; }

	public required bool UseInFight { get; set; }

	public required int EffectPriority { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		DescriptionId = d2OClass.ReadFieldAsI18N(reader);
		Description = d2OClass.ReadFieldAsI18NString(DescriptionId);
		IconId = d2OClass.ReadFieldAsInt(reader);
		Characteristic = d2OClass.ReadFieldAsInt(reader);
		Category = d2OClass.ReadFieldAsInt(reader);
		Operator = d2OClass.ReadFieldAsString(reader);
		ShowInTooltip = d2OClass.ReadFieldAsBoolean(reader);
		UseDice = d2OClass.ReadFieldAsBoolean(reader);
		ForceMinMax = d2OClass.ReadFieldAsBoolean(reader);
		Boost = d2OClass.ReadFieldAsBoolean(reader);
		Active = d2OClass.ReadFieldAsBoolean(reader);
		ShowInSet = d2OClass.ReadFieldAsBoolean(reader);
		BonusType = d2OClass.ReadFieldAsInt(reader);
		UseInFight = d2OClass.ReadFieldAsBoolean(reader);
		EffectPriority = d2OClass.ReadFieldAsInt(reader);
	}
}
