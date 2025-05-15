// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Jobs;

public sealed class Job : IDatacenterObject
{
	public static string ModuleName =>
		"Jobs";

	public required int Id { get; set; }

	public required int NameId { get; set; }

	public required string Name { get; set; }

	public required int SpecializationOfId { get; set; }

	public required int IconId { get; set; }

	public required List<int> ToolIds { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		NameId = d2OClass.ReadFieldAsI18N(reader);
		Name = d2OClass.ReadFieldAsI18NString(NameId);
		SpecializationOfId = d2OClass.ReadFieldAsInt(reader);
		IconId = d2OClass.ReadFieldAsInt(reader);
		ToolIds = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsInt(r));
	}
}
