// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Types.Game.Character.Characteristic;

public sealed class CharacterBaseCharacteristic : DofusType
{
	public new const ushort StaticProtocolId = 4;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static CharacterBaseCharacteristic Empty =>
		new() { @Base = 0, ObjectsAndMountBonus = 0, AlignGiftBonus = 0, ContextModif = 0 };

	public required short @Base { get; set; }

	public required short ObjectsAndMountBonus { get; set; }

	public required short AlignGiftBonus { get; set; }

	public required short ContextModif { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt16(@Base);
		writer.WriteInt16(ObjectsAndMountBonus);
		writer.WriteInt16(AlignGiftBonus);
		writer.WriteInt16(ContextModif);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		@Base = reader.ReadInt16();
		ObjectsAndMountBonus = reader.ReadInt16();
		AlignGiftBonus = reader.ReadInt16();
		ContextModif = reader.ReadInt16();
	}
}
