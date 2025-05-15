// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Types.Game.Data.Items.Effects;

public sealed class ObjectEffectDice : ObjectEffect
{
	public new const ushort StaticProtocolId = 73;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static new ObjectEffectDice Empty =>
		new() { ActionId = 0, DiceNum = 0, DiceSide = 0, DiceConst = 0 };

	public required short DiceNum { get; set; }

	public required short DiceSide { get; set; }

	public required short DiceConst { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		base.Serialize(writer);
		writer.WriteInt16(DiceNum);
		writer.WriteInt16(DiceSide);
		writer.WriteInt16(DiceConst);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		base.Deserialize(reader);
		DiceNum = reader.ReadInt16();
		DiceSide = reader.ReadInt16();
		DiceConst = reader.ReadInt16();
	}
}
