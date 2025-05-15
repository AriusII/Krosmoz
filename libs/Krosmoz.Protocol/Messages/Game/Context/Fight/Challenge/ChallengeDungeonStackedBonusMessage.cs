// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Context.Fight.Challenge;

public sealed class ChallengeDungeonStackedBonusMessage : DofusMessage
{
	public new const uint StaticProtocolId = 6151;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static ChallengeDungeonStackedBonusMessage Empty =>
		new() { DungeonId = 0, XpBonus = 0, DropBonus = 0 };

	public required int DungeonId { get; set; }

	public required int XpBonus { get; set; }

	public required int DropBonus { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt32(DungeonId);
		writer.WriteInt32(XpBonus);
		writer.WriteInt32(DropBonus);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		DungeonId = reader.ReadInt32();
		XpBonus = reader.ReadInt32();
		DropBonus = reader.ReadInt32();
	}
}
