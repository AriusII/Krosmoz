// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Monsters;

public sealed class Monster : IDatacenterObject
{
	public static string ModuleName =>
		"Monsters";

	public required int Id { get; set; }

	public required int NameId { get; set; }

	public required string Name { get; set; }

	public required int GfxId { get; set; }

	public required int Race { get; set; }

	public required List<MonsterGrade> Grades { get; set; }

	public required string Look { get; set; }

	public required bool UseSummonSlot { get; set; }

	public required bool UseBombSlot { get; set; }

	public required bool CanPlay { get; set; }

	public required List<AnimFunMonsterData> AnimFunList { get; set; }

	public required bool CanTackle { get; set; }

	public required bool IsBoss { get; set; }

	public required List<MonsterDrop> Drops { get; set; }

	public required List<uint> Subareas { get; set; }

	public required List<uint> Spells { get; set; }

	public required int FavoriteSubareaId { get; set; }

	public required bool IsMiniBoss { get; set; }

	public required bool IsQuestMonster { get; set; }

	public required int CorrespondingMiniBossId { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		NameId = d2OClass.ReadFieldAsI18N(reader);
		Name = d2OClass.ReadFieldAsI18NString(NameId);
		GfxId = d2OClass.ReadFieldAsInt(reader);
		Race = d2OClass.ReadFieldAsInt(reader);
		Grades = d2OClass.ReadFieldAsList<MonsterGrade>(reader, static (c, r) => c.ReadFieldAsObject<MonsterGrade>(r));
		Look = d2OClass.ReadFieldAsString(reader);
		UseSummonSlot = d2OClass.ReadFieldAsBoolean(reader);
		UseBombSlot = d2OClass.ReadFieldAsBoolean(reader);
		CanPlay = d2OClass.ReadFieldAsBoolean(reader);
		AnimFunList = d2OClass.ReadFieldAsList<AnimFunMonsterData>(reader, static (c, r) => c.ReadFieldAsObject<AnimFunMonsterData>(r));
		CanTackle = d2OClass.ReadFieldAsBoolean(reader);
		IsBoss = d2OClass.ReadFieldAsBoolean(reader);
		Drops = d2OClass.ReadFieldAsList<MonsterDrop>(reader, static (c, r) => c.ReadFieldAsObject<MonsterDrop>(r));
		Subareas = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		Spells = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsUInt(r));
		FavoriteSubareaId = d2OClass.ReadFieldAsInt(reader);
		IsMiniBoss = d2OClass.ReadFieldAsBoolean(reader);
		IsQuestMonster = d2OClass.ReadFieldAsBoolean(reader);
		CorrespondingMiniBossId = d2OClass.ReadFieldAsInt(reader);
	}
}
