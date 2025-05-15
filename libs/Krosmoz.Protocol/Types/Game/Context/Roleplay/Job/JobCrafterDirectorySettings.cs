// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Types.Game.Context.Roleplay.Job;

public sealed class JobCrafterDirectorySettings : DofusType
{
	public new const ushort StaticProtocolId = 97;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static JobCrafterDirectorySettings Empty =>
		new() { JobId = 0, MinSlot = 0, UserDefinedParams = 0 };

	public required sbyte JobId { get; set; }

	public required sbyte MinSlot { get; set; }

	public required sbyte UserDefinedParams { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt8(JobId);
		writer.WriteInt8(MinSlot);
		writer.WriteInt8(UserDefinedParams);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		JobId = reader.ReadInt8();
		MinSlot = reader.ReadInt8();
		UserDefinedParams = reader.ReadInt8();
	}
}
