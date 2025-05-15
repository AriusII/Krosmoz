// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Jobs;

public sealed class Recipe : IDatacenterObject
{
	public static string ModuleName =>
		"Recipes";

	public required int ResultId { get; set; }

	public required int ResultLevel { get; set; }

	public required List<int> IngredientIds { get; set; }

	public required List<uint> Quantities { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		ResultId = d2OClass.ReadFieldAsInt(reader);
		ResultLevel = d2OClass.ReadFieldAsInt(reader);
		IngredientIds = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsInt(r));
		Quantities = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
	}
}
