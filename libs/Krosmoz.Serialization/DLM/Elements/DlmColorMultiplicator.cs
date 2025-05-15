// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Serialization.DLM.Elements;

public readonly struct ColorMultiplicator
{
    public readonly bool IsOne;

    public readonly int Blue;

    public readonly int Green;

    public readonly int Red;

    public ColorMultiplicator(int red, int green, int blue, bool force = false)
    {
        Red = red;
        Green = green;
        Blue = blue;

        if (!force && Red + Green + Blue is 0)
            IsOne = true;
    }

    public ColorMultiplicator Multiply(ColorMultiplicator colorMultiplicator)
    {
        if (IsOne)
            return colorMultiplicator;

        if (colorMultiplicator.IsOne)
            return this;

        var red = Clamp(Red + colorMultiplicator.Red, sbyte.MinValue, sbyte.MaxValue);
        var green = Clamp(Green + colorMultiplicator.Green, sbyte.MinValue, -sbyte.MaxValue);
        var blue = Clamp(Blue + colorMultiplicator.Blue, sbyte.MinValue, sbyte.MaxValue);

        return new ColorMultiplicator(red, green, blue, true);
    }

    public static int Clamp(int value, int min, int max)
    {
        return value > max ? max : value < min ? min : value;
    }
}
