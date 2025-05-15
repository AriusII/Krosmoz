// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Protocol.Datacenter.Sounds;

public sealed class SoundBones : IDatacenterObject
{
	public static string ModuleName =>
		"SoundBones";

	public required int Id { get; set; }

	public required List<string> Keys { get; set; }

	public required List<List<SoundAnimation>> Values { get; set; }

	public void Deserialize(D2OClass d2OClass, BigEndianReader reader)
	{
		Id = d2OClass.ReadFieldAsInt(reader);
		Keys = d2OClass.ReadFieldAsList(reader, static (c, r) => c.ReadFieldAsString(r));
		Values = d2OClass.ReadFieldAsListOfList<SoundAnimation>(reader, static (c, r) => c.ReadFieldAsObject<SoundAnimation>(r));
	}
}
