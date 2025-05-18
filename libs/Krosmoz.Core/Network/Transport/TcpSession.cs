// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Diagnostics.CodeAnalysis;
using System.IO.Pipelines;
using System.Net;
using System.Net.Sockets;
using Krosmoz.Core.Network.Dispatcher;
using Krosmoz.Core.Network.Factory;
using Krosmoz.Core.Network.Framing;
using Krosmoz.Core.Network.Metadata;
using Microsoft.Extensions.Logging;

namespace Krosmoz.Core.Network.Transport;

/// <summary>
/// Represents an abstract TCP session for handling network communication.
/// </summary>
public abstract class TcpSession : IAsyncDisposable
{
    private readonly CancellationTokenSource _cts;
    private readonly Socket _socket;
    private readonly NetworkStream _stream;
    private readonly MessageReader _reader;
    private readonly MessageWriter _writer;
    private readonly IMessageDispatcher _messageDispatcher;
    private readonly IMessageFactory _messageFactory;
    private readonly ILogger<TcpSession> _logger;

    private bool _disposed;

    /// <summary>
    /// Gets the next sequence number.
    /// </summary>
    public int SequenceNumber
    {
        get
        {
            Interlocked.Increment(ref field);
            return field;
        }
    }

    /// <summary>
    /// Gets a value indicating whether the session is connected.
    /// </summary>
    public bool IsConnected =>
        !_cts.IsCancellationRequested && _socket.Connected && !_disposed;

    /// <summary>
    /// Gets the unique session ID.
    /// </summary>
    [field: AllowNull, MaybeNull]
    public string SessionId =>
        field ??= Guid.CreateVersion7(DateTimeOffset.UtcNow).ToString("N");

    /// <summary>
    /// Gets a cancellation token that is triggered when the connection is closed.
    /// </summary>
    public CancellationToken ConnectionClosed =>
        _cts.Token;

    /// <summary>
    /// Gets the remote endpoint of the session.
    /// </summary>
    public IPEndPoint? EndPoint =>
        _socket.RemoteEndPoint as IPEndPoint;

    /// <summary>
    /// Initializes a new instance of the <see cref="TcpSession"/> class.
    /// </summary>
    /// <param name="socket">The underlying <see cref="Socket"/> for the session.</param>
    /// <param name="messageDecoder">The <see cref="DofusMessageDecoder"/> for decoding messages.</param>
    /// <param name="messageEncoder">The <see cref="DofusMessageEncoder"/> for encoding messages.</param>
    /// <param name="messageDispatcher">The <see cref="IMessageDispatcher"/> for dispatching messages.</param>
    /// <param name="messageFactory">The <see cref="IMessageFactory"/> for creating messages.</param>
    /// <param name="logger">The <see cref="ILogger"/> for logging session events.</param>
    protected TcpSession(
        Socket socket,
        DofusMessageDecoder messageDecoder,
        DofusMessageEncoder messageEncoder,
        IMessageDispatcher messageDispatcher,
        IMessageFactory messageFactory,
        ILogger<TcpSession> logger)
    {
        _messageDispatcher = messageDispatcher;
        _messageFactory = messageFactory;
        _logger = logger;
        _socket = socket;
        _cts = new CancellationTokenSource();
        _stream = new NetworkStream(socket, true);
        _reader = new MessageReader(PipeReader.Create(_stream), messageDecoder);
        _writer = new MessageWriter(PipeWriter.Create(_stream), messageEncoder);
    }

    /// <summary>
    /// Listens for incoming messages and processes them asynchronously.
    /// </summary>
    internal async Task ListenAsync()
    {
        try
        {
            while (IsConnected)
            {
                try
                {
                    var result = await _reader.ReadAsync(_cts.Token).ConfigureAwait(false);

                    if (result.IsCanceled)
                        break;

                    var message = result.Message;

                    if (message is null)
                        break;

                    _logger.LogDebug("Session {SessionName} received message {Message}", this, _messageFactory.CreateMessageName(message.ProtocolId));

                    await _messageDispatcher.DispatchMessageAsync(this, message).ConfigureAwait(false);
                }
                finally
                {
                    _reader.Advance();
                }
            }
        }
        catch (OperationCanceledException)
        {
            // ignore
        }
        catch (ObjectDisposedException)
        {
            // ignore
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Session {SessionName} error: {Message}", this, e.Message);
        }
    }

    /// <summary>
    /// Sends a buffer of bytes asynchronously if the session is connected.
    /// </summary>
    /// <param name="buffer">The buffer of bytes to send.</param>
    /// <returns>
    /// A <see cref="ValueTask"/> representing the asynchronous operation.
    /// If the session is not connected, the task is completed immediately.
    /// </returns>
    public ValueTask SendAsync(ReadOnlyMemory<byte> buffer)
    {
        return IsConnected
            ? _writer.WriteAsync(buffer, _cts.Token)
            : ValueTask.CompletedTask;
    }

    /// <summary>
    /// Sends a message asynchronously.
    /// </summary>
    /// <typeparam name="TMessage">The type of the message to send, which must be a subclass of <see cref="DofusMessage"/>.</typeparam>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public ValueTask SendAsync<TMessage>()
        where TMessage : DofusMessage, new()
    {
        return SendAsync(new TMessage());
    }

    /// <summary>
    /// Sends a message asynchronously.
    /// </summary>
    /// <param name="message">The message to send.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public ValueTask SendAsync(DofusMessage message)
    {
        if (IsConnected)
        {
            _logger.LogDebug("Session {SessionName} sent message {Message}", this, _messageFactory.CreateMessageName(message.ProtocolId));
            return _writer.WriteAsync(message, _cts.Token);
        }

        return ValueTask.CompletedTask;
    }

    /// <summary>
    /// Sends multiple messages asynchronously.
    /// </summary>
    /// <param name="messages">An array of messages to send. Each message must be a subclass of <see cref="DofusMessage"/>.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public ValueTask SendAsync(params DofusMessage[] messages)
    {
        if (IsConnected)
        {
            foreach (var message in messages)
                _logger.LogDebug("Session {SessionName} sent message {Message}", this, _messageFactory.CreateMessageName(message.ProtocolId));

            return _writer.WriteAsync(messages, _cts.Token);
        }

        return ValueTask.CompletedTask;
    }

    /// <summary>
    /// Disconnects the session asynchronously.
    /// </summary>
    public async Task DisconnectAsync()
    {
        if (_cts.IsCancellationRequested)
            return;

        await _cts.CancelAsync().ConfigureAwait(false);
    }

    /// <summary>
    /// Disconnects the session asynchronously after a specified delay.
    /// </summary>
    /// <param name="delay">The delay before disconnecting.</param>
    public async Task DisconnectAsync(TimeSpan delay)
    {
        if (_cts.IsCancellationRequested)
            return;

        await Task.Delay(delay, _cts.Token).ConfigureAwait(false);

        await _cts.CancelAsync().ConfigureAwait(false);
    }

    /// <summary>
    /// Disposes the session asynchronously.
    /// </summary>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async ValueTask DisposeAsync()
    {
        if (_disposed)
            return;

        _disposed = true;

        if (!_cts.IsCancellationRequested)
            await _cts.CancelAsync().ConfigureAwait(false);

        await _reader.DisposeAsync().ConfigureAwait(false);
        await _writer.DisposeAsync().ConfigureAwait(false);
        await _stream.DisposeAsync().ConfigureAwait(false);

        _cts.Dispose();

        GC.SuppressFinalize(this);
    }

    /// <summary>
    /// Returns a string representation of the session.
    /// </summary>
    /// <returns>
    /// A string containing the remote endpoint if the session is connected;
    /// otherwise, the session ID.
    /// </returns>
    public override string ToString()
    {
        return IsConnected ? $"{EndPoint}" : SessionId;
    }
}
