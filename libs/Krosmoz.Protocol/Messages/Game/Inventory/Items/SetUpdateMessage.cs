// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Types.Game.Data.Items.Effects;

namespace Krosmoz.Protocol.Messages.Game.Inventory.Items;

public sealed class SetUpdateMessage : DofusMessage
{
	public new const uint StaticProtocolId = 5503;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static SetUpdateMessage Empty =>
		new() { SetId = 0, SetObjects = [], SetEffects = [] };

	public required short SetId { get; set; }

	public required IEnumerable<short> SetObjects { get; set; }

	public required IEnumerable<ObjectEffect> SetEffects { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt16(SetId);
		var setObjectsBefore = writer.Position;
		var setObjectsCount = 0;
		writer.WriteInt16(0);
		foreach (var item in SetObjects)
		{
			writer.WriteInt16(item);
			setObjectsCount++;
		}
		var setObjectsAfter = writer.Position;
		writer.Seek(SeekOrigin.Begin, setObjectsBefore);
		writer.WriteInt16((short)setObjectsCount);
		writer.Seek(SeekOrigin.Begin, setObjectsAfter);
		var setEffectsBefore = writer.Position;
		var setEffectsCount = 0;
		writer.WriteInt16(0);
		foreach (var item in SetEffects)
		{
			writer.WriteUInt16(item.ProtocolId);
			item.Serialize(writer);
			setEffectsCount++;
		}
		var setEffectsAfter = writer.Position;
		writer.Seek(SeekOrigin.Begin, setEffectsBefore);
		writer.WriteInt16((short)setEffectsCount);
		writer.Seek(SeekOrigin.Begin, setEffectsAfter);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		SetId = reader.ReadInt16();
		var setObjectsCount = reader.ReadInt16();
		var setObjects = new short[setObjectsCount];
		for (var i = 0; i < setObjectsCount; i++)
		{
			setObjects[i] = reader.ReadInt16();
		}
		SetObjects = setObjects;
		var setEffectsCount = reader.ReadInt16();
		var setEffects = new ObjectEffect[setEffectsCount];
		for (var i = 0; i < setEffectsCount; i++)
		{
			var entry = Types.TypeFactory.CreateType<ObjectEffect>(reader.ReadUInt16());
			entry.Deserialize(reader);
			setEffects[i] = entry;
		}
		SetEffects = setEffects;
	}
}
