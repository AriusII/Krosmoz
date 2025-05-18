// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Net;
using System.Text.Json.Serialization;
using Krosmoz.Protocol.Enums;
using Krosmoz.Serialization.I18N;
using Krosmoz.Servers.AuthServer.Database.Models.Servers;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace Krosmoz.Servers.AuthServer.Database.Models.Accounts;

public sealed class AccountRecord
{
    public int Id { get; init; }

    public required string Username { get; set; }

    public required string Password { get; set; }

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public required GameHierarchies Hierarchy { get; set; }

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public required I18NLanguages Language { get; set; }

    public required string SecretQuestion { get; set; }

    public required string SecretAnswer { get; set; }

    public required DateTime CreatedAt { get; init; }

    public required DateTime UpdatedAt { get; set; }

    public required List<ServerCharacterRecord> Characters { get; init; }

    public DateTime? SubscriptionExpireAt { get; set; }

    public string? Nickname { get; set; }

    public string? MacAddress { get; set; }

    [JsonIgnore]
    public IPAddress? IpAddress { get; set; }

    public string? Ticket { get; set; }

    [JsonIgnore]
    public bool HasRights =>
        Hierarchy >= GameHierarchies.Moderator;
}
