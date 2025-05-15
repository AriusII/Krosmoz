// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Effects;

public class EffectInstance : IDatacenterObject
{
	public static string ModuleName =>
		"SpellLevels";

	public required int EffectId { get; set; }

	public required int TargetId { get; set; }

	public required string TargetMask { get; set; }

	public required int Duration { get; set; }

	public required int Random { get; set; }

	public required int Group { get; set; }

	public required bool Hidden { get; set; }

	public required string RawZone { get; set; }

	public virtual void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		EffectId = d2OClass.ReadFieldAsInt(reader);
		TargetId = d2OClass.ReadFieldAsInt(reader);
		TargetMask = d2OClass.ReadFieldAsString(reader);
		Duration = d2OClass.ReadFieldAsInt(reader);
		Random = d2OClass.ReadFieldAsInt(reader);
		Group = d2OClass.ReadFieldAsInt(reader);
		Hidden = d2OClass.ReadFieldAsBoolean(reader);
		RawZone = d2OClass.ReadFieldAsString(reader);
	}
}
