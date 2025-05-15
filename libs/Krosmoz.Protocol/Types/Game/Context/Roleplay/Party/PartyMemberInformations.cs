// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Types.Game.Character.Choice;
using Krosmoz.Protocol.Types.Game.Character.Status;
using Krosmoz.Protocol.Types.Game.Look;

namespace Krosmoz.Protocol.Types.Game.Context.Roleplay.Party;

public class PartyMemberInformations : CharacterBaseInformations
{
	public new const ushort StaticProtocolId = 90;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static new PartyMemberInformations Empty =>
		new() { Id = 0, Name = string.Empty, Level = 0, EntityLook = EntityLook.Empty, Sex = false, Breed = 0, LifePoints = 0, MaxLifePoints = 0, Prospecting = 0, RegenRate = 0, Initiative = 0, AlignmentSide = 0, WorldX = 0, WorldY = 0, MapId = 0, SubAreaId = 0, Status = PlayerStatus.Empty };

	public required int LifePoints { get; set; }

	public required int MaxLifePoints { get; set; }

	public required short Prospecting { get; set; }

	public required byte RegenRate { get; set; }

	public required short Initiative { get; set; }

	public required sbyte AlignmentSide { get; set; }

	public required short WorldX { get; set; }

	public required short WorldY { get; set; }

	public required int MapId { get; set; }

	public required short SubAreaId { get; set; }

	public required PlayerStatus Status { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		base.Serialize(writer);
		writer.WriteInt32(LifePoints);
		writer.WriteInt32(MaxLifePoints);
		writer.WriteInt16(Prospecting);
		writer.WriteUInt8(RegenRate);
		writer.WriteInt16(Initiative);
		writer.WriteInt8(AlignmentSide);
		writer.WriteInt16(WorldX);
		writer.WriteInt16(WorldY);
		writer.WriteInt32(MapId);
		writer.WriteInt16(SubAreaId);
		writer.WriteUInt16(Status.ProtocolId);
		Status.Serialize(writer);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		base.Deserialize(reader);
		LifePoints = reader.ReadInt32();
		MaxLifePoints = reader.ReadInt32();
		Prospecting = reader.ReadInt16();
		RegenRate = reader.ReadUInt8();
		Initiative = reader.ReadInt16();
		AlignmentSide = reader.ReadInt8();
		WorldX = reader.ReadInt16();
		WorldY = reader.ReadInt16();
		MapId = reader.ReadInt32();
		SubAreaId = reader.ReadInt16();
		Status = TypeFactory.CreateType<PlayerStatus>(reader.ReadUInt16());
		Status.Deserialize(reader);
	}
}
