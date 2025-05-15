// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Datacenter.AmbientSounds;

namespace Krosmoz.Protocol.Datacenter.World;

public sealed class MapPosition : IDatacenterObject
{
	public static string ModuleName =>
		"MapPositions";

	public required int Id { get; set; }

	public required int PosX { get; set; }

	public required int PosY { get; set; }

	public required bool Outdoor { get; set; }

	public required int Capabilities { get; set; }

	public required int NameId { get; set; }

	public required string Name { get; set; }

	public required List<AmbientSound> Sounds { get; set; }

	public required int SubAreaId { get; set; }

	public required int WorldMap { get; set; }

	public required bool HasPriorityOnWorldmap { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		PosX = d2OClass.ReadFieldAsInt(reader);
		PosY = d2OClass.ReadFieldAsInt(reader);
		Outdoor = d2OClass.ReadFieldAsBoolean(reader);
		Capabilities = d2OClass.ReadFieldAsInt(reader);
		NameId = d2OClass.ReadFieldAsI18N(reader);
		Name = d2OClass.ReadFieldAsI18NString(NameId);
		Sounds = d2OClass.ReadFieldAsList<AmbientSound>(reader, static (c, r) => c.ReadFieldAsObject<AmbientSound>(r));
		SubAreaId = d2OClass.ReadFieldAsInt(reader);
		WorldMap = d2OClass.ReadFieldAsInt(reader);
		HasPriorityOnWorldmap = d2OClass.ReadFieldAsBoolean(reader);
	}
}
