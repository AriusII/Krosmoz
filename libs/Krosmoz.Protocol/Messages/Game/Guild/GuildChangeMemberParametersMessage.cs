// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Guild;

public sealed class GuildChangeMemberParametersMessage : DofusMessage
{
	public new const uint StaticProtocolId = 5549;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static GuildChangeMemberParametersMessage Empty =>
		new() { MemberId = 0, Rank = 0, ExperienceGivenPercent = 0, Rights = 0 };

	public required int MemberId { get; set; }

	public required short Rank { get; set; }

	public required sbyte ExperienceGivenPercent { get; set; }

	public required uint Rights { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt32(MemberId);
		writer.WriteInt16(Rank);
		writer.WriteInt8(ExperienceGivenPercent);
		writer.WriteUInt32(Rights);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		MemberId = reader.ReadInt32();
		Rank = reader.ReadInt16();
		ExperienceGivenPercent = reader.ReadInt8();
		Rights = reader.ReadUInt32();
	}
}
