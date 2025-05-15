// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Types.Game.Context.Roleplay;

namespace Krosmoz.Protocol.Types.Game.Context;

public class TaxCollectorStaticInformations : DofusType
{
	public new const ushort StaticProtocolId = 147;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static TaxCollectorStaticInformations Empty =>
		new() { FirstNameId = 0, LastNameId = 0, GuildIdentity = GuildInformations.Empty };

	public required short FirstNameId { get; set; }

	public required short LastNameId { get; set; }

	public required GuildInformations GuildIdentity { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt16(FirstNameId);
		writer.WriteInt16(LastNameId);
		GuildIdentity.Serialize(writer);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		FirstNameId = reader.ReadInt16();
		LastNameId = reader.ReadInt16();
		GuildIdentity = GuildInformations.Empty;
		GuildIdentity.Deserialize(reader);
	}
}
