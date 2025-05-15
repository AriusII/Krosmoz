// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Cache;
using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.D2P;

public sealed class D2PProperty : ObjectModel
{
    public string Key
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public string Value
    {
        get;
        set => SetPropertyChanged(ref field, value);
    }

    public D2PProperty()
    {
        Key = string.Empty;
        Value = string.Empty;
    }

    public void Deserialize(BigEndianReader reader)
    {
        Key = reader.ReadUtfPrefixedLength16();
        Value = reader.ReadUtfPrefixedLength16();
    }
}
