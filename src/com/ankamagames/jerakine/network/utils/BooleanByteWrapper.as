package com.ankamagames.jerakine.network.utils
{
   public class BooleanByteWrapper
   {
      public function BooleanByteWrapper()
      {
         super();
      }
      
      public static function setFlag(param1:uint, param2:uint, param3:Boolean) : uint
      {
         switch(param2)
         {
            case 0:
               if(param3)
               {
                  param1 |= 1;
                  break;
               }
               param1 &= 255 - 1;
               break;
            case 1:
               if(param3)
               {
                  param1 |= 2;
                  break;
               }
               param1 &= 255 - 2;
               break;
            case 2:
               if(param3)
               {
                  param1 |= 4;
                  break;
               }
               param1 &= 255 - 4;
               break;
            case 3:
               if(param3)
               {
                  param1 |= 8;
                  break;
               }
               param1 &= 255 - 8;
               break;
            case 4:
               if(param3)
               {
                  param1 |= 16;
                  break;
               }
               param1 &= 255 - 16;
               break;
            case 5:
               if(param3)
               {
                  param1 |= 32;
                  break;
               }
               param1 &= 255 - 32;
               break;
            case 6:
               if(param3)
               {
                  param1 |= 64;
                  break;
               }
               param1 &= 255 - 64;
               break;
            case 7:
               if(param3)
               {
                  param1 |= 128;
                  break;
               }
               param1 &= 255 - 128;
               break;
            default:
               throw new Error("Bytebox overflow.");
         }
         return param1;
      }
      
      public static function getFlag(param1:uint, param2:uint) : Boolean
      {
         switch(param2)
         {
            case 0:
               return (param1 & 1) != 0;
            case 1:
               return (param1 & 2) != 0;
            case 2:
               return (param1 & 4) != 0;
            case 3:
               return (param1 & 8) != 0;
            case 4:
               return (param1 & 0x10) != 0;
            case 5:
               return (param1 & 0x20) != 0;
            case 6:
               return (param1 & 0x40) != 0;
            case 7:
               return (param1 & 0x80) != 0;
            default:
               throw new Error("Bytebox overflow.");
         }
      }
   }
}

