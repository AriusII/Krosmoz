// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Inventory.Items;

public sealed class ObjectFoundWhileRecoltingMessage : DofusMessage
{
	public new const uint StaticProtocolId = 6017;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static ObjectFoundWhileRecoltingMessage Empty =>
		new() { GenericId = 0, Quantity = 0, RessourceGenericId = 0 };

	public required int GenericId { get; set; }

	public required int Quantity { get; set; }

	public required int RessourceGenericId { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt32(GenericId);
		writer.WriteInt32(Quantity);
		writer.WriteInt32(RessourceGenericId);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		GenericId = reader.ReadInt32();
		Quantity = reader.ReadInt32();
		RessourceGenericId = reader.ReadInt32();
	}
}
