// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Notifications;

public sealed class Notification : IDatacenterObject
{
	public static string ModuleName =>
		"Notifications";

	public required int Id { get; set; }

	public required int TitleId { get; set; }

	public required string Title { get; set; }

	public required int MessageId { get; set; }

	public required string Message { get; set; }

	public required int IconId { get; set; }

	public required int TypeId { get; set; }

	public required string Trigger { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		TitleId = d2OClass.ReadFieldAsI18N(reader);
		Title = d2OClass.ReadFieldAsI18NString(TitleId);
		MessageId = d2OClass.ReadFieldAsI18N(reader);
		Message = d2OClass.ReadFieldAsI18NString(MessageId);
		IconId = d2OClass.ReadFieldAsInt(reader);
		TypeId = d2OClass.ReadFieldAsInt(reader);
		Trigger = d2OClass.ReadFieldAsString(reader);
	}
}
