// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums;
using Krosmoz.Protocol.Enums.Custom;
using Krosmoz.Protocol.Types.Game.Character.Status;
using Krosmoz.Servers.GameServer.Models.Appearances;

namespace Krosmoz.Servers.GameServer.Database.Models.Characters;

public sealed class CharacterRecord
{
    public long Id { get; init; }

    public required string Name { get; set; }

    public required int AccountId { get; set; }

    public required long Experience { get; set; }

    public required byte Level { get; set; }

    public required BreedIds Breed { get; set; }

    public required int Head { get; set; }

    public required bool Sex { get; set; }

    public required PlayerStatus Status { get; set; }

    public required ActorLook Look { get; set; }

    public required long Kamas { get; set; }

    public required List<EmoticonIds> Emotes { get; set; }

    public required List<SpellIds> Spells { get; set; }

    public required DateTime CreatedAt { get; set; }

    public required DateTime UpdatedAt { get; set; }

    public required short DeathCount { get; set; }

    public required byte DeathMaxLevel { get; set; }

    public required HardcoreDeathStates DeathState { get; set; }

    public DateTime? DeletedAt { get; set; }
}
