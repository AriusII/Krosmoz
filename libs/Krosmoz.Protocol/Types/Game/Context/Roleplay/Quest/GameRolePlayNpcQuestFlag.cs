// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Types.Game.Context.Roleplay.Quest;

public sealed class GameRolePlayNpcQuestFlag : DofusType
{
	public new const ushort StaticProtocolId = 384;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static GameRolePlayNpcQuestFlag Empty =>
		new() { QuestsToValidId = [], QuestsToStartId = [] };

	public required IEnumerable<short> QuestsToValidId { get; set; }

	public required IEnumerable<short> QuestsToStartId { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		var questsToValidIdBefore = writer.Position;
		var questsToValidIdCount = 0;
		writer.WriteInt16(0);
		foreach (var item in QuestsToValidId)
		{
			writer.WriteInt16(item);
			questsToValidIdCount++;
		}
		var questsToValidIdAfter = writer.Position;
		writer.Seek(SeekOrigin.Begin, questsToValidIdBefore);
		writer.WriteInt16((short)questsToValidIdCount);
		writer.Seek(SeekOrigin.Begin, questsToValidIdAfter);
		var questsToStartIdBefore = writer.Position;
		var questsToStartIdCount = 0;
		writer.WriteInt16(0);
		foreach (var item in QuestsToStartId)
		{
			writer.WriteInt16(item);
			questsToStartIdCount++;
		}
		var questsToStartIdAfter = writer.Position;
		writer.Seek(SeekOrigin.Begin, questsToStartIdBefore);
		writer.WriteInt16((short)questsToStartIdCount);
		writer.Seek(SeekOrigin.Begin, questsToStartIdAfter);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		var questsToValidIdCount = reader.ReadInt16();
		var questsToValidId = new short[questsToValidIdCount];
		for (var i = 0; i < questsToValidIdCount; i++)
		{
			questsToValidId[i] = reader.ReadInt16();
		}
		QuestsToValidId = questsToValidId;
		var questsToStartIdCount = reader.ReadInt16();
		var questsToStartId = new short[questsToStartIdCount];
		for (var i = 0; i < questsToStartIdCount; i++)
		{
			questsToStartId[i] = reader.ReadInt16();
		}
		QuestsToStartId = questsToStartId;
	}
}
