// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Communication;

public sealed class Emoticon : IDatacenterObject
{
	public static string ModuleName =>
		"Emoticons";

	public required int Id { get; set; }

	public required int NameId { get; set; }

	public required string Name { get; set; }

	public required int ShortcutId { get; set; }

	public required string Shortcut { get; set; }

	public required uint Order { get; set; }

	public required string DefaultAnim { get; set; }

	public required bool Persistancy { get; set; }

	public required bool Eight_directions { get; set; }

	public required bool Aura { get; set; }

	public required List<string> Anims { get; set; }

	public required uint Cooldown { get; set; }

	public required uint Duration { get; set; }

	public required uint Weight { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		NameId = d2OClass.ReadFieldAsI18N(reader);
		Name = d2OClass.ReadFieldAsI18NString(NameId);
		ShortcutId = d2OClass.ReadFieldAsI18N(reader);
		Shortcut = d2OClass.ReadFieldAsI18NString(ShortcutId);
		Order = d2OClass.ReadFieldAsUInt(reader);
		DefaultAnim = d2OClass.ReadFieldAsString(reader);
		Persistancy = d2OClass.ReadFieldAsBoolean(reader);
		Eight_directions = d2OClass.ReadFieldAsBoolean(reader);
		Aura = d2OClass.ReadFieldAsBoolean(reader);
		Anims = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsString(r));
		Cooldown = d2OClass.ReadFieldAsUInt(reader);
		Duration = d2OClass.ReadFieldAsUInt(reader);
		Weight = d2OClass.ReadFieldAsUInt(reader);
	}
}
