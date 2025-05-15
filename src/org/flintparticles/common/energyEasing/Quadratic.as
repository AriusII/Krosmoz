package org.flintparticles.common.energyEasing
{
   public class Quadratic
   {
      public function Quadratic()
      {
         super();
      }
      
      public static function easeIn(param1:Number, param2:Number) : Number
      {
         return 1 - (param1 = param1 / param2) * param1;
      }
      
      public static function easeOut(param1:Number, param2:Number) : Number
      {
         param1 = 1 - param1 / param2;
         return param1 * param1;
      }
      
      public static function easeInOut(param1:Number, param2:Number) : Number
      {
         param1 = param1 / (param2 * 0.5);
         if(param1 < 1)
         {
            return 1 - param1 * param1 * 0.5;
         }
         param1 = param1 - 2;
         return param1 * param1 * 0.5;
      }
   }
}

