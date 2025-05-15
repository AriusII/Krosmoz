// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.DLM.Elements;

public sealed class DlmSoundElement : DlmBasicElement
{
    public int SoundId
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public short MinDelayBetweenLoops
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public short MaxDelayBetweenLoops
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public short BaseVolume
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int FullVolumeDistance
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public int NullVolumeDistance
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public DlmSoundElement(DlmCell cell, DlmElementTypes type) : base(cell, type)
    {
    }

    public override void Deserialize(BigEndianReader reader)
    {
        SoundId = reader.ReadInt32();
        BaseVolume = reader.ReadInt16();
        FullVolumeDistance = reader.ReadInt32();
        NullVolumeDistance = reader.ReadInt32();
        MinDelayBetweenLoops = reader.ReadInt16();
        MaxDelayBetweenLoops = reader.ReadInt16();
    }
}
