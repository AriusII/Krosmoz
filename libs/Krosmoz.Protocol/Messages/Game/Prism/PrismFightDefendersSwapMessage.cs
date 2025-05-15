// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Prism;

public sealed class PrismFightDefendersSwapMessage : DofusMessage
{
	public new const uint StaticProtocolId = 5902;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static PrismFightDefendersSwapMessage Empty =>
		new() { SubAreaId = 0, FightId = 0, FighterId1 = 0, FighterId2 = 0 };

	public required short SubAreaId { get; set; }

	public required double FightId { get; set; }

	public required int FighterId1 { get; set; }

	public required int FighterId2 { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt16(SubAreaId);
		writer.WriteDouble(FightId);
		writer.WriteInt32(FighterId1);
		writer.WriteInt32(FighterId2);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		SubAreaId = reader.ReadInt16();
		FightId = reader.ReadDouble();
		FighterId1 = reader.ReadInt32();
		FighterId2 = reader.ReadInt32();
	}
}
