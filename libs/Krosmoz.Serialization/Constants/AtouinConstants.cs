// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Serialization.Constants;

public static class AtouinConstants
{
    public const string MapEncryptionKey = "649ae451ca33ec53bbcbcc33becf15f4";
    public const uint MapWidth = 14;
    public const uint MapHeight = 20;
    public const uint MapCellsCount = 560;
    public const uint CellWidth = 86;
    public const uint CellHalfWidth = 43;
    public const uint CellHeight = 43;
    public const double CellHalfHeight = 21.5;
    public const uint AltitudePixelUnit = 10;
    public const int LoadersPoolInitialSize = 30;
    public const int LoadersPoolGrowSize = 5;
    public const int LoadersPoolWarnLimit = 100;
    public const double OverlayModeAlpha = 0.7;
    public const int MaxZoom = 4;
    public const int MaxGroundCacheMemory = 5;
    public const int GroundMapVersion = 1;
    public static readonly double MinDiskSpaceAvailable = Math.Pow(2, 20) * 512;
    public const int PathfinderMinX = 0;
    public const int PathfinderMaxX = 33 + 1;
    public const int PathfinderMinY = -19;
    public const int PathfinderMaxY = 13 + 1;
    public static readonly uint ViewDetectCellWidth = 2 * CellWidth;
    public const int MinMapX = -255;
    public const int MaxMapX = 255;
    public const int MinMapY = -255;
    public const int MaxMapY = 255;
}
