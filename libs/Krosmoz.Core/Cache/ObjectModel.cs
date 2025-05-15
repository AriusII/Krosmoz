// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace Krosmoz.Core.Cache;

/// <summary>
/// Represents an abstract base class that provides support for property change notifications.
/// </summary>
public abstract class ObjectModel : INotifyPropertyChanging, INotifyPropertyChanged
{
    /// <summary>
    /// Occurs when a property value is changing.
    /// </summary>
    public event PropertyChangingEventHandler? PropertyChanging;

    /// <summary>
    /// Occurs when a property value has changed.
    /// </summary>
    public event PropertyChangedEventHandler? PropertyChanged;

    /// <summary>
    /// Raises the <see cref="PropertyChanging"/> event for the specified property.
    /// </summary>
    /// <param name="propertyName">The name of the property that is changing. This is optional and will be automatically provided by the compiler if not specified.</param>
    protected void OnPropertyChanging([CallerMemberName] string? propertyName = null)
    {
        PropertyChanging?.Invoke(this, new PropertyChangingEventArgs(propertyName));
    }

    /// <summary>
    /// Raises the <see cref="PropertyChanged"/> event for the specified property.
    /// </summary>
    /// <param name="propertyName">The name of the property that has changed. This is optional and will be automatically provided by the compiler if not specified.</param>
    protected void OnPropertyChanged([CallerMemberName] string? propertyName = null)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }

    /// <summary>
    /// Sets the value of a property and raises the appropriate property change notifications.
    /// </summary>
    /// <typeparam name="T">The type of the property.</typeparam>
    /// <param name="field">A reference to the field storing the property's value.</param>
    /// <param name="value">The new value to set for the property.</param>
    /// <param name="propertyName">The name of the property being set. This is optional and will be automatically provided by the compiler if not specified.</param>
    protected void SetPropertyChanged<T>(ref T field, T value, [CallerMemberName] string? propertyName = null)
    {
        if (EqualityComparer<T>.Default.Equals(field, value))
            return;

        OnPropertyChanging(propertyName);
        field = value;
        OnPropertyChanged(propertyName);
    }
}
