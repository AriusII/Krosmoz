// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Buffers;
using System.IO.Pipelines;
using Krosmoz.Core.Network.Metadata;

namespace Krosmoz.Core.Network.Framing;

/// <summary>
/// Represents a reader for processing Dofus messages asynchronously from a pipeline.
/// </summary>
internal sealed class MessageReader : IAsyncDisposable
{
    private readonly PipeReader _reader;
    private readonly DofusMessageDecoder _decoder;

    private ReadOnlySequence<byte> _buffer;
    private SequencePosition _examined;
    private SequencePosition _consumed;
    private bool _isCanceled;
    private bool _isCompleted;
    private bool _hasMessage;
    private bool _disposed;

    /// <summary>
    /// Initializes a new instance of the <see cref="MessageReader"/> class.
    /// </summary>
    /// <param name="reader">The <see cref="PipeReader"/> to read data from.</param>
    /// <param name="decoder">The <see cref="DofusMessageDecoder"/> to decode messages.</param>
    public MessageReader(PipeReader reader, DofusMessageDecoder decoder)
    {
        _reader = reader;
        _decoder = decoder;
    }

    /// <summary>
    /// Reads a message asynchronously from the pipeline.
    /// </summary>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A <see cref="ValueTask{TResult}"/> representing the asynchronous operation, containing the <see cref="DofusMessageMetadata"/>.</returns>
    public ValueTask<DofusMessageMetadata> ReadAsync(CancellationToken cancellationToken)
    {
        if (_disposed)
            return new ValueTask<DofusMessageMetadata>(new DofusMessageMetadata(true, true));

        if (_hasMessage)
            throw new InvalidOperationException($"{nameof(Advance)} must be called before calling {nameof(ReadAsync)}.");

        if (_consumed.GetObject() is null)
            return DoAsyncRead(cancellationToken);

        if (_decoder.TryDecodeMessage(_buffer, ref _consumed, ref _examined, out var message))
        {
            _hasMessage = true;
            return new ValueTask<DofusMessageMetadata>(new DofusMessageMetadata(message, _isCanceled, false));
        }

        _reader.AdvanceTo(_consumed, _examined);

        _buffer = default;
        _consumed = default;
        _examined = default;

        if (_isCompleted)
        {
            _consumed = default;
            _examined = default;

            if (!_buffer.IsEmpty)
                throw new OutOfMemoryException("The buffer should be empty when the reader is completed.");

            return new ValueTask<DofusMessageMetadata>(new DofusMessageMetadata(_isCanceled, true));
        }

        return DoAsyncRead(cancellationToken);
    }

    /// <summary>
    /// Performs the asynchronous read operation.
    /// </summary>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A <see cref="ValueTask{TResult}"/> containing the <see cref="DofusMessageMetadata"/>.</returns>
    private ValueTask<DofusMessageMetadata> DoAsyncRead(CancellationToken cancellationToken)
    {
        while (!cancellationToken.IsCancellationRequested)
        {
            var readTask = _reader.ReadAsync(cancellationToken);

            ReadResult result;

            if (readTask.IsCompletedSuccessfully)
                result = readTask.Result;
            else
                return ReadAsyncCore(readTask, cancellationToken);

            var (shouldContinue, hasMessage) = TrySetMessage(result, out var readResult);

            if (hasMessage)
                return new ValueTask<DofusMessageMetadata>(readResult);

            if (!shouldContinue)
                break;
        }

        return new ValueTask<DofusMessageMetadata>(new DofusMessageMetadata(_isCanceled, _isCompleted));
    }

    /// <summary>
    /// Handles the asynchronous read operation when awaiting a task.
    /// </summary>
    /// <param name="readTask">The task representing the read operation.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A <see cref="ValueTask{TResult}"/> containing the <see cref="DofusMessageMetadata"/>.</returns>
    private async ValueTask<DofusMessageMetadata> ReadAsyncCore(ValueTask<ReadResult> readTask, CancellationToken cancellationToken)
    {
        while (!cancellationToken.IsCancellationRequested)
        {
            var result = await readTask.ConfigureAwait(false);

            var (shouldContinue, hasMessage) = TrySetMessage(result, out var readResult);

            if (hasMessage)
                return readResult;

            if (!shouldContinue)
                break;

            readTask = _reader.ReadAsync(cancellationToken);
        }

        return new DofusMessageMetadata(_isCanceled, _isCompleted);
    }

    /// <summary>
    /// Attempts to decode a message from the read result and updates the state.
    /// </summary>
    /// <param name="result">The <see cref="ReadResult"/> containing the data.</param>
    /// <param name="metadata">The resulting <see cref="DofusMessageMetadata"/> if a message is decoded.</param>
    /// <returns>A tuple indicating whether to continue reading and whether a message was decoded.</returns>
    private (bool ShouldContinue, bool HasMessage) TrySetMessage(ReadResult result, out DofusMessageMetadata metadata)
    {
        _buffer = result.Buffer;
        _isCanceled = result.IsCanceled;
        _isCompleted = result.IsCompleted;
        _consumed = _buffer.Start;
        _examined = _buffer.End;

        if (_isCanceled)
        {
            metadata = default;
            return (false, false);
        }

        if (_decoder.TryDecodeMessage(_buffer, ref _consumed, ref _examined, out var message))
        {
            _hasMessage = true;
            metadata = new DofusMessageMetadata(message, _isCanceled, false);
            return (false, true);
        }

        _reader.AdvanceTo(_consumed, _examined);

        _buffer = default;
        _consumed = default;
        _examined = default;

        if (_isCompleted)
        {
            _consumed = default;
            _examined = default;

            if (!_buffer.IsEmpty)
                throw new InvalidOperationException("The buffer should be empty when the reader is completed.");

            metadata = default;
            return (false, false);
        }

        metadata = default;
        return (true, false);
    }

    /// <summary>
    /// Advances the reader to the next message.
    /// </summary>
    public void Advance()
    {
        if (_disposed)
            return;

        _isCanceled = false;

        if (!_hasMessage)
            return;

        _buffer = _buffer.Slice(_consumed);
        _hasMessage = false;
    }

    /// <summary>
    /// Disposes the reader asynchronously.
    /// </summary>
    /// <returns>A task representing the asynchronous dispose operation.</returns>
    public async ValueTask DisposeAsync()
    {
        if (_disposed)
            return;

        _disposed = true;

        await _reader.CompleteAsync().ConfigureAwait(false);
    }
}
