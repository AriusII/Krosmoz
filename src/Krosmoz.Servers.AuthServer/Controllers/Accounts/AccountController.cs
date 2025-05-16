// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Servers.AuthServer.Database.Models.Accounts;
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
    /// Retrieves an account by its username.
    /// </summary>
    /// <param name="username">The username of the account to retrieve.</param>
    /// <returns>
    /// An <see cref="IActionResult"/> containing the account record if found,
    /// or an appropriate error response if not found or invalid input is provided.
    /// </returns>
    [HttpGet("search/username/{username}")]
    [ActionName("GetAccountByUsername")]
    [ProducesResponseType(typeof(AccountRecord), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetAccountByUsernameAsync(string username)
    {
        if (string.IsNullOrEmpty(username))
            return BadRequest("Username cannot be null or empty.");

        var account = await _accountRepository.GetAccountByUsernameAsync(username, HttpContext.RequestAborted);

        if (account is null)
            return NotFound($"Account with username {username} not found.");

        return Ok(account);
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
}
