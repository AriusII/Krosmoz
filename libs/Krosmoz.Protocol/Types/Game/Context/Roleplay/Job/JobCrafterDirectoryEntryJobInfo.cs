// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Types.Game.Context.Roleplay.Job;

public sealed class JobCrafterDirectoryEntryJobInfo : DofusType
{
	public new const ushort StaticProtocolId = 195;

	public override ushort ProtocolId =>
		StaticProtocolId;

	public static JobCrafterDirectoryEntryJobInfo Empty =>
		new() { JobId = 0, JobLevel = 0, UserDefinedParams = 0, MinSlots = 0 };

	public required sbyte JobId { get; set; }

	public required sbyte JobLevel { get; set; }

	public required sbyte UserDefinedParams { get; set; }

	public required sbyte MinSlots { get; set; }

	public override void Serialize(BigEndianWriter writer)
	{
		writer.WriteInt8(JobId);
		writer.WriteInt8(JobLevel);
		writer.WriteInt8(UserDefinedParams);
		writer.WriteInt8(MinSlots);
	}

	public override void Deserialize(BigEndianReader reader)
	{
		JobId = reader.ReadInt8();
		JobLevel = reader.ReadInt8();
		UserDefinedParams = reader.ReadInt8();
		MinSlots = reader.ReadInt8();
	}
}
