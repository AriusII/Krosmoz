// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Types.Game.Guild.Tax;

public sealed class TaxCollectorLootInformations : TaxCollectorComplementaryInformations
{
	public new const ushort StaticProtocolId = 372;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static new TaxCollectorLootInformations Empty =>
		new() { Kamas = 0, Experience = 0, Pods = 0, ItemsValue = 0 };

	public required int Kamas { get; set; }

	public required double Experience { get; set; }

	public required int Pods { get; set; }

	public required int ItemsValue { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		base.Serialize(writer);
		writer.WriteInt32(Kamas);
		writer.WriteDouble(Experience);
		writer.WriteInt32(Pods);
		writer.WriteInt32(ItemsValue);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		base.Deserialize(reader);
		Kamas = reader.ReadInt32();
		Experience = reader.ReadDouble();
		Pods = reader.ReadInt32();
		ItemsValue = reader.ReadInt32();
	}
}
