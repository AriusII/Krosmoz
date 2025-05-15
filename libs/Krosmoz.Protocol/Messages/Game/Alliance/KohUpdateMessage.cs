// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Types.Game.Context.Roleplay;

namespace Krosmoz.Protocol.Messages.Game.Alliance;

public sealed class KohUpdateMessage : DofusMessage
{
	public new const uint StaticProtocolId = 6439;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static KohUpdateMessage Empty =>
		new() { Alliances = [], AllianceNbMembers = [], AllianceRoundWeigth = [], AllianceMatchScore = [], AllianceMapWinner = BasicAllianceInformations.Empty, AllianceMapWinnerScore = 0, AllianceMapMyAllianceScore = 0 };

	public required IEnumerable<AllianceInformations> Alliances { get; set; }

	public required IEnumerable<short> AllianceNbMembers { get; set; }

	public required IEnumerable<int> AllianceRoundWeigth { get; set; }

	public required IEnumerable<sbyte> AllianceMatchScore { get; set; }

	public required BasicAllianceInformations AllianceMapWinner { get; set; }

	public required int AllianceMapWinnerScore { get; set; }

	public required int AllianceMapMyAllianceScore { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		var alliancesBefore = writer.Position;
		var alliancesCount = 0;
		writer.WriteInt16(0);
		foreach (var item in Alliances)
		{
			item.Serialize(writer);
			alliancesCount++;
		}
		var alliancesAfter = writer.Position;
		writer.Seek(SeekOrigin.Begin, alliancesBefore);
		writer.WriteInt16((short)alliancesCount);
		writer.Seek(SeekOrigin.Begin, alliancesAfter);
		var allianceNbMembersBefore = writer.Position;
		var allianceNbMembersCount = 0;
		writer.WriteInt16(0);
		foreach (var item in AllianceNbMembers)
		{
			writer.WriteInt16(item);
			allianceNbMembersCount++;
		}
		var allianceNbMembersAfter = writer.Position;
		writer.Seek(SeekOrigin.Begin, allianceNbMembersBefore);
		writer.WriteInt16((short)allianceNbMembersCount);
		writer.Seek(SeekOrigin.Begin, allianceNbMembersAfter);
		var allianceRoundWeigthBefore = writer.Position;
		var allianceRoundWeigthCount = 0;
		writer.WriteInt16(0);
		foreach (var item in AllianceRoundWeigth)
		{
			writer.WriteInt32(item);
			allianceRoundWeigthCount++;
		}
		var allianceRoundWeigthAfter = writer.Position;
		writer.Seek(SeekOrigin.Begin, allianceRoundWeigthBefore);
		writer.WriteInt16((short)allianceRoundWeigthCount);
		writer.Seek(SeekOrigin.Begin, allianceRoundWeigthAfter);
		var allianceMatchScoreBefore = writer.Position;
		var allianceMatchScoreCount = 0;
		writer.WriteInt16(0);
		foreach (var item in AllianceMatchScore)
		{
			writer.WriteInt8(item);
			allianceMatchScoreCount++;
		}
		var allianceMatchScoreAfter = writer.Position;
		writer.Seek(SeekOrigin.Begin, allianceMatchScoreBefore);
		writer.WriteInt16((short)allianceMatchScoreCount);
		writer.Seek(SeekOrigin.Begin, allianceMatchScoreAfter);
		AllianceMapWinner.Serialize(writer);
		writer.WriteInt32(AllianceMapWinnerScore);
		writer.WriteInt32(AllianceMapMyAllianceScore);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		var alliancesCount = reader.ReadInt16();
		var alliances = new AllianceInformations[alliancesCount];
		for (var i = 0; i < alliancesCount; i++)
		{
			var entry = AllianceInformations.Empty;
			entry.Deserialize(reader);
			alliances[i] = entry;
		}
		Alliances = alliances;
		var allianceNbMembersCount = reader.ReadInt16();
		var allianceNbMembers = new short[allianceNbMembersCount];
		for (var i = 0; i < allianceNbMembersCount; i++)
		{
			allianceNbMembers[i] = reader.ReadInt16();
		}
		AllianceNbMembers = allianceNbMembers;
		var allianceRoundWeigthCount = reader.ReadInt16();
		var allianceRoundWeigth = new int[allianceRoundWeigthCount];
		for (var i = 0; i < allianceRoundWeigthCount; i++)
		{
			allianceRoundWeigth[i] = reader.ReadInt32();
		}
		AllianceRoundWeigth = allianceRoundWeigth;
		var allianceMatchScoreCount = reader.ReadInt16();
		var allianceMatchScore = new sbyte[allianceMatchScoreCount];
		for (var i = 0; i < allianceMatchScoreCount; i++)
		{
			allianceMatchScore[i] = reader.ReadInt8();
		}
		AllianceMatchScore = allianceMatchScore;
		AllianceMapWinner = BasicAllianceInformations.Empty;
		AllianceMapWinner.Deserialize(reader);
		AllianceMapWinnerScore = reader.ReadInt32();
		AllianceMapMyAllianceScore = reader.ReadInt32();
	}
}
