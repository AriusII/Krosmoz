// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Core.Network.Metadata;

/// <summary>
/// Represents metadata for a message, including its state and optional content.
/// </summary>
public readonly struct DofusMessageMetadata
{
    /// <summary>
    /// Gets the associated Dofus message, if any.
    /// </summary>
    public DofusMessage? Message { get; }

    /// <summary>
    /// Gets a value indicating whether the message is canceled.
    /// </summary>
    public bool IsCanceled { get; }

    /// <summary>
    /// Gets a value indicating whether the message is completed.
    /// </summary>
    public bool IsCompleted { get; }

    /// <summary>
    /// Initializes a new instance of the <see cref="DofusMessageMetadata"/> struct
    /// with the specified cancellation and completion states.
    /// </summary>
    /// <param name="isCanceled">Indicates whether the message is canceled.</param>
    /// <param name="isCompleted">Indicates whether the message is completed.</param>
    public DofusMessageMetadata(bool isCanceled, bool isCompleted)
    {
        IsCanceled = isCanceled;
        IsCompleted = isCompleted;
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="DofusMessageMetadata"/> struct
    /// with the specified message, cancellation state, and completion state.
    /// </summary>
    /// <param name="message">The associated Dofus message.</param>
    /// <param name="isCanceled">Indicates whether the message is canceled.</param>
    /// <param name="isCompleted">Indicates whether the message is completed.</param>
    public DofusMessageMetadata(DofusMessage message, bool isCanceled, bool isCompleted)
    {
        IsCanceled = isCanceled;
        IsCompleted = isCompleted;
        Message = message;
    }
}
