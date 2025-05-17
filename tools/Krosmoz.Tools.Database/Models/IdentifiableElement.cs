// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Serialization.DLM;
using Krosmoz.Serialization.DLM.Elements;

namespace Krosmoz.Tools.Database.Models;

public sealed class IdentifiableElement
{
    public required DlmGraphicalElement Element { get; init; }

    public required DlmMap Map { get; init; }

    public int GfxId { get; set; }

    public bool Animated { get; set; }
}
