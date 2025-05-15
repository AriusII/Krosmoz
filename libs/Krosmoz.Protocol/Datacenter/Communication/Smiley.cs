// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Communication;

public sealed class Smiley : IDatacenterObject
{
	public static string ModuleName =>
		"Smileys";

	public required int Id { get; set; }

	public required int Order { get; set; }

	public required string GfxId { get; set; }

	public required bool ForPlayers { get; set; }

	public required List<string> Triggers { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		Order = d2OClass.ReadFieldAsInt(reader);
		GfxId = d2OClass.ReadFieldAsString(reader);
		ForPlayers = d2OClass.ReadFieldAsBoolean(reader);
		Triggers = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsString(r));
	}
}
