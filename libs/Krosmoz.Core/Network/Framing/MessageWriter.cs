// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.IO.Pipelines;
using Krosmoz.Core.Network.Metadata;

namespace Krosmoz.Core.Network.Framing;

/// <summary>
/// Represents a writer for encoding and writing Dofus messages asynchronously to a pipeline.
/// </summary>
internal sealed class MessageWriter : IAsyncDisposable
{
    private readonly PipeWriter _writer;
    private readonly DofusMessageEncoder _encoder;
    private readonly SemaphoreSlim _semaphore;

    private bool _disposed;

    /// <summary>
    /// Initializes a new instance of the <see cref="MessageWriter"/> class.
    /// </summary>
    /// <param name="writer">The <see cref="PipeWriter"/> to write data to.</param>
    /// <param name="encoder">The <see cref="DofusMessageEncoder"/> to encode messages.</param>
    public MessageWriter(PipeWriter writer, DofusMessageEncoder encoder)
    {
        _writer = writer;
        _encoder = encoder;
        _semaphore = new SemaphoreSlim(1);
    }

    /// <summary>
    /// Writes a buffer of bytes asynchronously to the pipeline.
    /// </summary>
    /// <param name="buffer">The buffer of bytes to write.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task representing the asynchronous write operation.</returns>
    public async ValueTask WriteAsync(ReadOnlyMemory<byte> buffer, CancellationToken cancellationToken)
    {
        await _semaphore.WaitAsync(cancellationToken).ConfigureAwait(false);

        try
        {
            if (_disposed)
                return;

            var result = await _writer.WriteAsync(buffer, cancellationToken).ConfigureAwait(false);

            if (result.IsCanceled)
                throw new OperationCanceledException("The write operation was canceled.");

            if (result.IsCompleted)
                _disposed = true;
        }
        finally
        {
            _semaphore.Release();
        }
    }

    /// <summary>
    /// Writes a single Dofus message asynchronously to the pipeline.
    /// </summary>
    /// <param name="message">The <see cref="DofusMessage"/> to write.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task representing the asynchronous write operation.</returns>
    public async ValueTask WriteAsync(DofusMessage message, CancellationToken cancellationToken)
    {
        await _semaphore.WaitAsync(cancellationToken).ConfigureAwait(false);

        try
        {
            if (_disposed)
                return;

            _encoder.EncodeMessage(_writer, message);

            var result = await _writer.FlushAsync(cancellationToken).ConfigureAwait(false);

            if (result.IsCanceled)
                throw new OperationCanceledException("The write operation was canceled.");

            if (result.IsCompleted)
                _disposed = true;
        }
        finally
        {
            _semaphore.Release();
        }
    }

    /// <summary>
    /// Writes multiple Dofus messages asynchronously to the pipeline.
    /// </summary>
    /// <param name="messages">The collection of <see cref="DofusMessage"/> objects to write.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task representing the asynchronous write operation.</returns>
    public async ValueTask WriteAsync(IEnumerable<DofusMessage> messages, CancellationToken cancellationToken)
    {
        await _semaphore.WaitAsync(cancellationToken).ConfigureAwait(false);

        try
        {
            if (_disposed)
                return;

            foreach (var message in messages)
                _encoder.EncodeMessage(_writer, message);

            var result = await _writer.FlushAsync(cancellationToken).ConfigureAwait(false);

            if (result.IsCanceled)
                throw new OperationCanceledException("The write operation was canceled.");

            if (result.IsCompleted)
                _disposed = true;
        }
        finally
        {
            _semaphore.Release();
        }
    }

    /// <summary>
    /// Disposes the writer asynchronously, releasing resources.
    /// </summary>
    /// <returns>A task representing the asynchronous dispose operation.</returns>
    public async ValueTask DisposeAsync()
    {
        await _semaphore.WaitAsync().ConfigureAwait(false);

        try
        {
            if (_disposed)
                return;

            _disposed = true;

            await _writer.CompleteAsync().ConfigureAwait(false);
        }
        finally
        {
            _semaphore.Release();
        }
    }
}
