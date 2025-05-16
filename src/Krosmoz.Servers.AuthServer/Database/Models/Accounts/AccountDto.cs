// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums;
using Krosmoz.Serialization.I18N;

namespace Krosmoz.Servers.AuthServer.Database.Models.Accounts;

public sealed class AccountDto
{
    public required string Username { get; set; }

    public required string Password { get; set; }

    public required GameHierarchies Hierarchy { get; set; }

    public required I18NLanguages Language { get; set; }

    public required string SecretQuestion { get; set; }

    public required string SecretAnswer { get; set; }
}
