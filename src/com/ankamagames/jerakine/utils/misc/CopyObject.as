package com.ankamagames.jerakine.utils.misc
{
   public class CopyObject
   {
      public function CopyObject()
      {
         super();
      }
      
      public static function copyObject(param1:Object, param2:Array = null) : Object
      {
         var _loc5_:String = null;
         var _loc3_:Object = new Object();
         var _loc4_:Array = DescribeTypeCache.getVariables(param1);
         for each(_loc5_ in _loc4_)
         {
            if(!(param2 && param2.indexOf(_loc5_) != -1 || _loc5_ == "prototype"))
            {
               _loc3_[_loc5_] = param1[_loc5_];
            }
         }
         return _loc3_;
      }
   }
}

