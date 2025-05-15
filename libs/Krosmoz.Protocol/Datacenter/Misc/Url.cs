// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Misc;

public sealed class Url : IDatacenterObject
{
	public static string ModuleName =>
		"Url";

	public required int Id { get; set; }

	public required int BrowserId { get; set; }

	public required string Url_ { get; set; }

	public required string Param { get; set; }

	public required string Method { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		BrowserId = d2OClass.ReadFieldAsInt(reader);
		Url_ = d2OClass.ReadFieldAsString(reader);
		Param = d2OClass.ReadFieldAsString(reader);
		Method = d2OClass.ReadFieldAsString(reader);
	}
}
