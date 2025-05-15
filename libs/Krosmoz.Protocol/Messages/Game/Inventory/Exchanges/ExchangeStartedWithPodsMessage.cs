// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Inventory.Exchanges;

public sealed class ExchangeStartedWithPodsMessage : ExchangeStartedMessage
{
	public new const uint StaticProtocolId = 6129;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static new ExchangeStartedWithPodsMessage Empty =>
		new() { ExchangeType = 0, FirstCharacterId = 0, FirstCharacterCurrentWeight = 0, FirstCharacterMaxWeight = 0, SecondCharacterId = 0, SecondCharacterCurrentWeight = 0, SecondCharacterMaxWeight = 0 };

	public required int FirstCharacterId { get; set; }

	public required int FirstCharacterCurrentWeight { get; set; }

	public required int FirstCharacterMaxWeight { get; set; }

	public required int SecondCharacterId { get; set; }

	public required int SecondCharacterCurrentWeight { get; set; }

	public required int SecondCharacterMaxWeight { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		base.Serialize(writer);
		writer.WriteInt32(FirstCharacterId);
		writer.WriteInt32(FirstCharacterCurrentWeight);
		writer.WriteInt32(FirstCharacterMaxWeight);
		writer.WriteInt32(SecondCharacterId);
		writer.WriteInt32(SecondCharacterCurrentWeight);
		writer.WriteInt32(SecondCharacterMaxWeight);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		base.Deserialize(reader);
		FirstCharacterId = reader.ReadInt32();
		FirstCharacterCurrentWeight = reader.ReadInt32();
		FirstCharacterMaxWeight = reader.ReadInt32();
		SecondCharacterId = reader.ReadInt32();
		SecondCharacterCurrentWeight = reader.ReadInt32();
		SecondCharacterMaxWeight = reader.ReadInt32();
	}
}
