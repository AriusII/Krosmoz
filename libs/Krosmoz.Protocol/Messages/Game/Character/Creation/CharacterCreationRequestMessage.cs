// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Character.Creation;

public sealed class CharacterCreationRequestMessage : DofusMessage
{
	public new const uint StaticProtocolId = 160;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static CharacterCreationRequestMessage Empty =>
		new() { Name = string.Empty, Breed = 0, Sex = false, Colors = [], CosmeticId = 0 };

	public required string Name { get; set; }

	public required sbyte Breed { get; set; }

	public required bool Sex { get; set; }

	public required IEnumerable<int> Colors { get; set; }

	public required int CosmeticId { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteUtfPrefixedLength16(Name);
		writer.WriteInt8(Breed);
		writer.WriteBoolean(Sex);
		foreach (var item in Colors)
		{
			writer.WriteInt32(item);
		}
		writer.WriteInt32(CosmeticId);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		Name = reader.ReadUtfPrefixedLength16();
		Breed = reader.ReadInt8();
		Sex = reader.ReadBoolean();
		var colors = new int[5];
		for (var i = 0; i < colors.Length; i++)
		{
			colors[i] = reader.ReadInt32();
		}
		Colors = colors;
		CosmeticId = reader.ReadInt32();
	}
}
