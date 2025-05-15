// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Types.Web.Krosmaster;

public sealed class KrosmasterFigure : DofusType
{
	public new const ushort StaticProtocolId = 397;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static KrosmasterFigure Empty =>
		new() { Uid = string.Empty, Figure = 0, Pedestal = 0, Bound = false };

	public required string Uid { get; set; }

	public required short Figure { get; set; }

	public required short Pedestal { get; set; }

	public required bool Bound { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteUtfPrefixedLength16(Uid);
		writer.WriteInt16(Figure);
		writer.WriteInt16(Pedestal);
		writer.WriteBoolean(Bound);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		Uid = reader.ReadUtfPrefixedLength16();
		Figure = reader.ReadInt16();
		Pedestal = reader.ReadInt16();
		Bound = reader.ReadBoolean();
	}
}
