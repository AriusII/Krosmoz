// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.World;

public sealed class Hint : IDatacenterObject
{
	public static string ModuleName =>
		"Hints";

	public required int Id { get; set; }

	public required int CategoryId { get; set; }

	public required int Gfx { get; set; }

	public required int NameId { get; set; }

	public required string Name { get; set; }

	public required int MapId { get; set; }

	public required int RealMapId { get; set; }

	public required int X { get; set; }

	public required int Y { get; set; }

	public required bool Outdoor { get; set; }

	public required int SubareaId { get; set; }

	public required int WorldMapId { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		CategoryId = d2OClass.ReadFieldAsInt(reader);
		Gfx = d2OClass.ReadFieldAsInt(reader);
		NameId = d2OClass.ReadFieldAsI18N(reader);
		Name = d2OClass.ReadFieldAsI18NString(NameId);
		MapId = d2OClass.ReadFieldAsInt(reader);
		RealMapId = d2OClass.ReadFieldAsInt(reader);
		X = d2OClass.ReadFieldAsInt(reader);
		Y = d2OClass.ReadFieldAsInt(reader);
		Outdoor = d2OClass.ReadFieldAsBoolean(reader);
		SubareaId = d2OClass.ReadFieldAsInt(reader);
		WorldMapId = d2OClass.ReadFieldAsInt(reader);
	}
}
