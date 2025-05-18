// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Net.Http.Json;
using Krosmoz.Servers.GameServer.Models.Accounts;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace Krosmoz.Servers.GameServer.Services.Ipc;

/// <summary>
/// Provides an implementation of the <see cref="IIpcService"/> interface for handling
/// inter-process communication (IPC) in the game server.
/// </summary>
public sealed class IpcService : IIpcService, IDisposable
{
    private readonly HttpClient _http;
    private readonly ILogger<IpcService> _logger;

    public IpcService(IConfiguration configuration, ILogger<IpcService> logger)
    {
        _http = new HttpClient { BaseAddress = new Uri(configuration["IpcHost"]!) };
        _logger = logger;
    }

    /// <summary>
    /// Retrieves account information asynchronously based on the provided ticket.
    /// </summary>
    /// <param name="ticket">The authentication ticket used to identify the account.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result contains the
    /// <see cref="Account"/> if the account is found, or null if it is not.
    /// </returns>
    public async Task<Account?> GetAccountAsync(string ticket, CancellationToken cancellationToken)
    {
        try
        {
            return await _http.GetFromJsonAsync<Account>($"api/account/search/ticket/{ticket}", cancellationToken);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error while getting account from Ipc");
        }

        return null;
    }

    /// <summary>
    /// Creates a new character asynchronously.
    /// </summary>
    /// <param name="character">The character information to be created.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result is a boolean indicating
    /// whether the character was successfully created.
    /// </returns>
    public async Task<bool> CreateCharacterAsync(AccountCharacter character, CancellationToken cancellationToken)
    {
        try
        {
            using var response = await _http.PostAsync($"api/account/character/create/{character.ServerId}/{character.AccountId}/{character.CharacterId}", null, cancellationToken);

            return response.IsSuccessStatusCode;
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error while creating character from Ipc");
        }

        return false;
    }

    public void Dispose()
    {
        _http.Dispose();
    }
}
