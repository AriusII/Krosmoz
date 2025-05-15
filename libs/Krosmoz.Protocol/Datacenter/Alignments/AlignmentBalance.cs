// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Alignments;

public sealed class AlignmentBalance : IDatacenterObject
{
	public static string ModuleName =>
		"AlignmentBalance";

	public required int Id { get; set; }

	public required int StartValue { get; set; }

	public required int EndValue { get; set; }

	public required int NameId { get; set; }

	public required string Name { get; set; }

	public required int DescriptionId { get; set; }

	public required string Description { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		StartValue = d2OClass.ReadFieldAsInt(reader);
		EndValue = d2OClass.ReadFieldAsInt(reader);
		NameId = d2OClass.ReadFieldAsI18N(reader);
		Name = d2OClass.ReadFieldAsI18NString(NameId);
		DescriptionId = d2OClass.ReadFieldAsI18N(reader);
		Description = d2OClass.ReadFieldAsI18NString(DescriptionId);
	}
}
