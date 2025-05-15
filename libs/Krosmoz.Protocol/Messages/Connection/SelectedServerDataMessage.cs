// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Connection;

public sealed class SelectedServerDataMessage : DofusMessage
{
	public new const uint StaticProtocolId = 42;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static SelectedServerDataMessage Empty =>
		new() { ServerId = 0, Address = string.Empty, Port = 0, CanCreateNewCharacter = false, Ticket = string.Empty };

	public required short ServerId { get; set; }

	public required string Address { get; set; }

	public required ushort Port { get; set; }

	public required bool CanCreateNewCharacter { get; set; }

	public required string Ticket { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt16(ServerId);
		writer.WriteUtfPrefixedLength16(Address);
		writer.WriteUInt16(Port);
		writer.WriteBoolean(CanCreateNewCharacter);
		writer.WriteUtfPrefixedLength16(Ticket);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		ServerId = reader.ReadInt16();
		Address = reader.ReadUtfPrefixedLength16();
		Port = reader.ReadUInt16();
		CanCreateNewCharacter = reader.ReadBoolean();
		Ticket = reader.ReadUtfPrefixedLength16();
	}
}
