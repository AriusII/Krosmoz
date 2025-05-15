// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Inventory.Items;

public sealed class LivingObjectMessageMessage : DofusMessage
{
	public new const uint StaticProtocolId = 6065;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static LivingObjectMessageMessage Empty =>
		new() { MsgId = 0, TimeStamp = 0, Owner = string.Empty, ObjectGenericId = 0 };

	public required short MsgId { get; set; }

	public required uint TimeStamp { get; set; }

	public required string Owner { get; set; }

	public required uint ObjectGenericId { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt16(MsgId);
		writer.WriteUInt32(TimeStamp);
		writer.WriteUtfPrefixedLength16(Owner);
		writer.WriteUInt32(ObjectGenericId);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		MsgId = reader.ReadInt16();
		TimeStamp = reader.ReadUInt32();
		Owner = reader.ReadUtfPrefixedLength16();
		ObjectGenericId = reader.ReadUInt32();
	}
}
