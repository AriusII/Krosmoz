// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Types.Game.Data.Items.Effects;

public sealed class ObjectEffectDuration : ObjectEffect
{
	public new const ushort StaticProtocolId = 75;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static new ObjectEffectDuration Empty =>
		new() { ActionId = 0, Days = 0, Hours = 0, Minutes = 0 };

	public required short Days { get; set; }

	public required short Hours { get; set; }

	public required short Minutes { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		base.Serialize(writer);
		writer.WriteInt16(Days);
		writer.WriteInt16(Hours);
		writer.WriteInt16(Minutes);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		base.Deserialize(reader);
		Days = reader.ReadInt16();
		Hours = reader.ReadInt16();
		Minutes = reader.ReadInt16();
	}
}
