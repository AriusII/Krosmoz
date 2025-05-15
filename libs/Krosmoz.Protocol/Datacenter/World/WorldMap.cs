// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.World;

public sealed class WorldMap : IDatacenterObject
{
	public static string ModuleName =>
		"WorldMaps";

	public required int Id { get; set; }

	public required int OrigineX { get; set; }

	public required int OrigineY { get; set; }

	public required double MapWidth { get; set; }

	public required double MapHeight { get; set; }

	public required int HorizontalChunck { get; set; }

	public required int VerticalChunck { get; set; }

	public required bool ViewableEverywhere { get; set; }

	public required double MinScale { get; set; }

	public required double MaxScale { get; set; }

	public required double StartScale { get; set; }

	public required int CenterX { get; set; }

	public required int CenterY { get; set; }

	public required int TotalWidth { get; set; }

	public required int TotalHeight { get; set; }

	public required List<string> Zoom { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		OrigineX = d2OClass.ReadFieldAsInt(reader);
		OrigineY = d2OClass.ReadFieldAsInt(reader);
		MapWidth = d2OClass.ReadFieldAsNumber(reader);
		MapHeight = d2OClass.ReadFieldAsNumber(reader);
		HorizontalChunck = d2OClass.ReadFieldAsInt(reader);
		VerticalChunck = d2OClass.ReadFieldAsInt(reader);
		ViewableEverywhere = d2OClass.ReadFieldAsBoolean(reader);
		MinScale = d2OClass.ReadFieldAsNumber(reader);
		MaxScale = d2OClass.ReadFieldAsNumber(reader);
		StartScale = d2OClass.ReadFieldAsNumber(reader);
		CenterX = d2OClass.ReadFieldAsInt(reader);
		CenterY = d2OClass.ReadFieldAsInt(reader);
		TotalWidth = d2OClass.ReadFieldAsInt(reader);
		TotalHeight = d2OClass.ReadFieldAsInt(reader);
		Zoom = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsString(r));
	}
}
