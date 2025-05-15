// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.ExternalNotifications;

public sealed class ExternalNotification : IDatacenterObject
{
	public static string ModuleName =>
		"ExternalNotifications";

	public required int Id { get; set; }

	public required int CategoryId { get; set; }

	public required int IconId { get; set; }

	public required int ColorId { get; set; }

	public required int DescriptionId { get; set; }

	public required string Description { get; set; }

	public required bool DefaultEnable { get; set; }

	public required bool DefaultSound { get; set; }

	public required bool DefaultMultiAccount { get; set; }

	public required bool DefaultNotify { get; set; }

	public required string Name { get; set; }

	public required int MessageId { get; set; }

	public required string Message { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		CategoryId = d2OClass.ReadFieldAsInt(reader);
		IconId = d2OClass.ReadFieldAsInt(reader);
		ColorId = d2OClass.ReadFieldAsInt(reader);
		DescriptionId = d2OClass.ReadFieldAsI18N(reader);
		Description = d2OClass.ReadFieldAsI18NString(DescriptionId);
		DefaultEnable = d2OClass.ReadFieldAsBoolean(reader);
		DefaultSound = d2OClass.ReadFieldAsBoolean(reader);
		DefaultMultiAccount = d2OClass.ReadFieldAsBoolean(reader);
		DefaultNotify = d2OClass.ReadFieldAsBoolean(reader);
		Name = d2OClass.ReadFieldAsString(reader);
		MessageId = d2OClass.ReadFieldAsI18N(reader);
		Message = d2OClass.ReadFieldAsI18NString(MessageId);
	}
}
