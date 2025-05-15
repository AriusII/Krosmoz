// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Alignments;

public sealed class AlignmentRankJntGift : IDatacenterObject
{
	public static string ModuleName =>
		"AlignmentRankJntGift";

	public required int Id { get; set; }

	public required List<int> Gifts { get; set; }

	public required List<int> Parameters { get; set; }

	public required List<int> Levels { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		Gifts = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsInt(r));
		Parameters = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsInt(r));
		Levels = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsInt(r));
	}
}
