// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Datacenter.Effects.Instances;

namespace Krosmoz.Protocol.Datacenter.Spells;

public sealed class SpellLevel : IDatacenterObject
{
	public static string ModuleName =>
		"SpellLevels";

	public required int Id { get; set; }

	public required int SpellId { get; set; }

	public required int SpellBreed { get; set; }

	public required int ApCost { get; set; }

	public required int MinRange { get; set; }

	public required int Range { get; set; }

	public required bool CastInLine { get; set; }

	public required bool CastInDiagonal { get; set; }

	public required bool CastTestLos { get; set; }

	public required int CriticalHitProbability { get; set; }

	public required int CriticalFailureProbability { get; set; }

	public required bool NeedFreeCell { get; set; }

	public required bool NeedTakenCell { get; set; }

	public required bool NeedFreeTrapCell { get; set; }

	public required bool RangeCanBeBoosted { get; set; }

	public required int MaxStack { get; set; }

	public required int MaxCastPerTurn { get; set; }

	public required int MaxCastPerTarget { get; set; }

	public required int MinCastInterval { get; set; }

	public required int InitialCooldown { get; set; }

	public required int GlobalCooldown { get; set; }

	public required int MinPlayerLevel { get; set; }

	public required bool CriticalFailureEndsTurn { get; set; }

	public required bool HideEffects { get; set; }

	public required bool Hidden { get; set; }

	public required List<int> StatesRequired { get; set; }

	public required List<int> StatesForbidden { get; set; }

	public required List<EffectInstanceDice> Effects { get; set; }

	public required List<EffectInstanceDice> CriticalEffect { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		SpellId = d2OClass.ReadFieldAsInt(reader);
		SpellBreed = d2OClass.ReadFieldAsInt(reader);
		ApCost = d2OClass.ReadFieldAsInt(reader);
		MinRange = d2OClass.ReadFieldAsInt(reader);
		Range = d2OClass.ReadFieldAsInt(reader);
		CastInLine = d2OClass.ReadFieldAsBoolean(reader);
		CastInDiagonal = d2OClass.ReadFieldAsBoolean(reader);
		CastTestLos = d2OClass.ReadFieldAsBoolean(reader);
		CriticalHitProbability = d2OClass.ReadFieldAsInt(reader);
		CriticalFailureProbability = d2OClass.ReadFieldAsInt(reader);
		NeedFreeCell = d2OClass.ReadFieldAsBoolean(reader);
		NeedTakenCell = d2OClass.ReadFieldAsBoolean(reader);
		NeedFreeTrapCell = d2OClass.ReadFieldAsBoolean(reader);
		RangeCanBeBoosted = d2OClass.ReadFieldAsBoolean(reader);
		MaxStack = d2OClass.ReadFieldAsInt(reader);
		MaxCastPerTurn = d2OClass.ReadFieldAsInt(reader);
		MaxCastPerTarget = d2OClass.ReadFieldAsInt(reader);
		MinCastInterval = d2OClass.ReadFieldAsInt(reader);
		InitialCooldown = d2OClass.ReadFieldAsInt(reader);
		GlobalCooldown = d2OClass.ReadFieldAsInt(reader);
		MinPlayerLevel = d2OClass.ReadFieldAsInt(reader);
		CriticalFailureEndsTurn = d2OClass.ReadFieldAsBoolean(reader);
		HideEffects = d2OClass.ReadFieldAsBoolean(reader);
		Hidden = d2OClass.ReadFieldAsBoolean(reader);
		StatesRequired = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsInt(r));
		StatesForbidden = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsInt(r));
		Effects = d2OClass.ReadFieldAsList<EffectInstanceDice>(reader, static (c, r) => c.ReadFieldAsObject<EffectInstanceDice>(r));
		CriticalEffect = d2OClass.ReadFieldAsList<EffectInstanceDice>(reader, static (c, r) => c.ReadFieldAsObject<EffectInstanceDice>(r));
	}
}
