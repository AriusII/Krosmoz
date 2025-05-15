// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Core.Cache;

namespace Krosmoz.Serialization.DLM.Elements;

public sealed class ColorMultiplicator : ObjectModel
{
    private int _blue;
    private int _green;
    private int _red;

    public bool IsOne
    {
        get;
        private set => SetPropertyChanged(ref field, value);
    }

    public int Blue
    {
        get => _blue;
        set => SetPropertyChanged(ref _blue, value);
    }

    public int Green
    {
        get => _green;
        set => SetPropertyChanged(ref _green, value);
    }

    public int Red
    {
        get => _red;
        set => SetPropertyChanged(ref _red, value);
    }

    public ColorMultiplicator(int red, int green, int blue, bool force = false)
    {
        _red = red;
        _green = green;
        _blue = blue;

        if (!force && _red + _green + _blue is 0)
            IsOne = true;
    }

    public ColorMultiplicator Multiply(ColorMultiplicator colorMultiplicator)
    {
        ColorMultiplicator result;

        if (IsOne)
            return colorMultiplicator;

        if (colorMultiplicator.IsOne)
            return this;

        var red = Clamp(_red + colorMultiplicator._red, sbyte.MinValue, sbyte.MaxValue);
        var green = Clamp(_green + colorMultiplicator._green, sbyte.MinValue, -sbyte.MaxValue);
        var blue = Clamp(_blue + colorMultiplicator._blue, sbyte.MinValue, sbyte.MaxValue);

        return new ColorMultiplicator(red, green, blue) { IsOne = false };
    }

    public static int Clamp(int value, int min, int max)
    {
        return value > max ? max : value < min ? min : value;
    }
}
