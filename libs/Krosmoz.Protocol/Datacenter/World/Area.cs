// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Datacenter.Geom;

namespace Krosmoz.Protocol.Datacenter.World;

public sealed class Area : IDatacenterObject
{
	public static string ModuleName =>
		"Areas";

	public required int Id { get; set; }

	public required int NameId { get; set; }

	public required string Name { get; set; }

	public required int SuperAreaId { get; set; }

	public required bool ContainHouses { get; set; }

	public required bool ContainPaddocks { get; set; }

	public required Rectangle Bounds { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		NameId = d2OClass.ReadFieldAsI18N(reader);
		Name = d2OClass.ReadFieldAsI18NString(NameId);
		SuperAreaId = d2OClass.ReadFieldAsInt(reader);
		ContainHouses = d2OClass.ReadFieldAsBoolean(reader);
		ContainPaddocks = d2OClass.ReadFieldAsBoolean(reader);
		Bounds = d2OClass.ReadFieldAsObject<Rectangle>(reader);
	}
}
