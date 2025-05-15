package com.ankamagames.jerakine.types
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class Color implements IExternalizable
   {
      public var red:uint;
      
      public var green:uint;
      
      public var blue:uint;
      
      public function Color(param1:uint = 0)
      {
         super();
         this.parseColor(param1);
      }
      
      public function get color() : uint
      {
         return (this.red & 0xFF) << 16 | (this.green & 0xFF) << 8 | this.blue & 0xFF;
      }
      
      public function set color(param1:uint) : void
      {
         this.parseColor(param1);
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         this.red = param1.readUnsignedByte();
         this.green = param1.readUnsignedByte();
         this.blue = param1.readUnsignedByte();
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         param1.writeByte(this.red);
         param1.writeByte(this.green);
         param1.writeByte(this.blue);
      }
      
      public function toString() : String
      {
         return "[AdvancedColor(R=\"" + this.red + "\",G=\"" + this.green + "\",B=\"" + this.blue + "\")]";
      }
      
      public function release() : void
      {
         this.red = this.green = this.blue = 0;
      }
      
      public function adjustDarkness(param1:Number) : void
      {
         this.red = (1 - param1) * this.red;
         this.green = (1 - param1) * this.green;
         this.blue = (1 - param1) * this.blue;
      }
      
      public function adjustLight(param1:Number) : void
      {
         this.red += param1 * (255 - this.red);
         this.green += param1 * (255 - this.green);
         this.blue += param1 * (255 - this.blue);
      }
      
      private function parseColor(param1:uint) : void
      {
         this.red = (param1 & 0xFF0000) >> 16;
         this.green = (param1 & 0xFF00) >> 8;
         this.blue = param1 & 0xFF;
      }
   }
}

