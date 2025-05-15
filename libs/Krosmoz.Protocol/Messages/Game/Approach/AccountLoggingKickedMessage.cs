// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Approach;

public sealed class AccountLoggingKickedMessage : DofusMessage
{
	public new const uint StaticProtocolId = 6029;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static AccountLoggingKickedMessage Empty =>
		new() { Days = 0, Hours = 0, Minutes = 0 };

	public required int Days { get; set; }

	public required int Hours { get; set; }

	public required int Minutes { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt32(Days);
		writer.WriteInt32(Hours);
		writer.WriteInt32(Minutes);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		Days = reader.ReadInt32();
		Hours = reader.ReadInt32();
		Minutes = reader.ReadInt32();
	}
}
