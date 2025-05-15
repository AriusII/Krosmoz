// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Messages.Game.Approach;

public sealed class AccountCapabilitiesMessage : DofusMessage
{
	public new const uint StaticProtocolId = 6216;

	public override uint ProtocolId =>
		StaticProtocolId;

	public static AccountCapabilitiesMessage Empty =>
		new() { AccountId = 0, TutorialAvailable = false, BreedsVisible = 0, BreedsAvailable = 0, Status = 0 };

	public required int AccountId { get; set; }

	public required bool TutorialAvailable { get; set; }

	public required short BreedsVisible { get; set; }

	public required short BreedsAvailable { get; set; }

	public required sbyte Status { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt32(AccountId);
		writer.WriteBoolean(TutorialAvailable);
		writer.WriteInt16(BreedsVisible);
		writer.WriteInt16(BreedsAvailable);
		writer.WriteInt8(Status);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		AccountId = reader.ReadInt32();
		TutorialAvailable = reader.ReadBoolean();
		BreedsVisible = reader.ReadInt16();
		BreedsAvailable = reader.ReadInt16();
		Status = reader.ReadInt8();
	}
}
