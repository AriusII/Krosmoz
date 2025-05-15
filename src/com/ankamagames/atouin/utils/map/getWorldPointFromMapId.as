package com.ankamagames.atouin.utils.map
{
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   
   public function getWorldPointFromMapId(param1:uint) : WorldPoint
   {
      var _loc2_:uint = uint((param1 & 0x3FFC0000) >> 18);
      var _loc3_:* = param1 >> 9 & 0x01FF;
      var _loc4_:* = param1 & 0x01FF;
      if((_loc3_ & 0x0100) == 256)
      {
         _loc3_ = -(_loc3_ & 0xFF);
      }
      if((_loc4_ & 0x0100) == 256)
      {
         _loc4_ = -(_loc4_ & 0xFF);
      }
      return WorldPoint.fromCoords(_loc2_,_loc3_,_loc4_);
   }
}

