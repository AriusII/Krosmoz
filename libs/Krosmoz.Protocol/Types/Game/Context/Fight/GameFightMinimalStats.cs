// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Types.Game.Context.Fight;

public class GameFightMinimalStats : DofusType
{
	public new const ushort StaticProtocolId = 31;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static GameFightMinimalStats Empty =>
		new() { LifePoints = 0, MaxLifePoints = 0, BaseMaxLifePoints = 0, PermanentDamagePercent = 0, ShieldPoints = 0, ActionPoints = 0, MaxActionPoints = 0, MovementPoints = 0, MaxMovementPoints = 0, Summoner = 0, Summoned = false, NeutralElementResistPercent = 0, EarthElementResistPercent = 0, WaterElementResistPercent = 0, AirElementResistPercent = 0, FireElementResistPercent = 0, NeutralElementReduction = 0, EarthElementReduction = 0, WaterElementReduction = 0, AirElementReduction = 0, FireElementReduction = 0, CriticalDamageFixedResist = 0, PushDamageFixedResist = 0, DodgePALostProbability = 0, DodgePMLostProbability = 0, TackleBlock = 0, TackleEvade = 0, InvisibilityState = 0 };

	public required int LifePoints { get; set; }

	public required int MaxLifePoints { get; set; }

	public required int BaseMaxLifePoints { get; set; }

	public required int PermanentDamagePercent { get; set; }

	public required int ShieldPoints { get; set; }

	public required short ActionPoints { get; set; }

	public required short MaxActionPoints { get; set; }

	public required short MovementPoints { get; set; }

	public required short MaxMovementPoints { get; set; }

	public required int Summoner { get; set; }

	public required bool Summoned { get; set; }

	public required short NeutralElementResistPercent { get; set; }

	public required short EarthElementResistPercent { get; set; }

	public required short WaterElementResistPercent { get; set; }

	public required short AirElementResistPercent { get; set; }

	public required short FireElementResistPercent { get; set; }

	public required short NeutralElementReduction { get; set; }

	public required short EarthElementReduction { get; set; }

	public required short WaterElementReduction { get; set; }

	public required short AirElementReduction { get; set; }

	public required short FireElementReduction { get; set; }

	public required short CriticalDamageFixedResist { get; set; }

	public required short PushDamageFixedResist { get; set; }

	public required short DodgePALostProbability { get; set; }

	public required short DodgePMLostProbability { get; set; }

	public required short TackleBlock { get; set; }

	public required short TackleEvade { get; set; }

	public required sbyte InvisibilityState { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt32(LifePoints);
		writer.WriteInt32(MaxLifePoints);
		writer.WriteInt32(BaseMaxLifePoints);
		writer.WriteInt32(PermanentDamagePercent);
		writer.WriteInt32(ShieldPoints);
		writer.WriteInt16(ActionPoints);
		writer.WriteInt16(MaxActionPoints);
		writer.WriteInt16(MovementPoints);
		writer.WriteInt16(MaxMovementPoints);
		writer.WriteInt32(Summoner);
		writer.WriteBoolean(Summoned);
		writer.WriteInt16(NeutralElementResistPercent);
		writer.WriteInt16(EarthElementResistPercent);
		writer.WriteInt16(WaterElementResistPercent);
		writer.WriteInt16(AirElementResistPercent);
		writer.WriteInt16(FireElementResistPercent);
		writer.WriteInt16(NeutralElementReduction);
		writer.WriteInt16(EarthElementReduction);
		writer.WriteInt16(WaterElementReduction);
		writer.WriteInt16(AirElementReduction);
		writer.WriteInt16(FireElementReduction);
		writer.WriteInt16(CriticalDamageFixedResist);
		writer.WriteInt16(PushDamageFixedResist);
		writer.WriteInt16(DodgePALostProbability);
		writer.WriteInt16(DodgePMLostProbability);
		writer.WriteInt16(TackleBlock);
		writer.WriteInt16(TackleEvade);
		writer.WriteInt8(InvisibilityState);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		LifePoints = reader.ReadInt32();
		MaxLifePoints = reader.ReadInt32();
		BaseMaxLifePoints = reader.ReadInt32();
		PermanentDamagePercent = reader.ReadInt32();
		ShieldPoints = reader.ReadInt32();
		ActionPoints = reader.ReadInt16();
		MaxActionPoints = reader.ReadInt16();
		MovementPoints = reader.ReadInt16();
		MaxMovementPoints = reader.ReadInt16();
		Summoner = reader.ReadInt32();
		Summoned = reader.ReadBoolean();
		NeutralElementResistPercent = reader.ReadInt16();
		EarthElementResistPercent = reader.ReadInt16();
		WaterElementResistPercent = reader.ReadInt16();
		AirElementResistPercent = reader.ReadInt16();
		FireElementResistPercent = reader.ReadInt16();
		NeutralElementReduction = reader.ReadInt16();
		EarthElementReduction = reader.ReadInt16();
		WaterElementReduction = reader.ReadInt16();
		AirElementReduction = reader.ReadInt16();
		FireElementReduction = reader.ReadInt16();
		CriticalDamageFixedResist = reader.ReadInt16();
		PushDamageFixedResist = reader.ReadInt16();
		DodgePALostProbability = reader.ReadInt16();
		DodgePMLostProbability = reader.ReadInt16();
		TackleBlock = reader.ReadInt16();
		TackleEvade = reader.ReadInt16();
		InvisibilityState = reader.ReadInt8();
	}
}
