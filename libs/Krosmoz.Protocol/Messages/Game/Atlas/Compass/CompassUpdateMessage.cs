// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Atlas.Compass;

public class CompassUpdateMessage : DofusMessage
{
	public new const uint StaticProtocolId = 5591;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static CompassUpdateMessage Empty =>
		new() { Type = 0, WorldX = 0, WorldY = 0 };

	public required sbyte Type { get; set; }

	public required short WorldX { get; set; }

	public required short WorldY { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt8(Type);
		writer.WriteInt16(WorldX);
		writer.WriteInt16(WorldY);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		Type = reader.ReadInt8();
		WorldX = reader.ReadInt16();
		WorldY = reader.ReadInt16();
	}
}
