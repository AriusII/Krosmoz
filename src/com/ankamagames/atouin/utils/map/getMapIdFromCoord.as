package com.ankamagames.atouin.utils.map
{
   public function getMapIdFromCoord(param1:int, param2:int, param3:int) : int
   {
      var _loc4_:* = 2 << 12;
      var _loc5_:* = 2 << 8;
      if(param2 > _loc5_ || param3 > _loc5_ || param1 > _loc4_)
      {
         return -1;
      }
      var _loc6_:* = param1 & 0x0FFF;
      var _loc7_:* = Math.abs(param2) & 0xFF;
      if(param2 < 0)
      {
         _loc7_ |= 256;
      }
      var _loc8_:* = Math.abs(param3) & 0xFF;
      if(param3 < 0)
      {
         _loc8_ |= 256;
      }
      return _loc6_ << 18 | (_loc7_ << 9 | _loc8_);
   }
}

