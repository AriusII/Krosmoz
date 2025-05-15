// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Datacenter.AmbientSounds;
using Krosmoz.Protocol.Datacenter.Geom;

namespace Krosmoz.Protocol.Datacenter.World;

public sealed class SubArea : IDatacenterObject
{
	public static string ModuleName =>
		"SubAreas";

	public required int Id { get; set; }

	public required int NameId { get; set; }

	public required string Name { get; set; }

	public required int AreaId { get; set; }

	public required List<AmbientSound> AmbientSounds { get; set; }

	public required List<uint> MapIds { get; set; }

	public required Rectangle Bounds { get; set; }

	public required List<int> Shape { get; set; }

	public required List<uint> CustomWorldMap { get; set; }

	public required uint PackId { get; set; }

	public required uint Level { get; set; }

	public required bool IsConquestVillage { get; set; }

	public required bool DisplayOnWorldMap { get; set; }

	public required List<uint> Monsters { get; set; }

	public required List<uint> EntranceMapIds { get; set; }

	public required List<uint> ExitMapIds { get; set; }

	public required bool Capturable { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		NameId = d2OClass.ReadFieldAsI18N(reader);
		Name = d2OClass.ReadFieldAsI18NString(NameId);
		AreaId = d2OClass.ReadFieldAsInt(reader);
		AmbientSounds = d2OClass.ReadFieldAsList<AmbientSound>(reader, static (c, r) => c.ReadFieldAsObject<AmbientSound>(r));
		MapIds = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		Bounds = d2OClass.ReadFieldAsObject<Rectangle>(reader);
		Shape = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsInt(r));
		CustomWorldMap = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		PackId = d2OClass.ReadFieldAsUInt(reader);
		Level = d2OClass.ReadFieldAsUInt(reader);
		IsConquestVillage = d2OClass.ReadFieldAsBoolean(reader);
		DisplayOnWorldMap = d2OClass.ReadFieldAsBoolean(reader);
		Monsters = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		EntranceMapIds = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		ExitMapIds = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		Capturable = d2OClass.ReadFieldAsBoolean(reader);
	}
}
