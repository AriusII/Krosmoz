// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Datacenter.Geom;

namespace Krosmoz.Protocol.Datacenter.Quest;

public class QuestObjective : IDatacenterObject
{
	public static string ModuleName =>
		"QuestObjectives";

	public required int Id { get; set; }

	public required int StepId { get; set; }

	public required int TypeId { get; set; }

	public required int DialogId { get; set; }

	public required List<uint> Parameters { get; set; }

	public required Point Coords { get; set; }

	public required int MapId { get; set; }

	public virtual void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		StepId = d2OClass.ReadFieldAsInt(reader);
		TypeId = d2OClass.ReadFieldAsInt(reader);
		DialogId = d2OClass.ReadFieldAsInt(reader);
		Parameters = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		Coords = d2OClass.ReadFieldAsObject<Point>(reader);
		MapId = d2OClass.ReadFieldAsInt(reader);
	}
}
