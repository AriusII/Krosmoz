// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Interactive;

public sealed class InteractiveUsedMessage : DofusMessage
{
	public new const uint StaticProtocolId = 5745;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static InteractiveUsedMessage Empty =>
		new() { EntityId = 0, ElemId = 0, SkillId = 0, Duration = 0 };

	public required int EntityId { get; set; }

	public required int ElemId { get; set; }

	public required short SkillId { get; set; }

	public required short Duration { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt32(EntityId);
		writer.WriteInt32(ElemId);
		writer.WriteInt16(SkillId);
		writer.WriteInt16(Duration);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		EntityId = reader.ReadInt32();
		ElemId = reader.ReadInt32();
		SkillId = reader.ReadInt16();
		Duration = reader.ReadInt16();
	}
}
