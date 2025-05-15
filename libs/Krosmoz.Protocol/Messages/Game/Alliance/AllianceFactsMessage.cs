// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Types.Game.Context.Roleplay;
using Krosmoz.Protocol.Types.Game.Social;

namespace Krosmoz.Protocol.Messages.Game.Alliance;

public sealed class AllianceFactsMessage : DofusMessage
{
	public new const uint StaticProtocolId = 6414;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static AllianceFactsMessage Empty =>
		new() { Infos = AllianceFactSheetInformations.Empty, Guilds = [], ControlledSubareaIds = [] };

	public required AllianceFactSheetInformations Infos { get; set; }

	public required IEnumerable<GuildInAllianceInformations> Guilds { get; set; }

	public required IEnumerable<short> ControlledSubareaIds { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteUInt16(Infos.ProtocolId);
		Infos.Serialize(writer);
		var guildsBefore = writer.Position;
		var guildsCount = 0;
		writer.WriteInt16(0);
		foreach (var item in Guilds)
		{
			item.Serialize(writer);
			guildsCount++;
		}
		var guildsAfter = writer.Position;
		writer.Seek(SeekOrigin.Begin, guildsBefore);
		writer.WriteInt16((short)guildsCount);
		writer.Seek(SeekOrigin.Begin, guildsAfter);
		var controlledSubareaIdsBefore = writer.Position;
		var controlledSubareaIdsCount = 0;
		writer.WriteInt16(0);
		foreach (var item in ControlledSubareaIds)
		{
			writer.WriteInt16(item);
			controlledSubareaIdsCount++;
		}
		var controlledSubareaIdsAfter = writer.Position;
		writer.Seek(SeekOrigin.Begin, controlledSubareaIdsBefore);
		writer.WriteInt16((short)controlledSubareaIdsCount);
		writer.Seek(SeekOrigin.Begin, controlledSubareaIdsAfter);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		Infos = Types.TypeFactory.CreateType<AllianceFactSheetInformations>(reader.ReadUInt16());
		Infos.Deserialize(reader);
		var guildsCount = reader.ReadInt16();
		var guilds = new GuildInAllianceInformations[guildsCount];
		for (var i = 0; i < guildsCount; i++)
		{
			var entry = GuildInAllianceInformations.Empty;
			entry.Deserialize(reader);
			guilds[i] = entry;
		}
		Guilds = guilds;
		var controlledSubareaIdsCount = reader.ReadInt16();
		var controlledSubareaIds = new short[controlledSubareaIdsCount];
		for (var i = 0; i < controlledSubareaIdsCount; i++)
		{
			controlledSubareaIds[i] = reader.ReadInt16();
		}
		ControlledSubareaIds = controlledSubareaIds;
	}
}
