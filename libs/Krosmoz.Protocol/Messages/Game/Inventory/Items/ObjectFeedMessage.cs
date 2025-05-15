// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Inventory.Items;

public sealed class ObjectFeedMessage : DofusMessage
{
	public new const uint StaticProtocolId = 6290;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static ObjectFeedMessage Empty =>
		new() { ObjectUID = 0, FoodUID = 0, FoodQuantity = 0 };

	public required int ObjectUID { get; set; }

	public required int FoodUID { get; set; }

	public required short FoodQuantity { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt32(ObjectUID);
		writer.WriteInt32(FoodUID);
		writer.WriteInt16(FoodQuantity);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		ObjectUID = reader.ReadInt32();
		FoodUID = reader.ReadInt32();
		FoodQuantity = reader.ReadInt16();
	}
}
