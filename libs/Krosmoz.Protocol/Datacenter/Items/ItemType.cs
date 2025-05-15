// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Items;

public sealed class ItemType : IDatacenterObject
{
	public static string ModuleName =>
		"ItemTypes";

	public required int Id { get; set; }

	public required int NameId { get; set; }

	public required string Name { get; set; }

	public required int SuperTypeId { get; set; }

	public required bool Plural { get; set; }

	public required int Gender { get; set; }

	public required string RawZone { get; set; }

	public required bool NeedUseConfirm { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		NameId = d2OClass.ReadFieldAsI18N(reader);
		Name = d2OClass.ReadFieldAsI18NString(NameId);
		SuperTypeId = d2OClass.ReadFieldAsInt(reader);
		Plural = d2OClass.ReadFieldAsBoolean(reader);
		Gender = d2OClass.ReadFieldAsInt(reader);
		RawZone = d2OClass.ReadFieldAsString(reader);
		NeedUseConfirm = d2OClass.ReadFieldAsBoolean(reader);
	}
}
