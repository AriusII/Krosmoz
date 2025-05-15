package org.audiofx.mp3
{
   import flash.utils.ByteArray;
   
   internal class ByteArraySegment
   {
      public var start:uint;
      
      public var length:uint;
      
      public var byteArray:ByteArray;
      
      public function ByteArraySegment(param1:ByteArray, param2:uint, param3:uint)
      {
         super();
         this.byteArray = param1;
         this.start = param2;
         this.length = param3;
      }
   }
}

