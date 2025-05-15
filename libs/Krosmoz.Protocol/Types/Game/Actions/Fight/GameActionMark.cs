// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Types.Game.Actions.Fight;

public sealed class GameActionMark : DofusType
{
	public new const ushort StaticProtocolId = 351;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static GameActionMark Empty =>
		new() { MarkAuthorId = 0, MarkSpellId = 0, MarkId = 0, MarkType = 0, Cells = [] };

	public required int MarkAuthorId { get; set; }

	public required int MarkSpellId { get; set; }

	public required short MarkId { get; set; }

	public required sbyte MarkType { get; set; }

	public required IEnumerable<GameActionMarkedCell> Cells { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt32(MarkAuthorId);
		writer.WriteInt32(MarkSpellId);
		writer.WriteInt16(MarkId);
		writer.WriteInt8(MarkType);
		var cellsBefore = writer.Position;
		var cellsCount = 0;
		writer.WriteInt16(0);
		foreach (var item in Cells)
		{
			item.Serialize(writer);
			cellsCount++;
		}
		var cellsAfter = writer.Position;
		writer.Seek(SeekOrigin.Begin, cellsBefore);
		writer.WriteInt16((short)cellsCount);
		writer.Seek(SeekOrigin.Begin, cellsAfter);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		MarkAuthorId = reader.ReadInt32();
		MarkSpellId = reader.ReadInt32();
		MarkId = reader.ReadInt16();
		MarkType = reader.ReadInt8();
		var cellsCount = reader.ReadInt16();
		var cells = new GameActionMarkedCell[cellsCount];
		for (var i = 0; i < cellsCount; i++)
		{
			var entry = GameActionMarkedCell.Empty;
			entry.Deserialize(reader);
			cells[i] = entry;
		}
		Cells = cells;
	}
}
