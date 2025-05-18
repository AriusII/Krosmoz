// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.AuthServer.Database.Models.Accounts;
using Krosmoz.Servers.AuthServer.Database.Models.Servers;
using Krosmoz.Servers.AuthServer.Database.Repositories.Accounts;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Krosmoz.Servers.AuthServer.Controllers.Accounts;

/// <summary>
/// Controller for managing account-related operations.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public sealed class AccountController : ControllerBase
{
    private readonly IAccountRepository _accountRepository;

    /// <summary>
    /// Initializes a new instance of the <see cref="AccountController"/> class.
    /// </summary>
    /// <param name="accountRepository">The repository for accessing account data.</param>
    public AccountController(IAccountRepository accountRepository)
    {
        _accountRepository = accountRepository;
    }

    /// <summary>
    /// Retrieves an account by its ticket.
    /// </summary>
    /// <param name="ticket">The ticket associated with the account to retrieve.</param>
    /// <returns>
    /// An <see cref="IActionResult"/> containing the account record if found,
    /// or an appropriate error response if not found or invalid input is provided.
    /// </returns>
    [HttpGet("search/ticket/{ticket}")]
    [ActionName("GetAccountByTicket")]
    [ProducesResponseType(typeof(AccountRecord), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetAccountByTicketAsync(string ticket)
    {
        if (string.IsNullOrEmpty(ticket))
            return BadRequest("Ticket cannot be null or empty.");

        var account = await _accountRepository.GetAccountByTicketAsync(ticket, HttpContext.RequestAborted);

        if (account is null)
            return NotFound($"Account with ticket {ticket} not found.");

        return Ok(account);
    }

    /// <summary>
    /// Authenticates an account using a username and password.
    /// </summary>
    /// <param name="username">The username of the account to authenticate.</param>
    /// <param name="password">The password of the account to authenticate.</param>
    /// <returns>
    /// An <see cref="IActionResult"/> containing the account record if authentication is successful,
    /// or an appropriate error response if authentication fails or invalid input is provided.
    /// </returns>
    [HttpGet("authenticate/{username}/{password}")]
    [ActionName("Authenticate")]
    [ProducesResponseType(typeof(AccountRecord), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> AuthenticateAsync(string username, string password)
    {
        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            return BadRequest("Username and password cannot be null or empty.");

        var account = await _accountRepository.GetAccountByUsernameAsync(username, HttpContext.RequestAborted);

        if (account is null)
            return NotFound($"Account with username {username} not found.");

        if (account.Password != password)
            return Unauthorized("Invalid password.");

        return Ok(account);
    }

    /// <summary>
    /// Creates a new character for a specified account on a given server.
    /// </summary>
    /// <param name="serverId">The ID of the server where the character will be created.</param>
    /// <param name="accountId">The ID of the account to which the character will belong.</param>
    /// <param name="characterId">The ID of the character to be created.</param>
    /// <returns>
    /// An <see cref="IActionResult"/> indicating the result of the operation:
    /// - 200 OK if the character is successfully created.
    /// - 400 Bad Request if any of the input parameters are invalid.
    /// - 404 Not Found if the account with the specified ID does not exist.
    /// </returns>
    [HttpPost("character/create/{serverId}/{accountId:int}/{characterId:long}")]
    [ActionName("CreateCharacter")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> CreateCharacterAsync(short serverId, int accountId, long characterId)
    {
        if (serverId <= 0 || accountId <= 0 || characterId <= 0)
            return BadRequest("Invalid server ID, account ID, or character ID.");

        var account = await _accountRepository.GetAccountByIdAsync(accountId, HttpContext.RequestAborted);

        if (account is null)
            return NotFound($"Account with ID {accountId} not found.");

        account.Characters.Add(new ServerCharacterRecord
        {
            AccountId = accountId,
            ServerId = serverId,
            CharacterId = characterId
        });

        await _accountRepository.UpdateAccountAsync(account, HttpContext.RequestAborted);

        return Ok();
    }

    /// <summary>
    /// Deletes a character associated with a specific account on a given server.
    /// </summary>
    /// <param name="serverId">The ID of the server where the character is located.</param>
    /// <param name="accountId">The ID of the account to which the character belongs.</param>
    /// <param name="characterId">The ID of the character to be deleted.</param>
    /// <returns>
    /// An <see cref="IActionResult"/> indicating the result of the operation:
    /// - 200 OK if the character is successfully deleted.
    /// - 400 Bad Request if any of the input parameters are invalid.
    /// - 404 Not Found if the account or character with the specified IDs does not exist.
    /// </returns>
    [HttpPost("character/delete/{serverId}/{accountId:int}/{characterId:long}")]
    [ActionName("DeleteCharacter")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> DeleteCharacterAsync(short serverId, int accountId, long characterId)
    {
        if (serverId <= 0 || accountId <= 0 || characterId <= 0)
            return BadRequest("Invalid server ID, account ID, or character ID.");

        var account = await _accountRepository.GetAccountByIdAsync(accountId, HttpContext.RequestAborted);

        if (account is null)
            return NotFound($"Account with ID {accountId} not found.");

        var characterToRemove = account.Characters.FirstOrDefault(c => c.ServerId == serverId && c.CharacterId == characterId);

        if (characterToRemove is null)
            return NotFound($"Character with ID {characterId} not found on server {serverId} for account {accountId}.");

        await _accountRepository.RemoveCharacterAsync(account, characterToRemove, HttpContext.RequestAborted);

        return Ok();
    }
}
