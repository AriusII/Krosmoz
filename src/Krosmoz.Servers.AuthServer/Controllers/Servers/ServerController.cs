// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Protocol.Enums;
using Krosmoz.Servers.AuthServer.Services.Servers;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Krosmoz.Servers.AuthServer.Controllers.Servers;

/// <summary>
/// Controller for managing server-related operations.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public sealed class ServerController : ControllerBase
{
    private readonly IServerService _serverService;

    /// <summary>
    /// Initializes a new instance of the <see cref="ServerController"/> class.
    /// </summary>
    /// <param name="serverService">The service for managing server operations.</param>
    public ServerController(IServerService serverService)
    {
        _serverService = serverService;
    }

    /// <summary>
    /// Updates the status of a server.
    /// </summary>
    /// <param name="serverId">The ID of the server to update.</param>
    /// <param name="status">The new status to set for the server.</param>
    /// <returns>
    /// An <see cref="IActionResult"/> indicating the result of the operation.
    /// Returns <see cref="StatusCodes.Status200OK"/> if the update is successful,
    /// or <see cref="StatusCodes.Status404NotFound"/> if the server is not found.
    /// </returns>
    [HttpPut("update/status/{serverId:int}/{status}")]
    [ActionName("UpdateServerStatus")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateServerStatusAsync(int serverId, ServerStatuses status)
    {
        if (await _serverService.UpdateServerStatusAsync(serverId, status))
            return Ok();

        return NotFound($"Server with id {serverId} not found.");
    }
}
