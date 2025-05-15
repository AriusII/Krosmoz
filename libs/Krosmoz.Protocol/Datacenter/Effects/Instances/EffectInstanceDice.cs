// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Effects.Instances;

public sealed class EffectInstanceDice : EffectInstanceInteger
{
	public required int DiceNum { get; set; }

	public required int DiceSide { get; set; }

	public override void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		EffectId = d2OClass.ReadFieldAsInt(reader);
		DiceNum = d2OClass.ReadFieldAsInt(reader);
		Duration = d2OClass.ReadFieldAsInt(reader);
		Hidden = d2OClass.ReadFieldAsBoolean(reader);
		DiceSide = d2OClass.ReadFieldAsInt(reader);
		Value = d2OClass.ReadFieldAsInt(reader);
		Random = d2OClass.ReadFieldAsInt(reader);
		RawZone = d2OClass.ReadFieldAsString(reader);
		TargetId = d2OClass.ReadFieldAsInt(reader);
		Group = d2OClass.ReadFieldAsInt(reader);
		TargetMask = d2OClass.ReadFieldAsString(reader);
	}
}
