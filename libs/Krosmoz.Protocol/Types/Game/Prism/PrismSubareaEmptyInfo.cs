// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Types.Game.Prism;

public class PrismSubareaEmptyInfo : DofusType
{
	public new const ushort StaticProtocolId = 438;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static PrismSubareaEmptyInfo Empty =>
		new() { SubAreaId = 0, AllianceId = 0 };

	public required short SubAreaId { get; set; }

	public required int AllianceId { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt16(SubAreaId);
		writer.WriteInt32(AllianceId);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		SubAreaId = reader.ReadInt16();
		AllianceId = reader.ReadInt32();
	}
}
