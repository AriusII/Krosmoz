// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Context.Roleplay.Stats;

public sealed class StatsUpgradeRequestMessage : DofusMessage
{
	public new const uint StaticProtocolId = 5610;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static StatsUpgradeRequestMessage Empty =>
		new() { StatId = 0, BoostPoint = 0 };

	public required sbyte StatId { get; set; }

	public required short BoostPoint { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt8(StatId);
		writer.WriteInt16(BoostPoint);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		StatId = reader.ReadInt8();
		BoostPoint = reader.ReadInt16();
	}
}
