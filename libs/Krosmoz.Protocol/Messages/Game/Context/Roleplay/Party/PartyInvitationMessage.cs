// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Context.Roleplay.Party;

public class PartyInvitationMessage : AbstractPartyMessage
{
	public new const uint StaticProtocolId = 5586;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static new PartyInvitationMessage Empty =>
		new() { PartyId = 0, PartyType = 0, MaxParticipants = 0, FromId = 0, FromName = string.Empty, ToId = 0 };

	public required sbyte PartyType { get; set; }

	public required sbyte MaxParticipants { get; set; }

	public required int FromId { get; set; }

	public required string FromName { get; set; }

	public required int ToId { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		base.Serialize(writer);
		writer.WriteInt8(PartyType);
		writer.WriteInt8(MaxParticipants);
		writer.WriteInt32(FromId);
		writer.WriteUtfPrefixedLength16(FromName);
		writer.WriteInt32(ToId);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		base.Deserialize(reader);
		PartyType = reader.ReadInt8();
		MaxParticipants = reader.ReadInt8();
		FromId = reader.ReadInt32();
		FromName = reader.ReadUtfPrefixedLength16();
		ToId = reader.ReadInt32();
	}
}
