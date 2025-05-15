// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.AmbientSounds;

public sealed class AmbientSound : IDatacenterObject
{
	public static string ModuleName =>
		"SubAreas";

	public required int Id { get; set; }

	public required int Volume { get; set; }

	public required int CriterionId { get; set; }

	public required int SilenceMin { get; set; }

	public required int SilenceMax { get; set; }

	public required int Channel { get; set; }

	public required int TypeId { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		Volume = d2OClass.ReadFieldAsInt(reader);
		CriterionId = d2OClass.ReadFieldAsInt(reader);
		SilenceMin = d2OClass.ReadFieldAsInt(reader);
		SilenceMax = d2OClass.ReadFieldAsInt(reader);
		Channel = d2OClass.ReadFieldAsInt(reader);
		TypeId = d2OClass.ReadFieldAsInt(reader);
	}
}
