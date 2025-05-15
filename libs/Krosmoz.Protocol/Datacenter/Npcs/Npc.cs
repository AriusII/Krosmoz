// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Npcs;

public sealed class Npc : IDatacenterObject
{
	public static string ModuleName =>
		"Npcs";

	public required int Id { get; set; }

	public required int NameId { get; set; }

	public required string Name { get; set; }

	public required List<List<int>> DialogMessages { get; set; }

	public required List<List<int>> DialogReplies { get; set; }

	public required List<uint> Actions { get; set; }

	public required int Gender { get; set; }

	public required string Look { get; set; }

	public required List<AnimFunNpcData> AnimFunList { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		NameId = d2OClass.ReadFieldAsI18N(reader);
		Name = d2OClass.ReadFieldAsI18NString(NameId);
		DialogMessages = d2OClass.ReadFieldAsListOfList(reader, static (c, r) => c.ReadFieldAsInt(r));
		DialogReplies = d2OClass.ReadFieldAsListOfList(reader, static (c, r) => c.ReadFieldAsInt(r));
		Actions = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		Gender = d2OClass.ReadFieldAsInt(reader);
		Look = d2OClass.ReadFieldAsString(reader);
		AnimFunList = d2OClass.ReadFieldAsList<AnimFunNpcData>(reader, static (c, r) => c.ReadFieldAsObject<AnimFunNpcData>(r));
	}
}
