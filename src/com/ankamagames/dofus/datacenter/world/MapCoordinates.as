package com.ankamagames.dofus.datacenter.world
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class MapCoordinates implements IDataCenter
   {
      public static const MODULE:String = "MapCoordinates";
      
      private static const UNDEFINED_COORD:int = int.MIN_VALUE;
      
      public var compressedCoords:uint;
      
      public var mapIds:Vector.<int>;
      
      private var _x:int = -2147483648;
      
      private var _y:int = -2147483648;
      
      private var _maps:Vector.<MapPosition>;
      
      public function MapCoordinates()
      {
         super();
      }
      
      public static function getMapCoordinatesByCompressedCoords(param1:uint) : MapCoordinates
      {
         return GameData.getObject(MODULE,param1) as MapCoordinates;
      }
      
      public static function getMapCoordinatesByCoords(param1:int, param2:int) : MapCoordinates
      {
         return getMapCoordinatesByCompressedCoords((getCompressedValue(param1) << 16) + getCompressedValue(param2));
      }
      
      private static function getSignedValue(param1:int) : int
      {
         var _loc2_:* = (param1 & 0x8000) > 0;
         var _loc3_:* = param1 & 0x7FFF;
         return _loc2_ ? 0 - _loc3_ : _loc3_;
      }
      
      private static function getCompressedValue(param1:int) : uint
      {
         return param1 < 0 ? uint(0x8000 | param1 & 0x7FFF) : uint(param1 & 0x7FFF);
      }
      
      public function get x() : int
      {
         if(this._x == UNDEFINED_COORD)
         {
            this._x = getSignedValue((this.compressedCoords & 4294901760) >> 16);
         }
         return this._x;
      }
      
      public function get y() : int
      {
         if(this._y == UNDEFINED_COORD)
         {
            this._y = getSignedValue(this.compressedCoords & 0xFFFF);
         }
         return this._y;
      }
      
      public function get maps() : Vector.<MapPosition>
      {
         var _loc1_:int = 0;
         if(!this._maps)
         {
            this._maps = new Vector.<MapPosition>(this.mapIds.length,true);
            _loc1_ = 0;
            while(_loc1_ < this.mapIds.length)
            {
               this._maps[_loc1_] = MapPosition.getMapPositionById(this.mapIds[_loc1_]);
               _loc1_++;
            }
         }
         return this._maps;
      }
   }
}

