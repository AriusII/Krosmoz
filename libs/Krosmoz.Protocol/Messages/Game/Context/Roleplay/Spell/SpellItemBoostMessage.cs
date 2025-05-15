// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Context.Roleplay.Spell;

public sealed class SpellItemBoostMessage : DofusMessage
{
	public new const uint StaticProtocolId = 6011;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static SpellItemBoostMessage Empty =>
		new() { StatId = 0, SpellId = 0, Value = 0 };

	public required int StatId { get; set; }

	public required short SpellId { get; set; }

	public required short Value { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt32(StatId);
		writer.WriteInt16(SpellId);
		writer.WriteInt16(Value);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		StatId = reader.ReadInt32();
		SpellId = reader.ReadInt16();
		Value = reader.ReadInt16();
	}
}
