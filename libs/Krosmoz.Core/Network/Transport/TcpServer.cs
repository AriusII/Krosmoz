// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Collections.Concurrent;
using System.Diagnostics.CodeAnalysis;
using System.Net;
using System.Net.Sockets;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace Krosmoz.Core.Network.Transport;

/// <summary>
/// Represents a generic TCP server that manages multiple sessions of type <typeparamref name="TSession"/>.
/// </summary>
/// <typeparam name="TSession">The type of the session, which must inherit from <see cref="TcpSession"/>.</typeparam>
public abstract class TcpServer<[DynamicallyAccessedMembers(DynamicallyAccessedMemberTypes.PublicConstructors)] TSession> : BackgroundService
    where TSession : TcpSession
{
    private readonly Socket _socket;
    private readonly IServiceProvider _services;
    private readonly ILogger<TcpServer<TSession>> _logger;
    private readonly ConcurrentDictionary<string, TSession> _sessions;
    private readonly TcpServerOptions _options;

    /// <summary>
    /// Gets the local endpoint of the server.
    /// </summary>
    public IPEndPoint? LocalEndPoint =>
        _socket.LocalEndPoint as IPEndPoint;

    /// <summary>
    /// Initializes a new instance of the <see cref="TcpServer{TSession}"/> class.
    /// </summary>
    /// <param name="services">The <see cref="IServiceProvider"/> for resolving dependencies.</param>
    /// <param name="logger">The <see cref="ILogger{TCategoryName}"/> for logging server events.</param>
    /// <param name="options">The <see cref="IOptions{TOptions}"/> containing server configuration.</param>
    protected TcpServer(IServiceProvider services, ILogger<TcpServer<TSession>> logger, IOptions<TcpServerOptions> options)
    {
        _services = services;
        _options = options.Value;
        _logger = logger;
        _socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        _sessions = new ConcurrentDictionary<string, TSession>();
    }

    /// <summary>
    /// Starts the server and begins listening for incoming connections asynchronously.
    /// </summary>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    protected override async Task ExecuteAsync(CancellationToken cancellationToken)
    {
        _socket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, true);

        _socket.Bind(new IPEndPoint(IPAddress.Parse(_options.Host), _options.Port));

        _socket.Listen(_options.MaxConnections);

        _logger.LogInformation("Now listening on: {EndPoint}", string.Concat("tcp://", _socket.LocalEndPoint));

        await OnServerStartedAsync().ConfigureAwait(false);

        while (!cancellationToken.IsCancellationRequested)
        {
            var socket = await _socket.AcceptAsync(cancellationToken).ConfigureAwait(false);

            socket.SetSocketOption(SocketOptionLevel.Tcp, SocketOptionName.NoDelay, true);

            var session = ActivatorUtilities.CreateInstance<TSession>(_services, socket);

            _sessions.TryAdd(session.SessionId, session);

            _ = ListenSessionAsync(session).ConfigureAwait(false);
        }

        await OnServerStoppedAsync().ConfigureAwait(false);
    }

    /// <summary>
    /// Retrieves a session by its unique session ID.
    /// </summary>
    /// <param name="sessionId">The unique ID of the session.</param>
    /// <returns>The <typeparamref name="TSession"/> if found; otherwise, <c>null</c>.</returns>
    public TSession? GetSession(string sessionId)
    {
        return _sessions.GetValueOrDefault(sessionId);
    }

    /// <summary>
    /// Attempts to retrieve a session by its unique session ID.
    /// </summary>
    /// <param name="sessionId">The unique ID of the session.</param>
    /// <param name="session">The retrieved session, if found.</param>
    /// <returns><c>true</c> if the session is found; otherwise, <c>false</c>.</returns>
    public bool TryGetSession(string sessionId, [NotNullWhen(true)] out TSession? session)
    {
        return _sessions.TryGetValue(sessionId, out session);
    }

    /// <summary>
    /// Retrieves a session that matches the specified predicate.
    /// </summary>
    /// <param name="predicate">The predicate to match sessions.</param>
    /// <returns>The first matching <typeparamref name="TSession"/> if found; otherwise, <c>null</c>.</returns>
    public TSession? GetSession(Func<TSession, bool> predicate)
    {
        return _sessions.Values.FirstOrDefault(predicate);
    }

    /// <summary>
    /// Attempts to retrieve a session that matches the specified predicate.
    /// </summary>
    /// <param name="predicate">The predicate to match sessions.</param>
    /// <param name="session">The retrieved session, if found.</param>
    /// <returns><c>true</c> if a matching session is found; otherwise, <c>false</c>.</returns>
    public bool TryGetSession(Func<TSession, bool> predicate, [NotNullWhen(true)] out TSession? session)
    {
        return (session = _sessions.Values.FirstOrDefault(predicate)) is not null;
    }

    /// <summary>
    /// Retrieves all sessions that match the specified predicate.
    /// </summary>
    /// <param name="predicate">The predicate to match sessions.</param>
    /// <returns>An enumerable of matching <typeparamref name="TSession"/> instances.</returns>
    public IEnumerable<TSession> GetSessions(Func<TSession, bool> predicate)
    {
        return _sessions.Values.Where(predicate);
    }

    /// <summary>
    /// Retrieves all active sessions.
    /// </summary>
    /// <returns>An enumerable of all <typeparamref name="TSession"/> instances.</returns>
    public IEnumerable<TSession> GetSessions()
    {
        return _sessions.Values;
    }

    /// <summary>
    /// Releases the resources used by the server.
    /// </summary>
    public override void Dispose()
    {
        base.Dispose();

        try
        {
            _socket.Shutdown(SocketShutdown.Both);
            _socket.Close();
        }
        catch (SocketException)
        {
            // ignore
        }

        _socket.Dispose();

        GC.SuppressFinalize(this);
    }

    /// <summary>
    /// Called when the server has started. Can be overridden to provide custom behavior upon server startup.
    /// </summary>
    /// <returns>A task that represents the asynchronous operation.</returns>
    protected virtual Task OnServerStartedAsync()
    {
        return Task.CompletedTask;
    }

    /// <summary>
    /// Called when the server has stopped. Can be overridden to provide custom behavior upon server shutdown.
    /// </summary>
    /// <returns>A task that represents the asynchronous operation.</returns>
    protected virtual Task OnServerStoppedAsync()
    {
        return Task.CompletedTask;
    }

    /// <summary>
    /// Called when a session is connected. Can be overridden to provide custom behavior upon session connection.
    /// </summary>
    /// <param name="session">The session that has connected.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    protected virtual Task OnSessionConnectedAsync(TSession session)
    {
        return Task.CompletedTask;
    }

    /// <summary>
    /// Called when a session is disconnected. Can be overridden to provide custom behavior upon session disconnection.
    /// </summary>
    /// <param name="session">The session that has disconnected.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    protected virtual Task OnSessionDisconnectedAsync(TSession session)
    {
        return Task.CompletedTask;
    }

    /// <summary>
    /// Listens to a session asynchronously, handling its lifecycle events such as connection, disconnection, and disposal.
    /// </summary>
    /// <param name="session">The session to listen to.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    private async Task ListenSessionAsync(TSession session)
    {
        _logger.LogInformation("Session {SessionName} connected", session);

        await OnSessionConnectedAsync(session).ConfigureAwait(false);
        await session.ListenAsync().ConfigureAwait(false);
        await OnSessionDisconnectedAsync(session).ConfigureAwait(false);
        await session.DisposeAsync().ConfigureAwait(false);

        _logger.LogInformation("Session {SessionName} disconnected", session);

        _sessions.TryRemove(session.SessionId, out _);
    }
}
